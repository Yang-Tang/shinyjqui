library(shiny)
library(shinyjqui)

ui <- fluidPage(
  actionButton("add", "add"),
  jqui_sortable(tags$ul(id = "lst")),
)

server <- function(input, output, session) {

  observeEvent(input$add, {
    insertUI(
      selector = "#lst",
      where = "beforeEnd",
      ui = tags$li(paste0("test", input$add))
    )
    jqui_sortable("#lst")
  })

  observe({
    cat(str(input$lst_order))
  })
}

shinyApp(ui, server)
