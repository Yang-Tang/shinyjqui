library(shiny)
library(shinyjqui)

server <- function(input, output) {
  output$out <- renderPrint({
    print(input$text_position)
    print(input$text_is_dragging)
  })
}

ui <- fluidPage(
  # includeJqueryUI(),
  verbatimTextOutput('out'),
  jqui_draggable(textInput('text', 'Text'))
)

shinyApp(ui, server)
