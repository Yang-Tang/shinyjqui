#' Create a draggable modal dialog UI
#'
#' This creates the UI for a modal dialog similar to [shiny::modalDialog] except
#' its content is draggable.
#'
#' @inheritParams shiny::modalDialog
#'
#' @return A modified shiny modal dialog UI with its content draggable.
#' @export
#'
draggableModalDialog <- function(..., title = NULL,
                                 footer = shiny::modalButton("Dismiss"),
                                 size = c("m", "s", "l"),
                                 easyClose = FALSE, fade = TRUE) {
  size <- match.arg(size)
  cls <- if (fade) { "modal fade" } else { "modal" }
  shiny::div(
    id = "shiny-modal",
    class = cls,
    tabindex = "-1",
    `data-backdrop` = if (!easyClose) { "static" } ,
    `data-keyboard` = if (!easyClose) { "false" } ,
    shiny::div(
      class = "modal-dialog",
      class = switch(size, s = "modal-sm", m = NULL, l = "modal-lg"),
      jqui_draggable(shiny::div(
        class = "modal-content",
        if (!is.null(title)) {
          shiny::div(
            class = "modal-header",
            shiny::tags$h4(class = "modal-title",  title)
          )
        },
        shiny::div(class = "modal-body", ...),
        if (!is.null(footer)) {
          shiny::div(class = "modal-footer", footer)
        }
      ))
    ),
    shiny::tags$script("$('#shiny-modal').modal().focus();")
  )
}
