library(shiny)
library(shinyjqui)
library(ggplot2)


ui <- fluidPage(
  actionButton('btn', "Resize"),
  verbatimTextOutput('size'),
  jqui_resizabled(plotOutput('plot', width = '200px', height = '200px'))
)

server <- function(input, output, session) {
  observeEvent(input$btn, {
    jqui_resize('#plot', 500, 500)
  })

  output$plot <- renderPlot({
    ggplot(mtcars, aes(cyl, mpg)) + geom_point()
  })

  output$size <- renderPrint({
    input$plot_size
  })
}

shinyApp(ui, server)
