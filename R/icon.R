#' Create a jQuery UI icon
#'
#' Create an jQuery UI pre-defined icon. For lists of available icons, see
#' \url{https://api.jqueryui.com/theming/icons/}.
#'
#' @param name Class name of icon. The "ui-icon-" prefix can be omitted (i.e.
#'   use "ui-icon-flag" or "flag" to display a flag icon)
#'
#' @return An icon element
#' @export
#'
#' @examples
#' jqui_icon('caret-1-n')
#'
#' library(shiny)
#'
#' # add an icon to an actionButton
#' actionButton('button', 'Button', icon = jqui_icon('refresh'))
#'
#' # add an icon to a tabPanel
#' tabPanel('Help', icon = jqui_icon('help'))
jqui_icon <- function(name) {
  if (!grepl("^ui-icon-", name)) {
    name <- paste0("ui-icon-", name)
  }
  icon <- shiny::tags$i(class = paste0("ui-icon ", name))
  htmltools::attachDependencies(icon, jquiDep())
}
