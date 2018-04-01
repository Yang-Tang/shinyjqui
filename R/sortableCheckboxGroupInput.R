#' Create a Checkbox Group Input Control with Sortable Choices
#'
#' Render a group of checkboxes with multiple choices toggleable. The choices
#' are also sortable by drag and drop. In addition to the selected values stored
#' in `input$<inputId>`, the server will also receive the order of choices in
#' `input$<inputId>_order`.
#'
#' @inheritParams shiny::checkboxGroupInput
#'
#' @return A list of HTML elements that can be added to a UI definition
#' @export
#' @seealso [shiny::checkboxGroupInput], [sortableRadioButtons()],
#'   [sortableTableOutput()], [sortableTabsetPanel()]
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       sortableCheckboxGroupInput("foo", "SortableCheckboxGroupInput",
#'                                  choices = month.abb),
#'       verbatimTextOutput("order")
#'     ),
#'     server = function(input, output) {
#'       output$order <- renderPrint({input$foo_order})
#'     }
#'   )
#' }
#'
sortableCheckboxGroupInput <- function(inputId, label, choices = NULL,
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
    tag = shiny::checkboxGroupInput(
      inputId, label, choices, selected,
      inline, width, choiceNames,
      choiceValues
    ),
    options = list(items = ".checkbox", shiny = shiny_opt)
  )
}
