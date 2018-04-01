#' Create a table output element with selectable rows or cells
#'
#' Render a standard HTML table with its rows or cells selectable. The server
#' will receive the index of selected rows or cells stored in
#' `input$<outputId>_selected`.
#'
#' Use mouse click to select single target, lasso (mouse dragging) to select
#' multiple targets, and Ctrl + click to add or remove selection. In `row`
#' selection mode, `input$<outputId>_selected` will receive the selected row
#' index in the form of numberic vector. In `cell` selection mode,
#' `input$<outputId>_selected` will receive a dataframe with `rows` and
#' `columns` index of each selected cells.
#'
#' @inheritParams shiny::tableOutput
#'
#' @param selection_mode one of `"row"` or `"cell"` to define either entire row
#'   or individual cell can be selected.
#'
#' @return A table output element that can be included in a panel
#' @export
#' @seealso [shiny::tableOutput], [sortableTableOutput]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       verbatimTextOutput("selected"),
#'       selectableTableOutput("tbl")
#'     ),
#'     server = function(input, output) {
#'       output$selected <- renderPrint({input$tbl_selected})
#'       output$tbl <- renderTable(mtcars, rownames = TRUE)
#'     }
#'   )
#' }
#'
selectableTableOutput <- function(outputId, selection_mode = c("row", "cell")) {
  func_cell <- JS(
    "function(event, ui){",
    "  var $sels = $(event.target).find('.ui-selected');",
    "  var rows = $sels.map(function(i, e){return e.parentNode.rowIndex}).get();",
    "  var columns = $sels.map(function(i, e){return e.cellIndex + 1}).get();",
    "  return {'rows': rows, 'columns': columns}",
    "}"
  )

  func_row <- JS(
    "function(event, ui){",
    "  return $(event.target)",
    "     .find('.ui-selected')",
    "     .map(function(i, e){return e.rowIndex})",
    "     .get();",
    "}"
  )

  selection_mode <- match.arg(selection_mode)

  shiny_opt <- switch(
    selection_mode,
    cell = list(
      `selected:shinyjqui.df` = list(
        `selectablecreate selectablestop` = func_cell
      )
    ),
    row = list(
      `selected` = list(
        `selectablecreate selectablestop` = func_row
      )
    )
  )

  filter <- switch(
    selection_mode,
    cell = "tbody td",
    row = "tbody tr"
  )

  jqui_selectable(
    ui = shiny::tableOutput(outputId),
    options = list(
      filter = filter,
      classes = list(`ui-selected` = "ui-state-highlight"),
      shiny = shiny_opt
    )
  )
}
