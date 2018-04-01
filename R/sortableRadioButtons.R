#' Create radio buttons with sortable choices
#'
#' Create a set of radio buttons used to select an item from a list. The choices
#' are sortable by drag and drop. In addition to the selected values stored in
#' `input$<inputId>`, the server will also receive the order of choices in
#' `input$<inputId>_order`.
#'
#' @inheritParams shiny::radioButtons
#'
#' @return A set of radio buttons that can be added to a UI definition.
#' @export
#' @seealso [shiny::radioButtons], [sortableCheckboxGroupInput],
#'   [sortableTableOutput], [sortableTabsetPanel]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       sortableRadioButtons("foo", "SortableRadioButtons",
#'                                  choices = month.abb),
#'       verbatimTextOutput("order")
#'     ),
#'     server = function(input, output) {
#'       output$order <- renderPrint({input$foo_order})
#'     }
#'   )
#' }
#'
sortableRadioButtons <- function(inputId, label, choices = NULL,
                                 selected = NULL, inline = FALSE,
                                 width = NULL, choiceNames = NULL,
                                 choiceValues = NULL) {
  func <- JS(
    "function(event, ui) {                   ",
    "  return $(event.target).find('input')  ",
    "    .map(function(i, e){                ",
    "      return $(e).attr('value')         ",
    "    })                                  ",
    "    .get();                             ",
    "}                                       "
  )

  shiny_opt <- list(order = list(sortcreate = func, sortupdate = func))

  jqui_sortable(
    ui = shiny::radioButtons(
      inputId, label, choices, selected,
      inline, width, choiceNames, choiceValues
    ),
    options = list(items = ".radio", shiny = shiny_opt)
  )
}
