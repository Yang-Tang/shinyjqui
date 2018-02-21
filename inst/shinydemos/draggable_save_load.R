library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {
  # jqui_resizable("#gg")

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  output$position <- renderPrint({
    input$gg_position
  })

  observeEvent(input$save, {
    jqui_draggable("#gg", method = "save")
  })

  observeEvent(input$load, {
    jqui_draggable("#gg", method = "load")
  })
}

ui <- fluidPage(
  verbatimTextOutput('position'),
  actionButton('save', "Save"),
  actionButton("load", "Load"),
  # plotOutput('gg', width = '200px', height = '200px')
  jqui_draggabled(plotOutput('gg', width = '200px', height = '200px'))
)

shinyApp(ui, server)
