library(shiny)
library(shinyjqui)
library(ggplot2)

server <- function(input, output) {

  observeEvent(input$run, {

    options <- list()

    if (input$effect == 'scale') {
      options <- list(percent = 50)
    } else if (input$effect == 'transfer') {
      options <- list(to = '#run', className = 'ui-effects-transfer')
    } else if (input$effect == 'size') {
      options <- list(to = list(width = 200, height = 60))
    }

    callback <- JS(
      'function(){',
      '  setTimeout(function() {',
      '    $("#gg").children().removeAttr("style");',
      '    $("#gg").removeAttr("style").hide().fadeIn();',
      '  }, 1000);',
      '}'
    )

    jqui_effect('#gg', effect = input$effect, options = options,
           duration = 1000, complete = callback)

  })
  observeEvent(input$show, {
    jqui_show('#gg', effect = input$effect)
  })
  observeEvent(input$hide, {
    jqui_hide('#gg', effect = input$effect)
  })

  observeEvent(input$toggle, {
    jqui_toggle('#gg', effect = input$effect)
  })

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg, color = factor(gear))) +
      geom_point() +
      theme(plot.background = element_rect(fill = "transparent",colour = NA))
  }, bg = "transparent")

}

ui <- fluidPage(

  # includeJqueryUI(),

  tags$head(
    tags$style(
      HTML('.ui-effects-transfer {border: 1px dotted black;}')
    )
  ),

  div(style = 'width: 400px; height: 400px',
      plotOutput('gg', width = '100%', height = '100%')),
  selectInput('effect', NULL, choices = get_jqui_effects()),
  actionButton('run', 'Run effect'),
  actionButton('show', 'Show'),
  actionButton('hide', 'Hide'),
  actionButton('toggle', 'Toggle'),
  br(),
  'Note: The "transfer" effect does not support Show/Hide/Toggle'

)

shinyApp(ui, server)
