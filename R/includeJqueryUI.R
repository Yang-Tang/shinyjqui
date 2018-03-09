#' Inject necessary js and css assets to the head of a shiny document (deprecated).
#'
#' This function has to be called within the \code{ui} of a shiny document before the
#' usage of other \code{shinyjqui} functions.
#'
#' @return A shiny head tag with necessary js and css assets.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       includeJqueryUI(),
#'       # other ui codes
#'     ),
#'     server = function(input, output) {
#'       # server codes
#'     }
#'   )
#' }
includeJqueryUI <- function() {
  .Deprecated(
    msg = "Since v0.2.0, there is no need to call includeJqueryUI() before using other shinyjqui functions"
  )
  jquiHead()
}
