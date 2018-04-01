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
    jqui_draggable("#gg", operation = "save")
  })

  observeEvent(input$load, {
    jqui_draggable("#gg", operation = "load")
  })
}

ui <- fluidPage(
  verbatimTextOutput('position'),
  actionButton('save', "Save"),
  actionButton("load", "Load"),
  # plotOutput('gg', width = '200px', height = '200px')
  jqui_draggable(plotOutput('gg', width = '200px', height = '200px'))
)

shinyApp(ui, server)
