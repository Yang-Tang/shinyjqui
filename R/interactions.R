
#' Initiate jQuery UI interactions
#'
#' These functions should be used in \code{ui} of a shiny document that initiate
#' interactions of shiny tag element(s).
#'
#' @param tag A shiny tag to enable interaction.
#' @param options A list of interaction options. Please see
#'   \url{http://api.jqueryui.com/category/interactions/} for more details.
#'
#' @return A modified shiny tag with interation enabled.
#'
#' @examples
#' @name Interactions_initializer
NULL


#' @rdname Interactions_initializer
#' @export
jqui_resizabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'resizable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_sortabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'sortable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_draggabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'draggable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_droppabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'droppable', options)
}


#' @rdname Interactions_initializer
#' @export
jqui_selectabled <- function(tag, options = NULL) {
  addInteractJS(tag, 'selectable', options)
}




#' Enable or disable jQuery UI interactions
#'
#' These functions should be used in \code{server} of a shiny document that
#' enable or disable interactions of shiny tag element(s).
#'
#' @param selector A \href{https://api.jquery.com/category/selectors/}{jQuery's
#'   selector} that determines the shiny tag element(s) whose interaction is
#'   enable or disable interactions.
#' @param switch A boolean value to determine whether to enable or disable an
#'   interaction.
#' @param options A list of interaction options. Ignored when \code{switch} is
#'   set as \code{FALSE}. Please see
#'   \url{http://api.jqueryui.com/category/interactions/} for more details.
#'
#' @examples
#' @name Interactions_switcher
NULL


#' @rdname Interactions_switcher
#' @export
jqui_sortable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'sortable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_draggable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'draggable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_droppable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'droppable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_selectable <- function(selector, switch = TRUE, options = NULL) {
  method = 'interaction'
  func <- 'selectable'
  sendMsg()
}


#' @rdname Interactions_switcher
#' @export
jqui_resizable <- function(selector, switch = TRUE, options = NULL) {
  method <- 'interaction'
  func <- 'resizable'
  sendMsg()
}




#' Create a items list input control whose order can be changed.
#'
#' Create a items list whose order can be changed by drag and drop within or
#' between \code{orderInput}(s). The current items order can be obtained from
#' \code{input$inputId}.
#'
#' @param inputId The \code{input} slot that will be used to access the current
#'   order of items.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param items A list or vector of items to be initially displayed. If named,
#'   the names are displayed to user.
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
#' @examples
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

  if(is.vector(items) && length(items)>0) {
    item_values <- unlist(items, recursive = FALSE, use.names = TRUE)
    item_html <- `if`(is.null(names(item_values)), item_values, names(item_values))
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
  } else {
    item_tags <- list()
  }

  style <- sprintf('width: %s; font-size: 0px; min-height: 25px;',
                   shiny::validateCssUnit(width))
  container <- shiny::tagSetChildren(
    shiny::tags$div(id = inputId, style = style, ...),
    list = item_tags
  )
  if (!as_source) {
    cb <- 'function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}'
    func <- 'function(el, event, ui){
              return $(el).children().map(function(i, e){
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
