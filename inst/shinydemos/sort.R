library(shiny)

ui <- fluidPage(
  actionButton('btn', 'Sort'),
  verbatimTextOutput("order"),
  sortableTableOutput("tbl")
)

server <- function(input, output) {
  output$order <- renderPrint({
    cat("Rows order:\n")
    input$tbl_order
  })
  output$tbl <- renderTable(head(mtcars), rownames = TRUE)
  observeEvent(input$btn, {
    jqui_sort("#tbl tbody", c(3, 2, 1))
  })
}


shinyApp(ui, server)
