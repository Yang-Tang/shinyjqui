library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {
  # jqui_resizable("#gg")

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  output$size <- renderPrint({
    input$gg_size
  })

  observeEvent(input$save, {
    jqui_resizable("#gg", operation = "save")
  })

  observeEvent(input$load, {
    jqui_resizable("#gg", operation = "load")
  })
}

ui <- fluidPage(
  verbatimTextOutput('size'),
  actionButton('save', "Save"),
  actionButton("load", "Load"),
  # plotOutput('gg', width = '200px', height = '200px')
  jqui_resizable(plotOutput('gg', width = '200px', height = '200px'))
)

shinyApp(ui, server)
