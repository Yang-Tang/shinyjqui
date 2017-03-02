#' A shiny input control to show the order of a list of items
#'
#' Display a list items whose order can be changed by drag and drop within or
#' between \code{orderInput}(s). The current items order can be obtained from
#' \code{input$inputId_order}.
#'
#' @param inputId The \code{input} slot that will be used to access the current
#'   order of items.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param items Items to display, can be a list, an atomic vector or a factor.
#'   For list and atomic vector, if named, the names are displayed and the order
#'   is given in values. For factor, values are displayed and the order is
#'   given in levels
#' @param as_source A boolean value to determine whether the \code{orderInput}
#'   is set as source mode. If source mode, items in this \code{orderInput} can
#'   only be dragged (copied) to the connected non-source \code{orderInput}(s)
#'   defined by \code{connect} argument. If non-source mode, items in the
#'   \code{orderInput} can be dragged (moved) within or toward other connected
#'   non-source \code{orderInput}(s) defined by \code{connect} argument.
#' @param connect optional, a vector of \code{inputId}(s) of other
#'   \code{orderInput}(s) that the current \code{orderInput} connects to. The
#'   behavior of the conneted \code{orderInput}(s) depend on the
#'   \code{as_source} argument.
#' @param item_class One of the
#'   \href{http://www.w3schools.com/bootstrap/bootstrap_buttons.asp}{Bootstrap
#'   Button Styles} to apply to each item.
#' @param placeholder A character string to show when there is no item left in
#'   the \code{orderInput}.
#' @param width The width of the input, e.g. '400px', or '100\%'. Passed to
#'   \code{\link[shiny]{validateCssUnit}}.
#' @param ... Arguments passed to \code{shiny::tags$div} which is used to build
#'   the container of the \code{orderInput}.
#'
#' @return A \code{orderInput} control that can be added to a UI definition.
#' @export
#'
#' @example examples/orderInput.R
orderInput <- function(inputId, label, items,
                       as_source = FALSE, connect = NULL,
                       item_class = c('default', 'primary', 'success',
                                      'info', 'warning', 'danger'),
                       placeholder = NULL,
                       width = '500px', ...) {

  if(is.null(connect)) {
    connect <- 'false'
  } else {
    connect <- paste0('#', connect, collapse = ', ')
  }
  item_class <- sprintf('btn btn-%s', match.arg(item_class))

  if (length(items) == 0 || (!is.vector(items) && !is.factor(items))) {
    item_tags <- list()
  } else {
    if (is.vector(items)) {
      item_values <- unlist(items, recursive = FALSE, use.names = TRUE)
      nms <- names(item_values)
      item_html <- `if`(is.null(nms) || any(nms == '') || any(is.na(nms)),
                        item_values, nms)
    } else if (is.factor(items)) {
      item_values <- as.numeric(items)
      item_html <- as.character(items)
    }
    item_tags <- lapply(1:length(item_values), function(i) {
      tag <- shiny::tags$div(item_html[i],
                             `data-value` = item_values[i],
                             class = item_class, style = 'margin: 1px')
      if (as_source) {
        options <- list(connectToSortable = connect, helper = 'clone', cancel = '')
        tag <- jqui_draggabled(tag, options = options)
      }
      return(tag)
    })
  }

  style <- sprintf('width: %s; font-size: 0px; min-height: 25px;',
                   shiny::validateCssUnit(width))
  container <- shiny::tagSetChildren(
    shiny::tags$div(id = inputId, style = style, ...),
    list = item_tags
  )
  if (!as_source) {
    cb <- 'function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}'
    func <- 'function(event, ui){
      return $(event.target).children().map(function(i, e){
        return $(e).attr("data-value");
      }).get();
    }'
    options <- list(connectWith = connect,
                    remove = htmlwidgets::JS(cb),
                    shiny = list(
                      order = list(
                        sortcreate = htmlwidgets::JS(func),
                        sortupdate = htmlwidgets::JS(func)
                      )
                    ))
    container <- jqui_sortabled(container, options = options)
  }

  if(!is.null(placeholder)) {
    css <- '#%s:empty:before{content: "%s"; font-size: 14px; opacity: 0.5;}'
    placeholder <- shiny::singleton(
      shiny::tags$head(
        shiny::tags$style(
          shiny::HTML(
            sprintf(css, inputId, placeholder)
          )
        )
      )
    )
  }

  shiny::tagList(
    placeholder,
    shiny::tags$label(label, `for` = inputId),
    container
  )

}
