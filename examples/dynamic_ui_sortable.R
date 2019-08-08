library(shiny)
library(ggplot2)
library(shinyjqui)
library(shinydashboard)

ui <- fluidPage(
  uiOutput("plotUI")
)

server <- function(input, output) {
  df <- data.frame('Time' = c(1,2,3,4,5), 'Intensity' = c(2,4,6,8,10))
  
  uiCount <- 3
  colCount <- 2
  
  original_min <- 2
  original_max <- 4
  
  observe({
    output$plotUI <- renderUI({
      plot_col_list <- lapply(1:colCount, function(i) {
        plot_output_list <- lapply(1:uiCount, function(j) plotOutput(paste0("time_plot_", i, '_', j), height = 100))
        
        box(id = paste0('plot_col', i), title = paste0('column ', i), width = 12%/%colCount, style = 'min-height: 100px;',
          do.call(tagList, plot_output_list)
        )
      })
      
      do.call(tagList, plot_col_list)
    })
    
    lapply(1:colCount, function(i) {
      lapply(1:uiCount, function(j) {
        output[[paste0("time_plot_", i, '_', j)]] <- renderPlot({
          ggplot() + ggtitle("MRM (Tag)") + theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
            geom_line(data = df, aes(x = `Time`, y = `Intensity`)) +
            geom_rect(aes(xmin = original_min, xmax = original_max, ymin = -Inf, ymax = Inf), alpha = 0.1, fill = "blue")
            
        })
      })
      
      jqui_sortable(
        ui = paste0('#plot_col', i),
        options = list(
          items = "div",
          connectWith = sapply(1:colCount, function(j) paste0('#plot_col', j))
        )
      )
    })
  })
}

shinyApp(ui, server)
