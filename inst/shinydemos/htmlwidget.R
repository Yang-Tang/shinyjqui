library(shinyjqui)
library(d3heatmap)
library(plotly)

qplot(1:10) %>%
  ggplotly() %>%
  jqui_draggable() %>%
  jqui_resizable()

d3heatmap(mtcars) %>%
  jqui_resizable()


jqui_resizable(plot_ly(data = iris, x = ~Sepal.Length, y = ~Petal.Length))
