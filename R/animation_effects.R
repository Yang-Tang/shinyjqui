
#' Animation effects.
#'
#' These functions are the R wrappers of
#' \href{http://api.jqueryui.com/effect/}{effect()},
#' \href{http://api.jqueryui.com/hide/}{hide()},
#' \href{http://api.jqueryui.com/show/}{show()} in jQuery UI library. They
#' should be used in \code{server} of a shiny document.
#'
#' \describe{ \item{\code{jqui_effect}}{Apply an animation effect to matched
#' element(s).} \item{\code{jqui_hide}}{Hide the matched element(s) with
#' animation effect.} \item{\code{jqui_show}}{Display the matched element(s)
#' with animation effect.} \item{\code{jqui_toggle}}{Display or hide the matched
#' element(s) with animation effect.}}
#'
#' @param selector A \href{https://api.jquery.com/category/selectors/}{jQuery's
#'   selector} that determines the shiny tag element(s) whose interaction is
#'   enable or disable interactions.
#' @param effect A string indicating which
#'   \href{http://jqueryui.com/effect/}{jQuery UI effect} to use for the
#'   transition.
#' @param options A list of effect-specific
#'   \href{http://api.jqueryui.com/category/effects/}{properties} and
#'   \href{http://api.jqueryui.com/easings/}{easing}.
#' @param duration A string or number determining how long the animation will
#'   run.
#' @param complete A function to call once the animation is complete, called
#'   once per matched element.
#'
#' @example examples/effect_and_visibility.R
#' @name Effect_and_visibility
NULL


#' @rdname Effect_and_visibility
#' @export
jqui_effect <- function(selector, effect, options = NULL,
                        duration = 400, complete = NULL) {
  if (!(effect %in% get_jqui_effects())) stop("Invalid effect.")
  type <- "effect"
  func <- "effect"
  options <- list(
    effect = effect,
    options = options,
    duration = duration,
    complete = complete
  )
  rm(effect, duration, complete)
  sendMsg()
}


#' @rdname Effect_and_visibility
#' @export
jqui_show <- function(selector, effect, options = NULL,
                      duration = 400, complete = NULL) {
  if (!(effect %in% get_jqui_effects())) stop("Invalid effect.")
  if (effect == "transfer") {
    stop("The transfer effect is not supported in show/hide/toggle.")
  }
  type <- "effect"
  func <- "show"
  options <- list(
    effect = effect,
    options = options,
    duration = duration,
    complete = complete
  )
  rm(effect, duration, complete)
  sendMsg()
}


#' @rdname Effect_and_visibility
#' @export
jqui_hide <- function(selector, effect, options = NULL,
                      duration = 400, complete = NULL) {
  if (!(effect %in% get_jqui_effects())) stop("Invalid effect.")
  if (effect == "transfer") {
    stop("The transfer effect is not supported in show/hide/toggle.")
  }
  type <- "effect"
  func <- "hide"
  options <- list(
    effect = effect,
    options = options,
    duration = duration,
    complete = complete
  )
  rm(effect, duration, complete)
  sendMsg()
}


#' @rdname Effect_and_visibility
#' @export
jqui_toggle <- function(selector, effect, options = NULL,
                        duration = 400, complete = NULL) {
  if (!(effect %in% get_jqui_effects())) stop("Invalid effect.")
  if (effect == "transfer") {
    stop("The transfer effect is not supported in show/hide/toggle.")
  }
  type <- "effect"
  func <- "toggle"
  options <- list(
    effect = effect,
    options = options,
    duration = duration,
    complete = complete
  )
  rm(effect, duration, complete)
  sendMsg()
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
