library(shiny)
library(shinyjqui)

server <- function(input, output) {

  current_class <- c()

  observe({
    input$class
    class_to_remove <- setdiff(current_class, input$class)
    class_to_add <- setdiff(input$class, current_class)
    current_class <<- input$class
    if (length(class_to_remove) > 0) {
      jqui_remove_class('#foo', paste(class_to_remove, collapse = ' '), duration = 1000)}
    if (length(class_to_add) > 0) {
      jqui_add_class('#foo', paste(class_to_add, collapse = ' '), duration = 1000)}
  })

}

ui <- fluidPage(

  # includeJqueryUI(),

  tags$head(
    tags$style(
      HTML('.class1 { width: 410px; height: 100px; }
            .class2 { text-indent: 40px; letter-spacing: .2em; }
            .class3 { padding: 30px; margin: 10px; }
            .class4 { font-size: 1.1em; }')
    )
  ),

  div(id = 'foo', 'Etiam libero neque, luctus a, eleifend nec, semper at, lorem. Sed pede.'),
  hr(),
  checkboxGroupInput('class', 'Class',
                     choices = list(`width: 410px; height: 100px;` = 'class1',
                                    `text-indent: 40px; letter-spacing: .2em;` = 'class2',
                                    `padding: 30px; margin: 10px;` = 'class3',
                                    `font-size: 1.1em;` = 'class4'))


)

shinyApp(ui, server)
