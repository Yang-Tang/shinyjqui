library(shiny)
library(shinyjqui)

func_set <- JS(
  "function(event, ui){",
  "  var $trs = $(event.target).find('tbody tr')",
  "  $trs.attr('jqui_tbl_row_idx', function(i, v){return i});",
  "  return $.map($(Array($trs.length)),function(v, i){return i + 1});",
  "}"
)

func_get <- JS(
  "function(event, ui){",
  "  return $(event.target)",
  "     .find('tbody tr')",
  "     .map(function(i, e){",
  "       return parseInt($(e).attr('jqui_tbl_row_idx')) + 1",
  "     })",
  "     .get();",
  "}"
)

shiny_opt <- list(order = list(sortcreate = func_set,
                               sortupdate = func_get))

ui <- fluidPage(
  verbatimTextOutput("order"),
  jqui_sortabled(tag = tableOutput("test"),
                 options = list(items = "tbody tr", shiny = shiny_opt))


)

server <- function(input, output, session) {
  output$order <- renderPrint({input$test_order})
  output$test <- renderTable(mtcars, rownames = TRUE)
}

shinyApp(ui, server)
