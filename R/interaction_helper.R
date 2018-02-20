# updating shiny input value not supported


#' Change the size of an element
#'
#' Change the width and height of target element(s) by JavaScript.
#'
#' Somehow, in Firefox, this function is no working when the target element is a
#' shiny output.
#'
#' @param selector A
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) that defines
#'   the target element(s).
#' @param width The CSS width to set to the target element(s). Can be a either a
#'   string, a number or a `JS()` wrapped JavaScript function. See
#'   [details](http://api.jquery.com/width/#width2).
#' @param height The CSS height to set to the target element(s). Can be either a
#'   string, a number or a `JS()` wrapped JavaScript function. See
#'   [details](http://api.jquery.com/height/#height2).
#'
#' @export
#'
#' @examples
jqui_resize <- function(selector, width = NULL, height = NULL) {
  type    <- 'interaction'
  func    <- 'resizable'
  method  <- "change"
  options <- list()
  if(!is.null(width)) options$width = width
  if(!is.null(height)) options$height = height
  rm(width, height)
  sendMsg()
}



#' Change the position of an element relative to another
#'
#' Change the position of the positioned element(s) relative to target element
#' by JavaScript. This is a wrapper of jQuery UI function
#' [.position()](http://api.jqueryui.com/position/). Please refer to the
#' function document for more details.
#'
#' @param selector A
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) that defines
#'   the element(s) of which the position to change.
#' @param collision A string. When the positioned element overflows the window
#'   in some direction, move it to an alternative position, e.g., `"flip"`,
#'   `"fit"`, `"fit flip"`, `"fit none"`.
#' @param using A `JS()` wrapped JavaScript callback function. When specified,
#'   the actual property setting is delegated to this callback.
#' @param within Element to position within, affecting collision detection.
#' @param my A string that defines which position on the element being
#'   positioned to align with the target element, e.g., `"center"`, `"right
#'   center"`, `"left bottom"`, `"right+10 top-25"`.
#' @param at A string that defines which position on the target element to align
#'   the positioned element against, e.g., `"center"`, `"right center"`, `"left
#'   bottom"`, `"right+10 top-25"`.
#' @param of Defines the target element to position against. Can be either a
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) or a `JS()`
#'   wrapped [jQuery_object](http://api.jquery.com/Types/#jQuery)
#'
#' @export
#'
#' @examples
jqui_drag <- function(selector, my = "center", at = "center", of = "body",
                          collision = "flip", using = NULL, within = "body") {
  type <- 'update_interaction'
  func <- 'drag'
  options <- list(my        = my,
                  at        = at,
                  of        = of,
                  collision = collision,
                  using     = using,
                  within    = within)
  rm(my, at, of, collision, using, within)
  sendMsg()
}

#' Reorder the children of target element(s)
#'
#' Sort the children of target element(s) in a given order.
#'
#' @param items A integer vector that defines the order to sort. For example,
#'   `c(3, 2, 1)` means to sort the first three children elements in the
#'   reversed order.
#' @param selector A
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) that defines
#'   the element(s) whose children to sort.
#'
#' @export
#'
#' @examples
jqui_sort <- function(selector, items) {
  type <- 'update_interaction'
  func <- 'sort'
  options <- list(items = as.integer(items))
  rm(order)
  sendMsg()
}
