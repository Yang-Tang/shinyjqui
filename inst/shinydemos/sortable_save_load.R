library(shiny)
library(shinyjqui)


ui <- fluidPage(
  verbatimTextOutput("order"),
  actionButton('save', "Save"),
  actionButton("load", "Load"),
  sortableTableOutput("tbl")
)

server <- function(input, output) {
  output$order <- renderPrint({
    cat("Rows order:\n")
    input$tbl_index
  })
  output$tbl <- renderTable(head(mtcars), rownames = TRUE)

  observeEvent(input$save, {
    jqui_sortable("#tbl", method = "save")
  })

  observeEvent(input$load, {
    jqui_sortable("#tbl", method = "load")
  })
}

shinyApp(ui, server)
