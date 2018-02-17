library(shiny)
library(shinyjqui)
library(ggplot2)


ui <- fluidPage(
  # includeJqueryUI(),
  # absolutePanel("ddd", draggable = TRUE),
  actionButton('btn', "Drag"),
  verbatimTextOutput('pos'),
  jqui_draggabled(plotOutput('plot', width = '200px', height = '200px'))
  # plotOutput('plot', width = '200px', height = '200px'),
  # actionButton('btn', "Resize")
)

server <- function(input, output, session) {
  observeEvent(input$btn, {
    # jqui_resize('#plot', 500, 500)
    # jqui_position('#plot', my = "left top", at = "left+102 top+156", of = "body")
    jqui_drag('#plot', my = "left top", at = "left+102 top+156",
                  of = JS("$('#plot').parent()"))
  })

  output$plot <- renderPlot({
    ggplot(mtcars, aes(cyl, mpg)) + geom_point()
  })

  output$pos <- renderPrint({
    input$plot_position
  })
}

shinyApp(ui, server)
