library(shiny)
library(shinyjqui)

func <- JS(
  "function(event, ui){",
  "  var $e = $(event.target).children('.shiny-bound-input');",
  "  var v = $(ui.item).children('a').attr('data-value');",
  "  if(v) {",
  "    $e.data('shiny-input-binding').setValue($e, v);",
  "  }",
  "  return $e",
  "     .find('li a')",
  "     .map(function(i, e){",
  "       return $(e).attr('data-value')",
  "     })",
  "     .get();",
  "}"
)

shiny_opt <- list(order = list(sortcreate = func, sortupdate = func))

ui <- fluidPage(
  jqui_sortable(
    tabsetPanel(
      id = "tabs",
      tabPanel(title = "A", "AAA"),
      tabPanel(title = "B", "BBB"),
      tabPanel(title = "C", "CCC")
    ),
    options = list(
      items = "li",
      shiny = shiny_opt
    )
  ),
  verbatimTextOutput("order")
)

server <- function(input, output, session) {
  output$order <- renderPrint({input$tabs_order})
}

shinyApp(ui, server)
