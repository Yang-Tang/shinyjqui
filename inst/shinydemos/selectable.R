library(shiny)
library(shinyjqui)
library(highcharter)
library(ggplot2)

server <- function(input, output) {


  output$lst_selected <- renderPrint({
    print(input$sel_lst_selected)
  })

  output$highchart <- renderHighchart({
    hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg, group = factor(vs)))
  })
  output$ggplot <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg, color = factor(vs))) + geom_point() +
      theme(plot.background = element_rect(fill = "transparent",colour = NA))
  }, bg = "transparent")

  output$plots_selected <- renderPrint({
    print(input$sel_plots_selected)
  })

}

ui <- fluidPage(

  # includeJqueryUI(),

  jqui_selectable(tags$ul(id = 'sel_lst',
                      tags$li('a'),
                      tags$li('b'),
                      tags$li('c'),
                      tags$li('d'),
                      tags$li('e'),
                      tags$li('f')),
              options = list(classes = list(`ui-selected` = "text-uppercase"))
  ),
  verbatimTextOutput('lst_selected'),

  jqui_selectable(
    div(
      id = 'sel_plots',
      highchartOutput('highchart', width = '300px'),
      plotOutput('ggplot', width = '300px')
    ),
    options = list(
      classes = list(`ui-selected` = "ui-state-highlight")
    )
  ),

  verbatimTextOutput('plots_selected')

)

shinyApp(ui, server)
