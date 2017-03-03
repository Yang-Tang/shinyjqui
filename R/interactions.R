
#' Initialize, enable or disable jQuery UI interactions
#'
#' These functions initialize or switch on/off jQuery UI interactions
#' (\href{http://api.jqueryui.com/draggable/}{draggable},
#' \href{http://api.jqueryui.com/droppable/}{droppable},
#' \href{http://api.jqueryui.com/resizable/}{resizable},
#' \href{http://api.jqueryui.com/selectable/}{selectable},
#' \href{http://api.jqueryui.com/sortable/}{sortable}) to shiny tag element(s).
#'
#' The function \code{jqui_draggabled}, \code{jqui_droppabled},
#' \code{jqui_resizabled}, \code{jqui_selectabled} and \code{jqui_sortabled}
#' initialize the interactions and should be used in \code{ui} of a shiny app.
#' The function \code{jqui_draggable}, \code{jqui_droppable},
#' \code{jqui_resizable}, \code{jqui_selectable} and \code{jqui_sortable} switch
#' on/off interactions and should be used in \code{server} of a shiny app.
#'
#' If an element has an \code{id} and its interaction is initialized or switched
#' on, users can get access to some internally defined shiny input values.
#' Please see the vignette \code{Introduction} for more details.Users can
#' override the default shiny input settings by passing a \code{shiny} option to
#' the \code{options} parameter. Please see the vignette \code{Introduction} for
#' more details.
#'
#' @param tag A shiny tag object to add interactions to.
#' @param selector A \href{https://api.jquery.com/category/selectors/}{jQuery's
#'   selector} that determines the shiny tag element(s) whose interaction is to
#'   be enabled or disabled.
#' @param switch A boolean value to determine whether to enable or disable an
#'   interaction.
#' @param options A list of interaction options. Ignored when \code{switch} is
#'   set as \code{FALSE}. In addition to the
#'   \href{http://api.jqueryui.com/category/interactions/}{internal options},
#'   this parameter also accept a shiny option that controls the shiny input
#'   value returned from the element.
#'
#' @return \code{jqui_draggabled}, \code{jqui_droppabled},
#'   \code{jqui_resizabled}, \code{jqui_selectabled} and \code{jqui_sortabled}
#'   returns a modified shiny tag with interation enabled.
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
