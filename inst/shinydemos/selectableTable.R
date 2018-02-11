library(shiny)
library(shinyjqui)

selection_mode <- "row"

func_cell <- JS(
  "function(event, ui){",
  "  var $sels = $(event.target).find('.ui-selected');",
  "  var rows = $sels.map(function(i, e){return e.parentNode.rowIndex}).get();",
  "  var columns = $sels.map(function(i, e){return e.cellIndex + 1}).get();",
  "  return {'rows': rows, 'columns': columns}",
  # "  return $(event.target)",
  # "     .find('.ui-selected')",
  # "     .map(function(i, e){",
  # "       return {'r': e.parentNode.rowIndex, 'c': e.cellIndex + 1}",
  # "     })",
  # "     .get();",
  "}"
)

func_row <- JS(
  "function(event, ui){",
  "  return $(event.target)",
  "     .find('.ui-selected')",
  "     .map(function(i, e){return e.rowIndex})",
  "     .get();",
  "}"
)


shiny_opt <- switch (selection_mode,
                     cell = list(
                       `selected:shinyjqui.df` = list(
                         selectablecreate = func_cell,
                         selectablestop = func_cell
                       )
                     ),
                     row = list(
                       `selected` = list(
                         selectablecreate = func_row,
                         selectablestop = func_row
                       )
                     )
)

filter <- switch (selection_mode,
                  cell = "td",
                  row = "tr"
)



ui <- fluidPage(
  verbatimTextOutput("order"),
  tableOutput("test")

)

server <- function(input, output, session) {
  output$order <- renderPrint({
    input$test_selected
  })
  output$test <- renderTable(mtcars, rownames = TRUE)
  jqui_selectable("#test tbody",
                  options = list(
                    filter = filter,
                    classes = list(`ui-selected` = "ui-state-highlight"),
                    shiny = shiny_opt
                  ))
}

shinyApp(ui, server)
