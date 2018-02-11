
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
#' @param switch A boolean value to determine whether to enable or disable an
#'   interaction.
#' @param options A list of interaction options. Ignored when `switch` is set as
#'   `FALSE`. In addition to the
#'   [interaction_specific_options](http://api.jqueryui.com/category/interactions/),
#'   this parameter also accept a shiny option that controls the shiny input
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
  addInteractJS(tag, 'resizable', options)
}


#' @rdname Interactions
#' @export
jqui_sortabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'sortable', options)
}


#' @rdname Interactions
#' @export
jqui_draggabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'draggable', options)
}


#' @rdname Interactions
#' @export
jqui_droppabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'droppable', options)
}


#' @rdname Interactions
#' @export
jqui_selectabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'selectable', options)
}


#' @rdname Interactions
#' @export
jqui_sortable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'sortable'
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_draggable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'draggable'
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_droppable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'droppable'
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_selectable <- function(selector, switch = TRUE, options = NULL) {
  method = 'interaction'
  func <- 'selectable'
  sendMsg()
}


#' @rdname Interactions
#' @export
jqui_resizable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'resizable'
  sendMsg()
}


#' jqui_resize <- function(selector, width = NULL, height = NULL) {
#'   method <- 'update_interaction'
#'   func <- 'resize'
#'   options <- list()
#'   if(!is.null(width)) options$width = width
#'   if(!is.null(height)) options$height = height
#'   rm(width, height)
#'   sendMsg()
#' }



#' jqui_position <- function(selector, position = "center",
#'                           against = NULL, against_position = "center",
#'                           collision = "flip",
#'                           using = NULL,
#'                           within = "window") {
#'   method <- 'update_interaction'
#'   func <- 'position'
#'   options <- list(my        = position,
#'                   at        = against_position,
#'                   of        = against,
#'                   collision = collision,
#'                   using     = using,
#'                   within    = within)
#'   rm(position, against, against_position, collision, using, within)
#'   sendMsg()
#' }


#' jqui_drag <- function(selector, top, left)
