
#' Mouse interactions
#'
#' These functions initialize or switch on/off jQuery UI mouse interactions
#' ([draggable](http://api.jqueryui.com/draggable/),
#' [droppable](http://api.jqueryui.com/droppable/),
#' [resizable](http://api.jqueryui.com/resizable/),
#' [selectable](http://api.jqueryui.com/selectable/),
#' [sortable](http://api.jqueryui.com/sortable/)) to shiny tag element(s).
#'
#' The function `jqui_draggabled`, `jqui_droppabled`, `jqui_resizabled`,
#' `jqui_selectabled` and `jqui_sortabled` initialize the element's interactions
#' and should be used in `ui` of a shiny app. The function `jqui_draggable`,
#' `jqui_droppable`, `jqui_resizable`, `jqui_selectable` and `jqui_sortable`
#' switch on/off interactions and should be used in `server` of a shiny app.
#'
#' If an element has an `id` and its interaction is initialized or switched on,
#' users can get access to some internally defined shiny input values. Users can
#' override the default shiny input settings by passing a `shiny` option to the
#' `options` parameter. Please see the vignette `Introduction to shinyjqui` for
#' more details.
#'
#' @param tag A shiny tag object to add interactions to.
#' @param selector A
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) that
#'   determines the shiny tag element(s) whose interaction is to be enabled or
#'   disabled.
#' @param method A string to determine the operation related to the interaction
#'   type. Should be one of `enable`, `disable`, `save` and `load`
#' @param options A list of interaction options. Ignored when `method` is set as
#'   `disable` or `save`. In addition to the
#'   [interaction_specific_options](http://api.jqueryui.com/category/interactions/),
#'    this parameter also accept a shiny option that controls the shiny input
#'   value returned from the element. See Details.
#'
#' @return `jqui_draggabled`, `jqui_droppabled`, `jqui_resizabled`,
#'   `jqui_selectabled` and `jqui_sortabled` returns a modified shiny tag object
#'   with interaction enabled.
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
                          method = c("enable", "disable", "save", "load"),
                          options = NULL) {
  type <- "interaction"
  func <- "sortable"
  method <- match.arg(method)
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_draggable <- function(selector,
                           method = c("enable", "disable", "save", "load"),
                           options = NULL) {
  type <- "interaction"
  func <- "draggable"
  method <- match.arg(method)
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_droppable <- function(selector,
                           method = c("enable", "disable", "save", "load"),
                           options = NULL) {
  type <- "interaction"
  func <- "droppable"
  method <- match.arg(method)
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_selectable <- function(selector,
                            method = c("enable", "disable", "save", "load"),
                            options = NULL) {
  type <- "interaction"
  func <- "selectable"
  method <- match.arg(method)
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_resizable <- function(selector,
                           method = c("enable", "disable", "save", "load"),
                           options = NULL) {
  type <- "interaction"
  func <- "resizable"
  method <- match.arg(method)
  sendMsg()
}



#' Enable bookmarking state of mouse interactions
#'
#' Enable shiny
#' [bookmarking_state](https://shiny.rstudio.com/articles/bookmarking-state.html)
#' for elements with mouse interactions initiated. By calling this function in
#' server, the `position`, `size`, `selection state` and `sorting state` of
#' elements can be saved and restored through an URL.
#'
#' __Limitations:__
#' * The target element should have an `id`
#' * Cann't restore items who were moved from other sortable elements with
#' `connectWith` settings
#'
#' @export
#'
#' @examples
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
      func(selector = selector, method = "load", options = options)
    }
  })
}
