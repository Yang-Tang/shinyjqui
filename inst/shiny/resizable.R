library(shiny)
library(shinyjqui)
library(d3heatmap)
library(ggplot2)
library(highcharter)
library(plotly)

ids <- list(d3heatmap = 'd3',
            ggplot = 'gg',
            `text output` = 'text',
            `ui output` = 'ui',
            tableOutput = 'table',
            highchart = 'hc',
            plotly = 'pl')


server <- function(input, output) {

  output$d3 <- renderD3heatmap({
    d3heatmap(mtcars)
  })

  output$gg <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  output$text <- renderText({
    month.name
  })

  output$ui <- renderUI({
    tagList(
      textInput('a', 'A'),
      radioButtons('b', 'B', letters, inline = TRUE),
      sliderInput('c', 'C', min = 0, max = 100, value = 0),
      actionButton('d', 'Button')
    )
  })

  output$hc <- renderHighchart({
    hchart(mtcars, "scatter", hcaes(x = cyl, y = mpg, group = factor(vs)))
  })

  output$pl <- renderPlotly({
    plot_ly(z = ~volcano, type = "surface")
  })

  selector <- eventReactive(input$tabs, {
    paste0('#', ids[[input$tabs]])
  })

  observeEvent(input$enable, {
    jqui_resizable(selector(), switch = TRUE, options = list(cancel = ''))
  })
  observeEvent(input$disable, {
    jqui_resizable(selector(), switch = FALSE)
  })

  output$size <- renderPrint({
    name <- paste0(ids[[input$tabs]], '_size')
    cat(sprintf('%s(height: %s, width: %s)\n',
                input$tabs,
                input[[name]]$height,
                input[[name]]$width))
  })

}

ui <- fluidPage(

  includeJqueryUI(),

  actionButton('enable', 'Enable resizable'),
  actionButton('disable', 'Disable resizable'),
  verbatimTextOutput('size'),

  tabsetPanel(

    id = 'tabs',

    tabPanel(
      title = 'shiny inputs',
      jqui_resizabled(actionButton('btn', 'Button')),
      jqui_resizabled(checkboxGroupInput('chbox', 'Checkbox',
                                         choices = month.name, inline = TRUE,
                                         width = '200px'),
                      options = list(handles = 'e')),
      jqui_resizabled(dateRangeInput('date', 'Date range'),
                      options = list(handles = 'e')),
      jqui_resizabled(fileInput('file', 'File input'),
                      options = list(handles = 'e')),
      jqui_resizabled(numericInput('num', 'Numeric input', value = 1),
                      options = list(handles = 'e')),
      jqui_resizabled(radioButtons('radio', 'Radio input',
                                   choices = month.name, inline = TRUE,
                                   width = '200px'),
                      options = list(handles = 'e')),
      jqui_resizabled(selectInput('select', 'Select input',
                                   choices = month.name),
                      options = list(handles = 'e')),
      jqui_resizabled(sliderInput('slider', 'Slider input',
                                  min = 1, max = 100, value = 50),
                      options = list(handles = 'e')),
      jqui_resizabled(textInput('tex', 'Text input', value = 'text'),
                      options = list(handles = 'e'))
    ),

    tabPanel(
      title = 'text output',
      jqui_resizabled(textOutput('text'))
    ),

    tabPanel(
      title = 'ui output',
      jqui_resizabled(uiOutput('ui'))
    ),

    tabPanel(
      title = 'ggplot',
      jqui_resizabled(plotOutput('gg'))
    ),

    tabPanel(
      title = 'd3heatmap',
      jqui_resizabled(d3heatmapOutput('d3'))
    ),

    tabPanel(
      title = 'highchart',
      jqui_resizabled(highchartOutput('hc'))
    ),

    tabPanel(
      title = 'plotly',
      jqui_resizabled(plotlyOutput('pl'))
    )

  )

)

shinyApp(ui, server)
