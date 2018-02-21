library(shiny)
library(shinyjqui)

ui <- fluidPage(
  actionButton('save', "Save"),
  actionButton("load", "Load"),
  selectableTableOutput("tbl", selection_mode = "cell"),
  verbatimTextOutput("selected")
)

server <- function(input, output) {
  output$selected <- renderPrint({
    cat("Selected:\n")
    input$tbl_selected
  })
  output$tbl <- renderTable(head(mtcars), rownames = TRUE)
  observeEvent(input$save, {
    jqui_selectable("#tbl", method = "save")
  })

  observeEvent(input$load, {
    jqui_selectable("#tbl", method = "load")
  })
}

shinyApp(ui, server)
