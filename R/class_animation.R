
#' Class animation.
#'
#' These functions are the R wrappers of
#' \href{http://api.jqueryui.com/addClass/}{addClass()},
#' \href{http://api.jqueryui.com/addClass/}{removeClass()},
#' \href{http://api.jqueryui.com/addClass/}{switchClass()} in jQuery UI library.
#' They should be used in \code{server} of a shiny document.
#'
#' \describe{ \item{\code{jqui_add_class}}{Adds the specified class(es) to each
#' of the set of matched elements while animating all style changes.}
#' \item{\code{jqui_remove_class}}{Removes the specified class(es) from each of
#' the set of matched elements while animating all style changes.}
#' \item{\code{jqui_switch_class}}{Adds and removes the specified class(es) to
#' each of the set of matched elements while animating all style changes} }
#'
#' @param selector A \href{https://api.jquery.com/category/selectors/}{jQuery's
#'   selector} that determines the shiny tag element(s) whose interaction is
#'   enable or disable interactions.
#' @param className One or more class names (space separated) to be added to or
#'   removed from the class attribute of each matched element.
#' @param duration A string or number determining how long the animation will
#'   run.
#' @param easing A string indicating which
#'   \href{http://api.jqueryui.com/easings/}{easing} function to use for the
#'   transition.
#' @param complete A js function to call once the animation is complete, called
#'   once per matched element.
#' @param removeClassName One or more class names (space separated) to be
#'   removed from the class attribute of each matched element.
#' @param addClassName One or more class names (space separated) to be added to
#'   the class attribute of each matched element.
#'
#' @example examples/class_animation.R
#' @name Class_animation
NULL


#' @rdname Class_animation
#' @export
jqui_add_class <- function(selector, className, duration = 400,
                           easing = 'swing', complete = NULL) {
  type <- 'class'
  func <- 'add'
  options <- list(className = className,
                  duration  = duration,
                  easing    = easing,
                  complete  = complete)
  rm(className, duration, easing, complete)
  sendMsg()
}


#' @rdname Class_animation
#' @export
jqui_remove_class <- function(selector, className, duration = 400,
                              easing = 'swing', complete = NULL) {
  type <- 'class'
  func <- 'remove'
  options <- list(className = className,
                  duration  = duration,
                  easing    = easing,
                  complete  = complete)
  rm(className, duration, easing, complete)
  sendMsg()
}


#' @rdname Class_animation
#' @export
jqui_switch_class <- function(selector, removeClassName, addClassName,
                        duration = 400, easing = 'swing', complete = NULL) {
  type <- 'class'
  func <- 'switch'
  options <- list(removeClassName = removeClassName,
                  addClassName    = addClassName,
                  duration        = duration,
                  easing          = easing,
                  complete        = complete)
  rm(removeClassName, addClassName, duration, easing, complete)
  sendMsg()
}
