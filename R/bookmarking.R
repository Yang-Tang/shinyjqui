#' Enable bookmarking state of mouse interactions
#'
#' Enable shiny
#' [bookmarking_state](https://shiny.rstudio.com/articles/bookmarking-state.html)
#' of mouse interactions. By calling this function in `server`, the elements'
#' `position`, `size`, `selection state` and `sorting state` changed by mouse
#' operations can be saved and restored through an URL.
#'
#' @export
jqui_bookmarking <- function() {
  shiny::onRestored(function(state) {
    inputs <- state$input
    for (name in names(inputs)) {
      if (!grepl("__shinyjquiBookmarkState__", name)) next()
      info <- strsplit(name, "__")[[1]]
      selector <- paste0("#", info[1])
      options <- list(state = inputs[[name]])
      func <- switch(info[3],
                     "draggable" = jqui_draggable,
                     "droppable" = jqui_droppable,
                     "resizable" = jqui_resizable,
                     "sortable" = jqui_sortable,
                     "selectable" = jqui_selectable
      )
      func(ui = selector, operation = "load", options = options)
    }
  })
}
