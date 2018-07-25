library(shiny)
library(shinyjqui)
library(highcharter)

server <- function(input, output) {
  output$foo <- renderHighchart({
    hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg))
  })
  output$position <- renderPrint({
    print(input$foo_position)
  })
}
ui <- fluidPage(
  verbatimTextOutput('position'),
  jqui_resizable(jqui_draggable(highchartOutput('foo', width = '800px', height = '800px')))
  # jqui_draggable(jqui_resizable(highchartOutput('foo', width = '800px', height = '800px')))
)

shinyApp(ui, server)
