library(shinyjqui)

ui <- fluidPage(
  div(id = "foo", "Hello Shiny", click = "foo_click"),

  actionButton("bar", "Click to highlight")
)

server <- function(input, output, session) {
  observeEvent(input$bar, {
    jqui_effect("#foo", effect = "highlight",
                options = list(color = "green"),
                duration = 1500)
  }
  )
}

shinyApp(ui, server)
