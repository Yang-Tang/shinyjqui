library(shiny)
library(shinyjqui)
library(ggplot2)
library(shinycssloaders)

ui <- fluidPage(
  actionButton("go", "Go"),

  shinycssloaders::withSpinner(
    jqui_resizable(plotOutput('gg')),
    color="#0dc5c1"
  )

  # the following works too

  # jqui_resizable(
  #   shinycssloaders::withSpinner(
  #     plotOutput('gg'),
  #     color="#0dc5c1"
  #   )
  # )

)

server <- function(input, output) {

  val <- eventReactive(input$go, mtcars)
  output$gg <- renderPlot({
    Sys.sleep(1.5)
    ggplot(val(), aes(x = cyl, y = mpg)) + geom_point()
  }
  )
}

shinyApp(ui, server)
