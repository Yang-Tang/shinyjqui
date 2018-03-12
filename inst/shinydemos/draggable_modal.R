# show draggable shiny modal

library(shiny)
library(shinyjqui)

ui <- fluidPage(
  actionButton("show", "show")
)

server <- function(input, output) {
  observeEvent(input$show, {
    showModal(draggableModalDialog(
      title = "Somewhat important message",
      "This is a somewhat important message.",
      easyClose = TRUE
    ))
  })
}

shinyApp(ui, server)
