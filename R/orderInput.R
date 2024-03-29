
digestItems <- function(items) {
  if (length(items) == 0 || (!is.vector(items) && !is.factor(items))) {
    item_values <- list()
    item_labels <- list()
  } else if(is.vector(items)) {
    # item_values <- unlist(items, recursive = FALSE, use.names = TRUE)
    # nms <- names(item_values)
    # item_values <- unname(item_values)
    # item_labels <- `if`(is.null(nms) || any(nms == "") || any(is.na(nms)),
                        # item_values, nms)

    items <- unlist(items, recursive = FALSE, use.names = TRUE)
    # jsonlite doesn't support named vector any more
    item_values <- unname(items)
    # use names2() to handle NA or Null
    item_labels <- rlang::names2(items)
    item_labels[item_labels == ""] <- item_values[item_labels == ""]

  } else if (is.factor(items)) {
    item_values <- as.numeric(items)
    item_labels <- as.character(items)
  }
  return(list(values = item_values, labels = item_labels))
}


orderInputNonSource <- function(x) {

  dep <- htmltools::htmlDependency(
    name    = "orderInputBinding",
    version = "0.4.0",
    package = "shinyjqui",
    src     = "www",
    script  = "orderInputBinding.js"
  )

  container <- htmltools::tagAppendAttributes(x$container, class = "jqui-orderInput")
  container <- htmltools::tagSetChildren(container, list = x$item_tags)
  cb <- "function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}"
  sortable_opt <- list(connectWith = x$connect,
                       remove      = htmlwidgets::JS(cb))
  container <- jqui_sortable(container, options = sortable_opt)

  return(htmltools::tagList(dep, x$placeholder, x$label, container))

}

orderInputSource <- function(x) {

  item_tags <- lapply(x$item_tags, function(tag) {
    draggable_opt <- list(connectToSortable = x$connect,
                          helper            = "clone",
                          cancel            = "")
    jqui_draggable(tag, options = draggable_opt)
  })

  container <- htmltools::tagAppendAttributes(x$container, class = "jqui-orderInput-source")
  container <- htmltools::tagSetChildren(container, list = item_tags)
  # make the "source" orderInput a recycle bin as well,
  # idea from https://community.rstudio.com/t/customizing-shinyjqui-package/48140/4
  droppable_opt <- list(
    # remove the dropped item when its helper = "origin" (default)
    drop    = htmlwidgets::JS("function(e, ui) { $(ui.helper).remove(); }"),
    # show red warning color when hover
    classes = list(`ui-droppable-hover` = "ui-state-error"),
    # don't show red color for its own items
    accept  = ":not(.jqui-orderInput-source *)"
  )
  container <- jqui_droppable(container, options = droppable_opt)

  return(htmltools::tagList(x$placeholder, x$label, container))

}


#' Create a shiny input control to show the order of a set of items
#'
#' Display a set of items whose order can be changed by drag and drop inside or
#' between `orderInput`(s). The item order is send back to server in the from of
#' `input$inputId`.
#'
#' `orderInput`s can work in either connected mode or stand-alone mode. In
#' stand-alone mode, items can only be drag and drop inside the input control.
#' In connected mode, items to be dragged between `orderInput`s, which is
#' controlled by the `connect` parameter. This is a one-way relationship. To
#' connect items in both directions, the `connect` parameter must be set in both
#' `orderInput`s.
#'
#' When in connected mode, `orderInput` can be set as source-only through the
#' `as_source` parameter. The items in a "source" `orderInput` can only be
#' copied, instead of moved, to other connected non-source `orderInput`(s). From
#' shinyjqui v0.4.0, A "source" `orderInput` will become a "recycle bin" for
#' items from other `orderInput`s as well. This means, if you want to delete an
#' item, you can drag and drop it into a "source" `orderInput`. This feature can
#' be disabled by setting the `options` of non-source `orderInput`(s) as
#' `list(helper = "clone")`.
#'
#' From shinyjqui v0.4.0 and above, the `orderInput` function was implemented in
#' the similar way as other classical shiny inputs, which brought two changes:
#' 1) The input value was changed from `input$inputId_order` to `input$inputId`;
#' 2) The new version supports [updateOrderInput] function which works in the
#' same way as other shiny input updater functions. To keep the backward
#' compatibility, a `legacy` argument was provided if user wanted to use the old
#' version.
#'
#' @param inputId The `input` slot that will be used to access the current order
#'   of items.
#' @param label Display label for the control, or `NULL` for no label.
#' @param items Items to display, can be a list, an atomic vector or a factor.
#'   For list or atomic vector, if named, the names are displayed and the order
#'   is given in values. For factor, values are displayed and the order is given
#'   in levels
#' @param as_source A boolean value to determine whether the `orderInput` is set
#'   as source mode. Only works if the `connect` argument was set.
#' @param connect Optional. Allow items to be dragged between `orderInput`s.
#'   Should be a vector of `inputId`(s) of other `orderInput`(s) that the items
#'   from this `orderInput` should be connected to.
#' @param item_class A vector of the [Bootstrap color utility
#'   classes](https://getbootstrap.com/docs/4.0/utilities/colors/) to apply to
#'   each item. Can be any of `c("default", "primary", "success", "info",
#'   "warning", "danger")`.
#' @param placeholder A character string to show when there is no item left in
#'   the `orderInput`.
#' @param width The width of the input, e.g. '400px', or '100\%'. Passed to
#'   [shiny::validateCssUnit].
#' @param legacy A boolean value. Whether to use the old version of the
#'   `orderInput` function.
#' @param ... Arguments passed to `shiny::tags$div` which is used to build the
#'   container of the `orderInput`.
#'
#' @return An `orderInput` control that can be added to a UI definition.
#' @export
#'
#' @example examples/orderInput.R
orderInput <- function(inputId, label, items,
                       as_source = FALSE, connect = NULL,
                       item_class = "default",
                       placeholder = NULL, width = "500px",
                       legacy = FALSE, ...) {

  if(legacy) {
    return(orderInputLegacy(inputId, label, items, as_source, connect,
                            item_class, placeholder, width, ...))
  }

  connect <- `if`(is.null(connect),
                  "false", paste0("#", connect, collapse = ", "))

  placeholder <- sprintf('#%s:empty:before{content: "%s"; font-size: 14px; opacity: 0.5;}',
                         inputId, placeholder)
  placeholder <- shiny::singleton(shiny::tags$head(shiny::tags$style(shiny::HTML(placeholder))))

  # code from shiny:::shinyInputLabel
  label <- shiny::tags$label(label,
                             class = "control-label",
                             class = if (is.null(label)) "shiny-label-null",
                             id    = paste0(inputId, "-label"),
                             `for` = inputId)


  width <- shiny::validateCssUnit(width)
  style <- sprintf("width: %s; font-size: 0px; min-height: 25px;", width)
  container <- shiny::tags$div(id = inputId, style = style, ...)

  items <- digestItems(items)
  item_class <- match.arg(arg = item_class,
                          choices = c("default", "primary", "success",
                                      "info", "warning", "danger"),
                          several.ok = TRUE)
  item_class <- rep(item_class, length = length(items$values))
  item_class <- sprintf("btn btn-%s", item_class)
  tagsBuilder <- function(value, label, class) {
    shiny::tags$div(
      `data-value` = value,
      class = class,
      style = "margin: 1px",
      label
    )
  }
  item_tags <- mapply(tagsBuilder, items$values, items$labels, item_class,
                      SIMPLIFY = FALSE, USE.NAMES = FALSE)


  x <- list(connect = connect,
            placeholder = placeholder,
            label = label,
            container = container,
            item_tags = item_tags)

  if(as_source) {
    return(orderInputSource(x))
  } else {
    return(orderInputNonSource(x))
  }

}



#' Change the value of an orderInput on the client
#'
#' Similar to the input updater functions of shiny package, this function send a
#' message to the client, telling it to change the settings of an [orderInput]
#' object. Any arguments with NULL values will be ignored; they will not result
#' in any changes to the input object on the client. The function can't update
#' the "source" `orderInput`s.
#'
#'
#' @inheritParams orderInput
#'
#' @param session The `session` object passed to function given to
#'   `shinyServer`.
#'
#' @export
#'
#' @example examples/updateOrderInput.R
updateOrderInput <- function (session, inputId, label = NULL,
                              items = NULL, connect = NULL,
                              item_class = NULL) {

  if(!is.null(item_class)) {
    item_class <- match.arg(arg = item_class,
                         choices = c("default", "primary", "success",
                                     "info", "warning", "danger"),
                         several.ok = TRUE)
  }

  if(!is.null(items)) {items <- digestItems(items)}
  if(!is.null(connect)){
    if(length(connect) == 1 && connect == FALSE) {
      connect <- "false"
    } else {
      connect <- paste0("#", connect, collapse = ", ")
    }
  }
  message <- list(label      = label,
                  items      = items,
                  connect    = connect,
                  item_class = item_class)
  message <- Filter(Negate(is.null), message)
  session$sendInputMessage(inputId, message)
}

orderInputLegacy <- function(inputId, label, items,
                       as_source = FALSE, connect = NULL,
                       item_class = c(
                         "default", "primary", "success",
                         "info", "warning", "danger"
                       ),
                       placeholder = NULL,
                       width = "500px", ...) {
  if (is.null(connect)) {
    connect <- "false"
  } else {
    connect <- paste0("#", connect, collapse = ", ")
  }
  item_class <- sprintf("btn btn-%s", match.arg(item_class))

  if (length(items) == 0 || (!is.vector(items) && !is.factor(items))) {
    item_tags <- list()
  } else {
    if (is.vector(items)) {
      item_values <- unlist(items, recursive = FALSE, use.names = TRUE)
      nms <- names(item_values)
      item_html <- `if`(
        is.null(nms) || any(nms == "") || any(is.na(nms)),
        item_values, nms
      )
    } else if (is.factor(items)) {
      item_values <- as.numeric(items)
      item_html <- as.character(items)
    }
    item_tags <- lapply(1:length(item_values), function(i) {
      tag <- shiny::tags$div(
        item_html[i],
        `data-value` = item_values[i],
        class = item_class, style = "margin: 1px"
      )
      if (as_source) {
        options <- list(connectToSortable = connect, helper = "clone", cancel = "")
        tag <- jqui_draggable(tag, options = options)
      }
      return(tag)
    })
  }

  style <- sprintf(
    "width: %s; font-size: 0px; min-height: 25px;",
    shiny::validateCssUnit(width)
  )
  container <- shiny::tagSetChildren(
    shiny::tags$div(id = inputId, style = style, ...),
    list = item_tags
  )
  if (!as_source) {
    cb <- "function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}"
    func <- 'function(event, ui){
      return $(event.target).children().map(function(i, e){
        return $(e).attr("data-value");
      }).get();
    }'
    options <- list(
      connectWith = connect,
      remove = htmlwidgets::JS(cb),
      shiny = list(
        order = list(
          sortcreate = htmlwidgets::JS(func),
          sortupdate = htmlwidgets::JS(func)
        )
      )
    )
    container <- jqui_sortable(container, options = options)
  }

  if (!is.null(placeholder)) {
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
