library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  output$size <- renderPrint({
    input$gg_size
  })

  jqui_bookmarking()

}

ui <- fluidPage(
  verbatimTextOutput('size'),
  bookmarkButton(),
  jqui_resizabled(plotOutput('gg', width = '200px', height = '200px'))
)

enableBookmarking(store = "url")

shinyApp(ui, server)
