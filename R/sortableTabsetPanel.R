#' Create a tabset panel with sortable tabs
#'
#' Create a tabset that contains [shiny::tabPanel] elements. The tabs are
#' sortable by drag and drop. In addition to the activated tab title stored in
#' `input$<id>`, the server will also receive the order of tabs in
#' `input$<id>_order`.
#'
#' @inheritParams shiny::tabsetPanel
#'
#' @return A tabset that can be passed to [shiny::mainPanel]
#' @export
#' @seealso [shiny::tabsetPanel], [sortableRadioButtons],
#'   [sortableCheckboxGroupInput], [sortableTableOutput]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       sortableTabsetPanel(
#'         id = "tabs",
#'         tabPanel(title = "A", "AAA"),
#'         tabPanel(title = "B", "BBB"),
#'         tabPanel(title = "C", "CCC")
#'       ),
#'       verbatimTextOutput("order")
#'     ),
#'     server = function(input, output) {
#'       output$order <- renderPrint({input$tabs_order})
#'     }
#'   )
#' }
#'
sortableTabsetPanel <- function(..., id = NULL, selected = NULL,
                                type = c("tabs", "pills"), position = NULL) {
  func <- JS(
    "function(event, ui){",
    "  var $e = $(event.target).children('.shiny-bound-input');",
    "  var v = $(ui.item).children('a').attr('data-value');",
    "  if(v) {",
    "    $e.data('shiny-input-binding').setValue($e, v);",
    "  }",
    "  return $e",
    "     .find('li a')",
    "     .map(function(i, e){",
    "       return $(e).attr('data-value')",
    "     })",
    "     .get();",
    "}"
  )

  shiny_opt <- list(order = list(sortcreate = func, sortupdate = func))

  jqui_sortable(
    ui = shiny::tabsetPanel(
      ..., id = id, selected = selected,
      type = type, position = position
    ),
    options = list(items = "li", shiny = shiny_opt)
  )
}
