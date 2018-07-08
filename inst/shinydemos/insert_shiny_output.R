library(shiny)
library(ggplot2)
library(shinyjqui)

events <- c("value",
            "outputinvalidated",
            "error",
            "recalculating",
            "recalculated",
            "visualchange")

js <- "$(document).on('shiny:%s', function(e){
    if (e.name === 'foo') { console.log(e); }
})"

js <- sapply(events, function(x) {sprintf(js, x)})

js <- paste0(js, collapse = ";\n")


ui <- fluidPage(

  tags$head(tags$script(js)),

  actionButton("add", "Add a plot to tab b"),

  tabsetPanel(
    tabPanel("a", "aaaa"),
    tabPanel("b", "bbbb")
  )
)

server <- function(input, output, session) {

  output$foo <- renderPlot({
    ggplot(mtcars, aes(x = cyl, y = mpg)) + geom_point()
  })

  observeEvent(input$add, {
    insertUI(
      selector = "div[data-value=b]",
      where    = "afterBegin",
      ui       = jqui_resizable(plotOutput("foo"))
    )
  })
}

shinyApp(ui, server)
