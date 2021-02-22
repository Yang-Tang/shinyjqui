animationEffects <- function(ui, func, effect, options, duration, complete) {
  effect <- match.arg(effect, choices = get_jqui_effects())
  if (effect == "transfer" && func %in% c("show", "hide", "toggle")) {
    stop("The transfer effect is not supported in show/hide/toggle.")
  }
  type <- "effect"
  options <- list(
    effect = effect,
    options = options,
    duration = duration,
    complete = complete
  )
  rm(effect, duration, complete)
  sendMsg()
}


#' Animation effects.
#'
#' Allow element(s) to show animation effects.
#' * `jqui_effect()`: Apply an animation effect to matched element(s).
#' * `jqui_hide()`: Hide the matched element(s) with animation effect.
#' * `jqui_show()`: Display the matched element(s) with animation effect.
#' * `jqui_toggle()`: Display or hide the matched element(s) with animation effect.
#'
#' These functions are R wrappers of
#' [`effect()`](https://api.jqueryui.com/effect/),
#' [`hide()`](https://api.jqueryui.com/hide/),
#' [`show()`](https://api.jqueryui.com/show/) and
#' [`toggle()`](https://api.jqueryui.com/toggle/) from jQuery UI library. They
#' should be used in `server` of a shiny document.
#'
#'
#' @param ui The target ui element(s) to be manipulated. Can be
#'   * A string of [jQuery_selector](https://api.jquery.com/category/selectors/)
#'   * A [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](https://api.jquery.com/Types/).
#' @param effect A string indicating which
#'   [animation effect](https://jqueryui.com/effect/) to use for the
#'   transition.
#' @param options A list of effect-specific
#'   [properties](https://api.jqueryui.com/category/effects/) and
#'   [easing](https://api.jqueryui.com/easings/).
#' @param duration A string or number determining how long the animation will
#'   run.
#' @param complete A function to call once the animation is complete, called
#'   once per matched element.
#'
#' @example examples/animation_effects.R
#' @name Animation_effects
NULL


#' @rdname Animation_effects
#' @export
jqui_effect <- function(ui, effect, options = NULL,
                        duration = 400, complete = NULL) {
  func <- "effect"
  animationEffects(ui, func, effect, options, duration, complete)
}


#' @rdname Animation_effects
#' @export
jqui_show <- function(ui, effect, options = NULL,
                      duration = 400, complete = NULL) {
  func <- "show"
  animationEffects(ui, func, effect, options, duration, complete)
}


#' @rdname Animation_effects
#' @export
jqui_hide <- function(ui, effect, options = NULL,
                      duration = 400, complete = NULL) {
  func <- "hide"
  animationEffects(ui, func, effect, options, duration, complete)
}


#' @rdname Animation_effects
#' @export
jqui_toggle <- function(ui, effect, options = NULL,
                        duration = 400, complete = NULL) {
  func <- "toggle"
  animationEffects(ui, func, effect, options, duration, complete)
}


#' Get available animation effects.
#'
#' Use this function to get all animation effects in jQuery UI.
#'
#' @return A character vector of effect names
#' @export
get_jqui_effects <- function() {
  c(
    "blind", "bounce", "clip", "drop",
    "explode", "fade", "fold", "highlight",
    "puff", "pulsate", "scale", "shake",
    "size", "slide", "transfer"
  )
}



#' Class effects.
#'
#' Manipulate specified class(es) to matched elements while animating all style
#' changes.
#' * `jqui_add_class()`: Add class(es).
#' * `jqui_remove_class()`: Remove class(es).
#' * `jqui_switch_class()`: Switch class(es).
#'
#' These functions are the R wrappers of
#' [addClass()](https://api.jqueryui.com/addClass/),
#' [removeClass()](https://api.jqueryui.com/removeClass/) and
#' [switchClass()](https://api.jqueryui.com/switchClass/) from jQuery UI library.
#' They should be used in `server` of a shiny app.
#'
#' @param ui The target ui element(s) to be manipulated. Can be
#'   * A string of [jQuery_selector](https://api.jquery.com/category/selectors/)
#'   * A [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](https://api.jquery.com/Types/).
#' @param className One or more class names (space separated) to be added to or
#'   removed from the class attribute of each matched element.
#' @param duration A string or number determining how long the animation will
#'   run.
#' @param easing A string indicating which
#'   [easing](https://api.jqueryui.com/easings/) function to use for the
#'   transition.
#' @param complete A js function to call once the animation is complete, called
#'   once per matched element.
#' @param removeClassName One or more class names (space separated) to be
#'   removed from the class attribute of each matched element.
#' @param addClassName One or more class names (space separated) to be added to
#'   the class attribute of each matched element.
#'
#' @example examples/class_effects.R
#' @name Class_effects
NULL


#' @rdname Class_effects
#' @export
jqui_add_class <- function(ui, className, duration = 400,
                           easing = "swing", complete = NULL) {
  type <- "class"
  func <- "add"
  options <- list(
    className = className,
    duration = duration,
    easing = easing,
    complete = complete
  )
  rm(className, duration, easing, complete)
  sendMsg()
}


#' @rdname Class_effects
#' @export
jqui_remove_class <- function(ui, className, duration = 400,
                              easing = "swing", complete = NULL) {
  type <- "class"
  func <- "remove"
  options <- list(
    className = className,
    duration = duration,
    easing = easing,
    complete = complete
  )
  rm(className, duration, easing, complete)
  sendMsg()
}


#' @rdname Class_effects
#' @export
jqui_switch_class <- function(ui, removeClassName, addClassName,
                              duration = 400, easing = "swing", complete = NULL) {
  type <- "class"
  func <- "switch"
  options <- list(
    removeClassName = removeClassName,
    addClassName = addClassName,
    duration = duration,
    easing = easing,
    complete = complete
  )
  rm(removeClassName, addClassName, duration, easing, complete)
  sendMsg()
}
