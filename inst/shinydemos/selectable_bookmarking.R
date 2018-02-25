library(shiny)
library(shinyjqui)

ui <- function(request) {fluidPage(
  bookmarkButton(),
  selectableTableOutput("tbl", selection_mode = "cell"),
  verbatimTextOutput("selected")
)}

server <- function(input, output) {
  output$selected <- renderPrint({
    cat("Selected:\n")
    input$tbl_selected
  })
  output$tbl <- renderTable(head(mtcars), rownames = TRUE)
  jqui_bookmarking()
}

enableBookmarking(store = "url")

shinyApp(ui, server)
