#' Create a table output element with sortable rows
#'
#' Render a standard HTML table with table rows sortable by drag and drop. The
#' order of table rows is recorded in `input$<outputId>_order`.
#'
#' @inheritParams shiny::tableOutput
#'
#' @return A table output element that can be included in a panel
#' @export
#' @seealso [shiny::tableOutput], [sortableRadioButtons],
#'   [sortableCheckboxGroupInput], [sortableTabsetPanel],
#'   [selectableTableOutput]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       verbatimTextOutput("rows"),
#'       sortableTableOutput("tbl")
#'     ),
#'     server = function(input, output) {
#'       output$rows <- renderPrint({input$tbl_row_index})
#'       output$tbl <- renderTable(mtcars, rownames = TRUE)
#'     }
#'   )
#' }
#'
sortableTableOutput <- function(outputId) {
  shinyopt <- list(
    row_index = list(
      # on table update, trigger the "sortcreate" to recreate row index, also
      # needs to wait for 10ms until table element refresh.
      `shiny:value` = JS(
        "function(event, ui) {",
        "  setTimeout(function(){",
        "    $(event.target).parent().trigger('sortcreate')",
        "  }, 10)",
        "}"
      ),
      sortcreate = JS(
        "function(event, ui) {",
        "  var $items = $(event.target).find('tbody tr');",
        "  $items.attr('jqui_tbl_row_idx', function(i, v){return i + 1});",
        "  return $.map($(Array($items.length)),function(v, i){return i + 1});",
        "}"
      ),
      sortupdate = JS(
        "function(event, ui) {",
        "  var idx = $(event.target)",
        "  .sortable('toArray', {attribute:'jqui_tbl_row_idx'});",
        "  return $.map(idx, function(v, i){return parseInt(v)});",
        "}"
      )
    )
  )
  jqui_sortable(
    ui = shiny::tableOutput(outputId),
    options = list(items = "tbody tr", shiny = shinyopt)
  )
}
