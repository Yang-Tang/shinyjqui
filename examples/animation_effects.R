\dontrun{
  # in shiny ui create a plot
  plotOutput('foo')

  # in shiny server apply a 'bounce' effect to the plot
  jqui_effect('#foo', 'bounce')

  # in shiny server hide the plot with a 'fold' effect
  jqui_hide('#foo', 'fold')

  # in shiny server show the plot with a 'blind' effect
  jqui_show('#foo', 'blind')
}
