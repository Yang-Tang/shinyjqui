.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("shinyjqui.df", function(data, shinysession, name) {
    data <- lapply(data, function(x) {
      `if`(length(x) == 0, NA_character_, unlist(x))
    })
    data.frame(data, stringsAsFactors = FALSE)
  }, force = TRUE)
}

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
jquiHead <- function() {
  shiny::addResourcePath("shinyjqui", system.file("www", package = "shinyjqui"))
  shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(src = "shared/jqueryui/jquery-ui.min.js"),
      shiny::tags$link(rel = "stylesheet", href = "shared/jqueryui/jquery-ui.css"),
      shiny::tags$script(src = "shinyjqui/shinyjqui.js"),
      # shiny::tags$script(src = 'shinyjqui/shinyjqui.min.js')
      shiny::tags$script(src = "shinyjqui/jquery.ui.touch-punch.min.js")
    )
  )
}

## Idea from
## http://deanattali.com/blog/htmlwidgets-tips/#widget-to-r-data
## with some midifications.
sendMsg <- function() {
  shiny::insertUI("body", "afterBegin", jquiHead(), immediate = TRUE)
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
      options   = options
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

    shiny::addResourcePath("shinyjqui", system.file("www", package = "shinyjqui"))

    shiny::tagList(
      jquiHead(),

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

#' Create a jQuery UI icon
#'
#' Create an jQuery UI pre-defined icon. For lists of available icons, see
#' \url{http://api.jqueryui.com/theming/icons/}.
#'
#' @param name Class name of icon. The "ui-icon-" prefix can be omitted (i.e.
#'   use "ui-icon-flag" or "flag" to display a flag icon)
#'
#' @return An icon element
#' @export
#'
#' @examples
#' jqui_icon('caret-1-n')
#'
#' library(shiny)
#'
#' # add an icon to an actionButton
#' actionButton('button', 'Button', icon = jqui_icon('refresh'))
#'
#' # add an icon to a tabPanel
#' tabPanel('Help', icon = jqui_icon('help'))
jqui_icon <- function(name) {
  if (!grepl("^ui-icon-", name)) {
    name <- paste0("ui-icon-", name)
  }
  icon <- shiny::tags$i(class = paste0("ui-icon ", name))
  dep <- htmltools::htmlDependency(
    "jqueryui", "1.12.1",
    src = c(href = "shared/jqueryui"),
    script = "jquery-ui.min.js",
    stylesheet = "jquery-ui.css"
  )
  htmltools::attachDependencies(icon, dep)
}
