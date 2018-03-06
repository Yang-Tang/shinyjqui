library(shiny)

ui <- fluidPage(
  actionButton("sample", "Sample"),
  verbatimTextOutput("index"),
  sortableTableOutput("tbl")
)

server <- function(input, output) {
  output$index <- renderPrint({
    cat("Row index:\n")
    input$tbl_row_index
  })
  output$tbl <- renderTable({
    input$sample
    mtcars[sample(nrow(mtcars), 6), ]
  }, rownames = TRUE)
}

shinyApp(ui, server)
