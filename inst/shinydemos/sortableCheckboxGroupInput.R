library(shiny)
library(shinyjqui)

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

ui <- fluidPage(
  jqui_sortable(
    checkboxGroupInput("test", "SortableCheckboxGroupInput",
                                 choices = month.abb),
    options = list(items = ".checkbox", shiny = shiny_opt)
  ),
  verbatimTextOutput("order")
)

server <- function(input, output, session) {

  output$order <- renderPrint({input$test_order})

}

shinyApp(ui, server)
