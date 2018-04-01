library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  output$position <- renderPrint({
    input$gg_position
  })

  jqui_bookmarking()

}

ui <- function(request) {fluidPage(
  verbatimTextOutput('position'),
  bookmarkButton(),
  jqui_draggable(plotOutput('gg', width = '200px', height = '200px'))
)}

enableBookmarking(store = "url")

shinyApp(ui, server)
