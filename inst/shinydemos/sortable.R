library(shiny)
library(shinyjqui)
library(highcharter)
library(ggplot2)

server <- function(input, output) {

  observeEvent(input$en_lst, {
    jqui_sortable('#lst', operation = "enable")
  })
  observeEvent(input$di_lst, {
    jqui_sortable('#lst', operation = "disable")
  })
  output$order_lst <- renderPrint({
    print(input$lst_order)
  })

  observeEvent(input$en_tabs, {

    func <- JS(
      'function(event, ui) {',
      '  return $(event.target).find("a").map(function(i, e){',
      '    return $(e).attr("data-value");',
      '  }).get();',
      '}'
    )

    options <- list(
      shiny = list(
        order = list(
          sortcreate = func,
          sortupdate = func
        )
      )
    )

    jqui_sortable('#tabs', operation = "enable", options = options)
  })
  observeEvent(input$di_tabs, {
    jqui_sortable('#tabs', operation = "disable")
  })
  output$order_tabs <- renderPrint({
    print(input$tabs_order)
  })

  output$highchart <- renderHighchart({
    hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg, group = factor(vs)))
  })
  output$ggplot <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg, color = factor(vs))) + geom_point()
  })
  observeEvent(input$en_plots, {
    jqui_sortable('#plots', operation = "enable")
  })
  observeEvent(input$di_plots, {
    jqui_sortable('#plots', operation = "disable")
  })
  output$order_plots <- renderPrint({
    print(input$plots_order)
  })

}

ui <- fluidPage(

  # includeJqueryUI(),

  jqui_sortable(tags$ul(
    id = 'lst',
    tags$li('A'),
    tags$li('B'),
    tags$li('C')
  )),
  actionButton('en_lst', 'Enable sortable'),
  actionButton('di_lst', 'Disable sortable'),
  verbatimTextOutput('order_lst'),
  hr(),

  tabsetPanel(
    id = 'tabs',
    tabPanel('A', 'aaa'),
    tabPanel('B', 'bbb'),
    tabPanel('C', 'ccc')
  ),
  br(),
  actionButton('en_tabs', 'Enable sortable'),
  actionButton('di_tabs', 'Disable sortable'),
  verbatimTextOutput('order_tabs'),
  hr(),

  jqui_sortable(
    div(
      id = 'plots',
      highchartOutput('highchart', width = '300px'),
      plotOutput('ggplot', width = '300px')
    )
  ),
  actionButton('en_plots', 'Enable sortable'),
  actionButton('di_plots', 'Disable sortable'),
  verbatimTextOutput('order_plots'),
  hr()

)

shinyApp(ui, server)
