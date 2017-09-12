library(shiny)
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
  jqui_resizabled(jqui_draggabled(highchartOutput('foo', width = '800px', height = '800px')))
  # jqui_draggabled(jqui_resizabled(highchartOutput('foo', width = '800px', height = '800px')))
)

shinyApp(ui, server)
