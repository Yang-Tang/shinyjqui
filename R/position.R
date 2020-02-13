#' Position an element relative to another
#'
#' Wrapper of the jQuery UI [.position()](https://api.jqueryui.com/position/)
#' method, allows you to position an element relative to the window, document,
#' another element, or the cursor/mouse, without worrying about offset parents.
#'
#' @param ui Which element to be positioned. Can be a string of
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) or a
#'   [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](http://api.jquery.com/Types/#jQuery). Only the first
#'   matching element will be used.
#' @param my String. Defines which position __on the element being positioned__
#'   to align with the target element: "horizontal vertical" alignment. A single
#'   value such as "right" will be normalized to "right center", "top" will be
#'   normalized to "center top" (following CSS convention). Acceptable
#'   horizontal values: "left", "center", "right". Acceptable vertical values:
#'   "top", "center", "bottom". Example: "left top" or "center center". Each
#'   dimension can also contain offsets, in pixels or percent, e.g., "right+10
#'   top-25%". Percentage offsets are relative to the element being positioned.
#' @param at String. Defines which position __on the target element__ to align
#'   the positioned element against: "horizontal vertical" alignment. See the
#'   `my` option for full details on possible values. Percentage offsets are
#'   relative to the target element.
#' @param of Which element to position against. Can be a string of
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) or a
#'   [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](http://api.jquery.com/Types/#jQuery). Only the first
#'   matching element will be used.
#' @param collision String. When the positioned element overflows the window in
#'   some direction, move it to an alternative position. Similar to `my` and
#'   `at`, this accepts a single value or a pair for horizontal/vertical, e.g.,
#'   "flip", "fit", "fit flip", "fit none".
#'
#'   * "flip": Flips the element to the opposite side of the target and the
#'   collision detection is run again to see if it will fit. Whichever side
#'   allows more of the element to be visible will be used.
#'
#'   * "fit": Shift the element away from the edge of the window.
#'
#'   * "flipfit": First applies the flip logic, placing the element on whichever
#'   side allows more of the element to be visible. Then the fit logic is
#'   applied to ensure as much of the element is visible as possible.
#'
#'   * "none": Does not apply any collision detection.
#' @param within Element to position within, affecting collision detection. Can
#'   be a string of
#'   [jQuery_selector](https://api.jquery.com/category/selectors/) or a
#'   [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](http://api.jquery.com/Types/#jQuery). Only the first
#'   matching element will be used.
#'
#' @export
#'
#' @examples
jqui_position <- function(ui, my = "center", at = "center", of,
                          collision = "flip", within = JS("$(window)")) {
  type <- "other"
  func <- "position"
  options <- list(
    my        = my,
    at        = at,
    of        = of,
    collision = collision,
    within    = within
  )
  rm(my, at, of, collision, within)
  sendMsg()
}
