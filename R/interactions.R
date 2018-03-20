
#' Mouse interactions
#'
#' Attach mouse-based interactions to shiny html tags and input/output widgets,
#' and provide ways to manipulate them. The interaction includes:
#' * [draggable](http://api.jqueryui.com/draggable/): Allow elements to be
#' moved using the mouse.
#' * [droppable](http://api.jqueryui.com/droppable/): Create targets for
#' draggable elements.
#' * [resizable](http://api.jqueryui.com/resizable/): Change the size of an
#' element using the mouse.
#' * [selectable](http://api.jqueryui.com/selectable/): Use the mouse to select
#' elements, individually or in a group.
#' * [sortable](http://api.jqueryui.com/sortable/): Reorder elements in a list
#' or grid using the mouse.
#'
#' The functions `jqui_draggabled()`, `jqui_droppabled()`, `jqui_resizabled()`,
#' `jqui_selectabled()` and `jqui_sortabled()` are used to attach mouse
#' interactions to a given shiny html widget (defined by `tag` parameter) and
#' therefore should be used in `ui` of a shiny app.
#'
#' The functions `jqui_draggable()`, `jqui_droppable()`, `jqui_resizable()`,
#' `jqui_selectable()` and `jqui_sortable()` should be used in `server` of a
#' shiny app. They locate target element(s) in shiny (by `selector` parameter)
#' and manipulate their mouse interactions. The currently supported operations
#' includes:
#' * `enable`: Attach corresponding mouse interaction to the target(s).
#' * `disable`: Distroy corresponding mouse interaction of the target(s).
#' * `save`: Save the current interaction state .
#' * `load`: Restore the target(s) to the last saved interaction state.
#'
#' With mouse interactions attached, some internally defined shiny input values
#' (in the form of `input$<id>_<state>`) can be used to refer to
#' cosrresponding interaction state, e.g. `position`, `size`, `selected` and
#' `order`. Users can add or override these default settings by passing a
#' `shiny` option to the `options` parameter. Please see the vignette
#' `Introduction to shinyjqui` for more details.
#'
#' @param tag A shiny tag object to attach mouse interactions to.
#' @param selector The target element(s) to be menipulated. Can be a string of
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) or a
#'   [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](http://api.jquery.com/Types/#jQuery).
#' @param operation A string to determine how to menipulate the mosue interaction.
#'   Should be one of `enable`, `disable`, `save` and `load`
#' @param options A list of
#'   [interaction_specific_options](http://api.jqueryui.com/category/interactions/).
#'   Ignored when `operation` is set as `disable` or `save`. This parameter also
#'   accept a `shiny` option that controls the shiny input value returned from
#'   the element. See Details.
#'  @param switch Deprecated, just keep for backward compatibility. Please use
#'   `operation` instead.
#'
#' @return `jqui_draggabled()`, `jqui_droppabled()`, `jqui_resizabled()`,
#'   `jqui_selectabled()` and `jqui_sortabled()` returns a modified shiny tag
#'   object with mouse interactions attached. `jqui_draggable()`,
#'   `jqui_droppable()`, `jqui_resizable()`, `jqui_selectable()` and
#'   `jqui_sortable()` returns their first parameter `selector`.
#'
#' @example examples/interactions.R
#' @name Interactions
NULL


#' @rdname Interactions
#' @export
jqui_resizabled <- function(tag, options = NULL) {
  addInteractJS(tag, "resizable", options)
}


#' @rdname Interactions
#' @export
jqui_sortabled <- function(tag, options = NULL) {
  addInteractJS(tag, "sortable", options)
}


#' @rdname Interactions
#' @export
jqui_draggabled <- function(tag, options = NULL) {
  addInteractJS(tag, "draggable", options)
}


#' @rdname Interactions
#' @export
jqui_droppabled <- function(tag, options = NULL) {
  addInteractJS(tag, "droppable", options)
}


#' @rdname Interactions
#' @export
jqui_selectabled <- function(tag, options = NULL) {
  addInteractJS(tag, "selectable", options)
}


#' @rdname Interactions
#' @export
jqui_sortable <- function(selector,
                          operation = c("enable", "disable", "save", "load"),
                          options = NULL, switch = NULL) {
  type <- "interaction"
  func <- "sortable"

  if (!is.null(switch) && is.logical(switch)) {
    operation <- switch[1]
  }
  if (is.logical(operation)) {
    warning("The switch parameter is deprecated,
            please use the operation parameter instead")
    operation <- ifelse(operation[1], "enable", "disable")
  }
  rm(switch)

  operation <- match.arg(operation)
  sendMsg()
  return(selector)
}


#' @rdname Interactions
#' @export
jqui_draggable <- function(selector,
                           operation = c("enable", "disable", "save", "load"),
                           options = NULL, switch = NULL) {
  type <- "interaction"
  func <- "draggable"

  if (!is.null(switch) && is.logical(switch)) {
    operation <- switch[1]
  }
  if (is.logical(operation)) {
    warning("The switch parameter is deprecated,
            please use the operation parameter instead")
    operation <- ifelse(operation[1], "enable", "disable")
  }
  rm(switch)

  operation <- match.arg(operation)
  sendMsg()
  return(selector)
}


#' @rdname Interactions
#' @export
jqui_droppable <- function(selector,
                           operation = c("enable", "disable", "save", "load"),
                           options = NULL, switch = NULL) {
  type <- "interaction"
  func <- "droppable"

  if (!is.null(switch) && is.logical(switch)) {
    operation <- switch[1]
  }
  if (is.logical(operation)) {
    warning("The switch parameter is deprecated,
            please use the operation parameter instead")
    operation <- ifelse(operation[1], "enable", "disable")
  }
  rm(switch)

  operation <- match.arg(operation)
  sendMsg()
  return(selector)
}


#' @rdname Interactions
#' @export
jqui_selectable <- function(selector,
                            operation = c("enable", "disable", "save", "load"),
                            options = NULL, switch = NULL) {
  type <- "interaction"
  func <- "selectable"

  if (!is.null(switch) && is.logical(switch)) {
    operation <- switch[1]
  }
  if (is.logical(operation)) {
    warning("The switch parameter is deprecated,
            please use the operation parameter instead")
    operation <- ifelse(operation[1], "enable", "disable")
  }
  rm(switch)

  operation <- match.arg(operation)
  sendMsg()
  return(selector)
}


#' @rdname Interactions
#' @export
jqui_resizable <- function(selector,
                           operation = c("enable", "disable", "save", "load"),
                           options = NULL, switch = NULL) {
  type <- "interaction"
  func <- "resizable"

  if (!is.null(switch) && is.logical(switch)) {
    operation <- switch[1]
  }
  if (is.logical(operation)) {
    warning("The switch parameter is deprecated, please use the operation parameter instead")
    operation <- ifelse(operation[1], "enable", "disable")
  }
  rm(switch)

  operation <- match.arg(operation)
  sendMsg()
  return(selector)
}



#' Enable bookmarking state of mouse interactions
#'
#' Enable shiny
#' [bookmarking_state](https://shiny.rstudio.com/articles/bookmarking-state.html)
#' of mouse interactions. By calling this function in `server`, the elements'
#' `position`, `size`, `selection state` and `sorting state` changed by mouse
#' operations can be saved and restored through an URL.
#'
#' @export
jqui_bookmarking <- function() {
  shiny::onRestored(function(state) {
    inputs <- state$input
    for (name in names(inputs)) {
      if (!grepl("__shinyjquiBookmarkState__", name)) next()
      info <- strsplit(name, "__")[[1]]
      selector <- paste0("#", info[1])
      options <- list(state = inputs[[name]])
      func <- switch(info[3],
        "draggable" = jqui_draggable,
        "droppable" = jqui_droppable,
        "resizable" = jqui_resizable,
        "sortable" = jqui_sortable,
        "selectable" = jqui_selectable
      )
      func(selector = selector, operation = "load", options = options)
    }
  })
}
