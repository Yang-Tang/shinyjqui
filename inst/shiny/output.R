library(shiny)
library(highcharter)

server <- function(input, output) {

  output$p <- renderHighchart({
    hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg, group = factor(vs)))
  })

}

ui <- fluidPage(

  includeScript('script.js'),

  highchartOutput('p')

)

shinyApp(ui, server)
