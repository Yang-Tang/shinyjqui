
#' Initiate jQuery UI interactions
#'
#' These functions should be used in \code{ui} of a shiny document that initiate
#' interactions of shiny tag element(s).
#'
#' @param tag A shiny tag to enable interaction.
#' @param options A list of interaction options. Please see
#'   \url{http://api.jqueryui.com/category/interactions/} for more details.
#'
#' @return A modified shiny tag with interation enabled.
#'
#' @examples
#' @name Interactions_initializer
NULL


#' @rdname Interactions_initializer
#' @export
jqui_resizabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'resizable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_sortabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'sortable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_draggabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'draggable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_droppabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'droppable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_selectabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'selectable', options)
}




#' Enable or disable jQuery UI interactions
#'
#' These functions should be used in \code{server} of a shiny document that
#' enable or disable interactions of shiny tag element(s).
#'
#' @param selector A \href{https://api.jquery.com/category/selectors/}{jQuery's
#'   selector} that determines the shiny tag element(s) whose interaction is
#'   enable or disable interactions.
#' @param switch A boolean value to determine whether to enable or disable an
#'   interaction.
#' @param options A list of interaction options. Ignored when \code{switch} is
#'   set as \code{FALSE}. Please see
#'   \url{http://api.jqueryui.com/category/interactions/} for more details.
#'
#' @examples
#' @name Interactions_switcher
NULL


#' @rdname Interactions_switcher
#' @export
jqui_sortable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'sortable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_draggable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'draggable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_droppable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'droppable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_selectable <- function(selector, switch = TRUE, options = NULL) {
  method = 'interaction'
  func <- 'selectable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_resizable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'resizable'
  sendMsg()
}
