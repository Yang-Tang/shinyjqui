library(shiny)
library(shinyjqui)


ui <- function(request) {fluidPage(
  verbatimTextOutput("order"),
  bookmarkButton(),
  sortableTableOutput("tbl")
)}

server <- function(input, output) {
  output$order <- renderPrint({
    cat("Rows order:\n")
    input$tbl_index
  })
  output$tbl <- renderTable(head(mtcars), rownames = TRUE)

  jqui_bookmarking()
}

enableBookmarking(store = "url")
shinyApp(ui, server)
