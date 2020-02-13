library(shiny)

if (interactive()) {

  ui <- fluidPage(
    orderInput("foo", "foo",
               items = month.abb[1:3],
               item_class = 'info'),
    verbatimTextOutput("order"),
    actionButton("update", "update")
  )

  server <- function(input, output, session) {
    output$order <- renderPrint({input$foo})
    observeEvent(input$update, {
      updateOrderInput(session, "foo",
                       items = month.abb[1:6],
                       item_class = "success")
    })
  }

  shinyApp(ui, server)

}
