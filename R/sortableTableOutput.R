#' Create a table output element with sortable rows
#'
#' Render a standard HTML table with table rows sortable by drag and drop. The
#' order of table rows is recorded in `input$outputId_order`.
#'
#' @param outputId output variable to read the table from
#'
#' @return A table output element that can be included in a panel
#' @export
#' @seealso [sortableRadioButtons()], [sortableCheckboxGroupInput()],
#'   [sortableTabsetPanel()], [selectableTableOutput()]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       verbatimTextOutput("order"),
#'       sortableTableOutput("tbl")
#'     ),
#'     server = function(input, output) {
#'       output$order <- renderPrint({input$tbl_order})
#'       output$tbl <- renderTable(mtcars, rownames = TRUE)
#'     }
#'   )
#' }
#'
sortableTableOutput <- function(outputId) {
  jqui_sortabled(
    tag     = shiny::tableOutput(outputId),
    options = list(items = "tbody tr")
  )
}
