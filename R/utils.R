#' @importFrom htmlwidgets JS
#' @export
htmlwidgets::JS

## add location index of JS expressions needed to be evaled in javascript side
addJSIdx <- function(list) {
  list$`_js_idx` <- rapply(
    list, is.character, classes = "JS_EVAL",
    deflt = FALSE, how = "list"
  )
  return(list)
}

## return a shiny head tag with necessary js and css for shinyjqui
jquiDep <- function() {
  htmltools::tagList(
    htmltools::htmlDependency(
      name       = "jqueryui",
      version    = "1.12.1",
      package    = "shiny",
      src        = "www/shared/jqueryui",
      script     = "jquery-ui.min.js",
      stylesheet = "jquery-ui.css"
    ),
    htmltools::htmlDependency(
      name    = "touch-punch",
      version = "0.2.3",
      package = "shinyjqui",
      src     = "www",
      script  = "jquery.ui.touch-punch.min.js"
    ),
    htmltools::htmlDependency(
      name    = "shinyjqui-assets",
      version = "0.4.0",
      package = "shinyjqui",
      src     = "www",
      script  = ifelse(getOption("shinyjqui.debug"), "shinyjqui.js", "shinyjqui.min.js")
    )
  )
}

## Idea from
## http://deanattali.com/blog/htmlwidgets-tips/#widget-to-r-data
## with some midifications.
## Send custom shinyjqui message from server to ui
## The message usually have the following components:
##   ui: the target element, selector or jq object
##   type: charactor, can be "interaction", "effect", "class"
##   func: charactor, type-specific func name
##   options: list, func-specific options
##   operation: charactor, only for interactions
##   _js_idx: boolean list
##   debug: boolean

sendMsg <- function() {
  shiny::insertUI("body", "afterBegin", jquiDep(), immediate = TRUE)
  # message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  message <- Filter(Negate(is.symbol), as.list(parent.frame(1)))
  message <- addJSIdx(message)
  message[["debug"]] <- getOption("shinyjqui.debug")
  session <- shiny::getDefaultReactiveDomain()
  # send message only after session flushed, this ensures the target element is
  # fully rendered when the message contains js codes.
  session$onFlushed(function() {
    session$sendCustomMessage("shinyjqui", message)
  })
}

randomChars <- function() {
  paste0(sample(c(letters, LETTERS, 0:9), size = 8, replace = TRUE), collapse = "")
}

addInteractJSShiny <- function(tag, func, options = NULL) {
  if (inherits(tag, "shiny.tag.list")) {

    # use `[<-` to keep original attributes of tagList
    tag[] <- lapply(tag, addInteractJSShiny, func = func, options = options)
    return(tag)

  } else if (inherits(tag, "html_dependency")) {
    # leave the jquiDep() from a shiny.tag.list as is, without checking the
    # `shiny.tag` class
    return(tag)

  } else if (inherits(tag, "shiny.tag")) {

    if (is.null(tag$name) ||
      tag$name %in% c("style", "script", "head", "meta", "br", "hr")) {
      return(tag)
    }

    id <- shiny::tagGetAttribute(tag, "id")
    class <- shiny::tagGetAttribute(tag, "class")
    if (!is.null(id)) {
      # when id contains spaces, `#id` will not work
      selector <- sprintf("[id='%s']", id)
    } else if (!is.null(class) && grepl("jqui-interaction-", class)) {
      class <- unlist(strsplit(class, " "))
      class <- grep("jqui-interaction-", class, value = TRUE)
      selector <- paste0(".", class)
    } else {
      class <- sprintf("jqui-interaction-%s", randomChars())
      tag <- shiny::tagAppendAttributes(tag, class = class)
      selector <- paste0(".", class)
    }

    msg <- list(
      ui        = selector,
      type      = "interaction",
      func      = func,
      operation = "enable",
      options   = options,
      debug     = getOption("shinyjqui.debug")
    )
    msg <- addJSIdx(msg)

    # remove the script after call, so that the next created or inserted element
    # with same selector can be called again
    js <- sprintf(
      'shinyjqui.msgCallback(%s);
      $(".jqui_self_cleaning_script").remove();',
      jsonlite::toJSON(msg, auto_unbox = TRUE, force = TRUE)
    )

    # Wait for a while so that shiny initialized. This ensures the
    # Shiny.onInputChange works and all the shiny inputs have class
    # shiny-bound-input and all the shiny outputs have class
    # shiny-bound-output.
    js <- sprintf("setTimeout(function(){%s}, 10);", js)

    if (!is.null(tag$attribs$class) &&
      grepl("html-widget-output|shiny-.+?-output", tag$attribs$class)) {
      # For shiny/htmlwidgets output elements, in addition to wait for a while,
      # we have to call js on "shiny:value" event. This ensures js get the
      # correct element dimension especially when the output element is hidden on
      # shiny initialization. The initialization only needs to be run once, so
      # .one() is used here. Use selector inside .one() to ensure the run-once
      # js only triggered on the target element
      js <- sprintf(
        '$(document).one(
            events   = "shiny:value",
            selector = "[id=\'%s\']",
            handler  = function(e) { %s }
        );',
        id, js
      )
    }

    # run js on document ready
    js <- sprintf("$(function(){%s});", js)

    htmltools::tagList(
      jquiDep(),
      tag,

      # made this script self removable.
      # shiny::singleton should not be used here. As it prevent the same script
      # from insertion even after the first one was removed
      # shiny::tags$head should not be used to wrap the script. It seems
      # shiny::tags$head is not working in flexdashboard
      # When a tagList like this is inserted by `insertUI`, the embedded
      # tags$script() will not be executed, but tags$head(tags$script()) will.
      # However, for the compatibility to flexdashboard, we can't use tags$head here.
      # So, an invisible iframe with onload is used to get around
      # idea from https://github.com/rstudio/shiny/issues/1545#issuecomment-287903607

      # htmltools::tags$head(htmltools::tags$script(
      #   class = "jqui_self_cleaning_script",
      #   shiny::HTML(js)
      # )),
      # htmltools::tags$script(
      #   class = "jqui_self_cleaning_script",
      #   shiny::HTML(js),
      # ),
      htmltools::tags$iframe(
        srcdoc = "<p>Hello world!</p>",
        class  = "jqui_self_cleaning_script",
        style  = "width:0;height:0;border:none;display:none !important",
        onload = shiny::HTML(js)
      )
    )

  } else {
    warning("The tag provided is not a shiny tag. Action abort.")
    return(tag)
  }
}

# Add interactions to a static htmlwidget in RStudio Viwer, webpage or RMarkdown
# This was done by appending a tagList to the htmlwidget object. The tagList contains
# the dependencies and js code to initiate the interaction
# For htmlwidgets, the insterction always attached to their wrappers or containers to
# avoid the destruction of resizable handlers by widget redraw.
# In the case of RStudio Viwer or webpage, the htmlwidget is already wrapped by
# div#htmlwidget_container, so no need to add another wrapper
# In the case of RMarkdown, the div#htmlwidget-xxxxxxxxxxxx is naked, therefore,
# wrapping is needed
# According to htmlwidgets.js, the resizing of a staticRendered htmlwidget can be
# triggered by the "resize" event from window or some other events from document,
# includeing "shown.htmlwidgets shown.bs.tab.htmlwidgets shown.bs.collapse.htmlwidgets"
# I found $(window).trigger("resize") is not working (don't know why), so
# "shown.htmlwidgets" is used here.
addInteractJSHTMLWidget <- function(x, func, options = NULL) {

  # dep_tag:

  # jquery dependency is needed for htmlwidget mode
  jquery_dep <- list(
    htmltools::htmlDependency(
      name       = "jquery",
      version    = "3.4.1",
      package    = "shiny",
      src        = "www/shared",
      script     = "jquery.min.js"
    )
  )
  dep_tag <- c(jquery_dep, jquiDep())

  # script_tag:

  # Give an id to the script tag appended. The id will then be used to find the sibling
  # htmlwidget with id "htmlwidget-xxxxxxxxxxxx" and class "html-widget html-widget-static-bound"
  script_id <- sprintf("jqui-interaction-%s", randomChars())

  widget_sel <- "div.html-widget-static-bound"
  # use .parent().find() to locate the sibling htmlwidget. The target htmlwidget could be
  # a "nephew" if it was already wrapped by div.jqui-wrapper
  widget <- htmlwidgets::JS(sprintf('$("#%s").parent().find("%s").get(0)', script_id, widget_sel))

  msg <- list(
    ui        = widget,
    type      = "interaction",
    func      = func,
    operation = "enable",
    options   = options,
    debug     = getOption("shinyjqui.debug")
  )
  msg <- addJSIdx(msg)
  msg_json <- jsonlite::toJSON(msg, auto_unbox = TRUE, force = TRUE)

  js <- sprintf("shinyjqui.msgCallback(%s);", msg_json)

  # for resizable, link the resize event to the resizeHandler from htmlwidgets.js by
  # triggering "shown.htmlwidgets" event
  if(msg$func == "resizable") {
    resize_js <- sprintf(
      '$(%s).parent().on("resize", function() { $(document).trigger("shown.htmlwidgets"); })',
      msg$ui
    )
    js <- paste0(js, resize_js, collapse = "\n")
  }

  js <- sprintf("HTMLWidgets.addPostRenderHandler(function() {%s});", shiny::HTML(js))

  script_tag <- htmltools::tags$script(id = script_id, js)

  htmlwidgets::appendContent(x, htmltools::tagList(dep_tag, script_tag))

}
