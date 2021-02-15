library(shiny)

ui <- fluidPage(
  tags$script("$(document).on('dragcreate', '.ui-draggable', function(e, ui) { alert('test'); });"),
  shinyjqui::jqui_draggable(div("test")),
  actionButton("add", "add")
)

server <- function(input, output, session) {
  observeEvent(input$add, {
    insertUI(
      "#add", "afterEnd",
      shinyjqui::jqui_draggable(div(paste("test", input$add))),
      immediate = TRUE
    )
  })
}

shinyApp(ui, server)
