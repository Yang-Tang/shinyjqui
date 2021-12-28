#81

library(shiny)
library(shinyjqui)

## Uncomment the one you want to use
# toUpdate <- month.abb[1:6]                                     # Normal vector works fine
# toUpdate <- stats::setNames(1:6, nm = month.abb[1:6])          # Named vector does not work
# toUpdate <- as.list(stats::setNames(1:6, nm = month.abb[1:6])) # Named list does not work
# toUpdate <- factor(month.abb[1:6])                             # Factor works.

ui <- fluidPage(
  orderInput("foo", "label",
             items =  NULL,
             item_class = 'default'),
  verbatimTextOutput("order"),
  actionButton("update", "update")
)

server <- function(input, output, session) {
  output$order <- renderPrint({input$foo})

  observeEvent(input$update, {
    updateOrderInput(
      session, "foo",
      items = toUpdate
    )
  })
}

shinyApp(ui, server)
