library(shiny)
library(shinyjqui)

data <- head(mtcars)

ui <- fluidPage(
  orderInput('items1', 'Items1', items = NULL, item_class = c("info", "danger", "primary")),
  actionButton("update", "update")

)

server <- function(input, output, session) {

  observeEvent(input$update, {
    updateOrderInput(session, "items1", items = month.abb[1:6], item_class = c("danger"))
    updateOrderInput(session, "items1", item_class = c("danger", "info"))
    # updateOrderInput(session, "items1", items = month.abb[1:12])
    # updateOrderInput(session, "items1", label = "Items100")
    # updateOrderInput(session, "items1", connect = c("ID2", "ID3"))
  })

}

shinyApp(ui, server)
