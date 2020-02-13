library(shiny)
library(shinyjqui)


ui <- fluidPage(
  div(id = "foo", div(id = "bar", "ddd", style = "width : 100px")),
  actionButton("center", "center")
)

server <- function(input, output, session) {
  observeEvent(input$center, {
    jqui_position("#bar")
  })
}

shinyApp(ui, server)
