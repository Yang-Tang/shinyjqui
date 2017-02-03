#' Inject necessary js and css assets to the head of a shiny document
#'
#' This function has to be called within the \code{ui} of a shiny document before the
#' usage of other \code{shinyjqui} functions.
#'
#' @return A shiny head tag with necessary js and css assets.
#' @export
#'
#' @examples
includeJqueryUI <- function() {

  shiny::addResourcePath('shinyjqui', system.file('www', package = 'shinyjqui'))

  shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(src = "shared/jqueryui/jquery-ui.min.js"),
      shiny::tags$link(rel="stylesheet", href="shared/jqueryui/jquery-ui.css"),
      shiny::tags$script(src = 'shinyjqui/shinyjqui.js')
    )
  )
}
