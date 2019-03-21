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
  list(
    htmltools::htmlDependency(
      name       = "jqueryui", version = "1.12.1",
      package    = "shiny",
      src        = "www/shared/jqueryui",
      script     = "jquery-ui.min.js",
      stylesheet = "jquery-ui.css"
    ),
    htmltools::htmlDependency(
      name    = "shinyjqui-assets", version = "0.3.2",
      package = "shinyjqui",
      src     = "www",
      script  = ifelse(getOption("shinyjqui.debug"), "shinyjqui.js", "shinyjqui.min.js")
    )
  )
}

## Idea from
## http://deanattali.com/blog/htmlwidgets-tips/#widget-to-r-data
## with some midifications.
sendMsg <- function() {
  shiny::insertUI("body", "afterBegin", jquiDep(), immediate = TRUE)
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  message <- addJSIdx(message)
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

addInteractJS <- function(tag, func, options = NULL) {
  if (inherits(tag, "shiny.tag.list")) {

    # use `[<-` to keep original attributes of tagList
    tag[] <- lapply(tag, addInteractJS, func = func, options = options)
    return(tag)

  } else if (inherits(tag, "shiny.tag")) {

    if (is.null(tag$name) ||
      tag$name %in% c("style", "script", "head", "meta", "br", "hr")) {
      return(tag)
    }

    id <- tag$attribs$id
    if (!is.null(id)) {
      # when id contains spaces, `#id` will not work
      selector <- sprintf("[id='%s']", id)
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
      $("head .jqui_self_cleaning_script").remove();',
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
      # correct element dimension especially when the output element is hiden on
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

    shiny::tagList(
      jquiDep(),
      shiny::tags$head(
        # made this script self removable. shiny::singleton should not be used
        # here. As it prevent the same script from insertion even after the
        # first one was removed
        shiny::tags$script(class = "jqui_self_cleaning_script", js)
      ),
      tag
    )

  } else {
    warning("The tag provided is not a shiny tag. Action abort.")
    return(tag)
  }
}
