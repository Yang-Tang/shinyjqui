library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg, color = factor(gear))) + geom_point()
  })

  output$position <- renderPrint({
    id <- input$drop_area_dragging
    top <- input[[paste0(id, '_position')]]$top
    left <- input[[paste0(id, '_position')]]$left
    cat('Now dragging: ')
    cat(sprintf('%s (top: %s, left: %s)', id, top, left))
    cat('\nDropped: ')
    cat(input$drop_area_dropped)
    cat('\nDrop: ')
    cat(input$drop_area_drop)
    cat('\nOut: ')
    cat(input$drop_area_out)
    cat('\nOver: ')
    cat(input$drop_area_over)
  })

}

ui <- fluidPage(

  # includeJqueryUI(),

  verbatimTextOutput('position'),

  fluidRow(
    column(
      width = 3,

      jqui_draggabled(div(id = 'drg_div', 'Div', style = 'width:100px; height:100px; background-color:#79BBF2')),
      jqui_draggabled(div('No id Div', style = 'width:100px; height:100px; background-color:#79BBF2')),
      jqui_draggabled(actionButton('drg_btn', 'Button'), options = list(cancel = '')),
      jqui_draggabled(textInput('drg_input', 'Input')),
      jqui_draggabled(selectInput('drg_sel', 'Select', choices = month.abb)),
      jqui_draggabled(checkboxGroupInput('drg_chbox', 'Checkbox', choices = month.abb)),
      jqui_draggabled(dateRangeInput('drg_date', 'Daterange')),
      jqui_draggabled(fileInput('drg_file', 'File')),
      jqui_draggabled(sliderInput('drg_slider', 'Slider', 1, 100, 1), options = list(grid = c(80, 80))),
      jqui_draggabled(textAreaInput('drg_textarea', 'Textarea')),
      jqui_draggabled(plotOutput('gg', width = '400px', height = '400px'))

    ),

    jqui_droppabled(column(
      width = 9,
      style = 'height: 800px; z-index: -10; border: 1px dashed; border-radius: 10px;',
      id = 'drop_area',
      'Try to drop something here!'
    ), options = list(
      drop = JS(
        'function(event, ui){',
        '  var info = "A " + shinyjqui.getId(ui.draggable) + " is dropped.";',
        '  $(this).addClass("ui-state-highlight").html(info);',
        '  setTimeout(function(){',
        '    $(event.target).removeClass("ui-state-highlight").html("Try to drop something here!");',
        '  }, 1500);',
        '}'
      )
    ))
  )
)

shinyApp(ui, server)
