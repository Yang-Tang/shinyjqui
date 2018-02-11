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
  func_set <- JS(
    "function(event, ui){",
    "  var $trs = $(event.target).find('tbody tr')",
    "  $trs.attr('jqui_tbl_row_idx', function(i, v){return i});",
    "  return $.map($(Array($trs.length)),function(v, i){return i + 1});",
    "}"
  )

  func_get <- JS(
    "function(event, ui){",
    "  return $(event.target)",
    "     .find('tbody tr')",
    "     .map(function(i, e){",
    "       return parseInt($(e).attr('jqui_tbl_row_idx')) + 1",
    "     })",
    "     .get();",
    "}"
  )

  shiny_opt <- list(order = list(sortcreate = func_set, sortupdate = func_get))

  jqui_sortabled(
    tag     = shiny::tableOutput(outputId),
    options = list(items = "tbody tr", shiny = shiny_opt)
  )

}
