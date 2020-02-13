library(shiny)
library(shinyjqui)

ui <- fluidPage(
  orderInput("foo", "foo",
             items = month.abb[1:3],
             item_class = 'info'),
  orderInput("bar", "bar",
             items = month.abb[4:6],
             item_class = 'info'),
  verbatimTextOutput("order"),
  actionButton("update", "update")
)

server <- function(input, output, session) {
  output$order <- renderPrint({input$bar})
  observeEvent(input$update, {
    updateOrderInput(session, "foo",
                     items = month.abb[1:6],
                     connect = "bar",
                     item_class = "success")
  })
}

shinyApp(ui, server)




ui <- fluidPage(
  orderInput("foo", "label", letters[1:5], as_source = T, connect = "bar", placeholder = "empty1"),
  orderInput("bar", "label2", LETTERS[1:5], connect = "foo", placeholder = "empty2"),
  verbatimTextOutput("order"),
  verbatimTextOutput("order2"),
  actionButton("add", "Add")
)

server <- function(input, output, session) {
  output$order <- renderPrint({input$foo})
  output$order2 <- renderPrint({input$bar})
  observeEvent(input$add, {
    updateOrderInput(session, "bar", items = c("y", "k"), item_class = "success")
  })
}

shinyApp(ui, server)
