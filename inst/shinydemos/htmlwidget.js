// use resizeHandler in htmlwidget
el = $("#htmlwidget-0f3108874355091be24d").get(0);
$(el).resizable();
binding = HTMLWidgets.widgets[0];
$(el).on("resize", function(event, ui) {binding.resize(el, ui.size.width, ui.size.height, el["htmlwidget_data_init_result"])});

