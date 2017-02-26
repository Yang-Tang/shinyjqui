\dontrun{
  # in shiny ui create a span
  tags$span(id = 'foo', 'class animation demo')

  # in shiny server add class 'lead' to the span
  jqui_add_class('#foo', className = 'lead')
}
