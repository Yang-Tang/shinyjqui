# draggable examples:
# ====================

library(shiny)
library(highcharter)

# jqui_draggabled() modifiy a shiny tag, tagList, input or output to a draggable
# element. The function has to be called in shiny ui.
jqui_draggabled(textInput('input', 'Input'))

# actionButton needs to set options cancel = '', because jQuery UI defaultly
# prevents dragging from starting on button
jqui_draggabled(actionButton('btn', 'Button'), options = list(cancel = ''))

# for tagList
jqui_draggabled(tagList(
  selectInput('sel', 'Select', choices = month.abb),
  checkboxGroupInput('chbox', 'Checkbox', choices = month.abb),
  dateRangeInput('date', 'Daterange')
))

# pass options to jQuery UI (can be dragged only horizontally)
jqui_draggabled(sliderInput('drg_slider', 'Slider', 1, 100, 1),
                options = list(axis = 'x'))

# for output
jqui_draggabled(plotOutput('plot', width = '400px', height = '400px'))

# jqui_draggable enable or diable element's draggable interaction based on the
# jQuery selector provided. It has to be used in shiny server.
\dontrun{
  # enable the draggable of an element with id foo.
  jqui_draggable('#foo')

  # disable the draggable of any elements with class foo.
  jqui_draggable('.foo', switch = FALSE)

  # pass options (snap to a 80 x 80 grid)
  jqui_draggable('.grid', options = list(grid = c(80, 80)))
}

# Once an element is draggable, if it has an id, we can obtain its position
# (relative to its parent element) through input$id_position
if (interactive()) {
  server <- function(input, output) {
    output$foo <- renderHighchart({
      hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg))
    })
    output$position <- renderPrint({
      print(input$foo_position)
    })
  }
  ui <- fluidPage(
    includeJqueryUI(),
    verbatimTextOutput('position'),
    jqui_draggabled(highchartOutput('foo', width = '200px', height = '200px'))
  )
  shinyApp(ui, server)
}

# If we want the absolute position of a draggable element, we can create a new
# input for it by passing a shiny option with event handlers in options
# parameter.
func <- htmlwidgets::JS('function(event, ui){return $(event.target).offset();}')
options <-  list(
  shiny = list(
    abs_position = list(
      dragcreate = func, # send returned value back to shiny when interaction is created.
      drag = func # send returned value to shiny when dragging.
    )
  )
)
jqui_draggabled(highchartOutput('foo', width = '200px', height = '200px'),
                options = options)
# get absolute position (relative to the document) through input$foo_abs_position


# droppable examples:
# ====================

