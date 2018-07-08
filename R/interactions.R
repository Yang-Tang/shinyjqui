jqui_interaction <- function(ui, interaction,
                             operation = c("enable", "disable", "destroy", "save", "load"),
                             options = NULL, switch = NULL) {
  UseMethod("jqui_interaction")
}

jqui_interaction.character <- function(ui, interaction,
                                       operation = c("enable", "disable", "destroy", "save", "load"),
                                       options = NULL, switch = NULL) {
  type <- "interaction"

  func <- interaction
  rm(interaction)

  if (!is.null(switch)) {
    warning(
      "The switch parameter is deprecated, ",
      "please use the operation parameter instead"
    )
    operation <- switch(switch, `TRUE` = "enable", `FALSE` = "disable")
  }
  rm(switch)

  operation <- match.arg(operation)

  sendMsg()
  return(ui)
}

jqui_interaction.JS_EVAL <- function(ui, interaction,
                                     operation = c("enable", "disable", "destroy", "save", "load"),
                                     options = NULL, switch = NULL) {
  jqui_interaction.character(ui, interaction, operation, options, switch)
}

jqui_interaction.shiny.tag <- function(ui, interaction,
                                       operation = c("enable", "disable", "destroy", "save", "load"),
                                       options = NULL, switch = NULL) {
  addInteractJS(ui, interaction, options)
}

jqui_interaction.shiny.tag.list <- function(ui, interaction,
                                            operation = c("enable", "disable", "destroy", "save", "load"),
                                            options = NULL, switch = NULL) {
  ui[] <- lapply(ui, addInteractJS,
                       func = interaction, options = options)
  return(ui)
}


#' Mouse interactions
#'
#' Attach mouse-based interactions to shiny html tags and input/output widgets,
#' and provide ways to manipulate them. The interactions include:
#' * [draggable](http://api.jqueryui.com/draggable/): Allow elements to be
#' moved using the mouse.
#' * [droppable](http://api.jqueryui.com/droppable/): Create targets for
#' draggable elements.
#' * [resizable](http://api.jqueryui.com/resizable/): Change the size of an
#' element using the mouse.
#' * [selectable](http://api.jqueryui.com/selectable/): Use the mouse to select
#' elements, individually or in a group.
#' * [sortable](http://api.jqueryui.com/sortable/): Reorder elements in a list
#' or grid using the mouse.
#'
#' The first parameter `ui` determines the target shiny ui element(s) to work
#' with. It accepts objects with different classes. When you provide a
#' `shiny.tag` (e.g., shiny inputs/outputs or ui created by [shiny::tags]) or a
#' `shiny.tag.list` (by [tagList()][shiny::tagList]) object, the functions return the same
#' ui object with interaction effects attached. When a
#' [jQuery_selector](https://api.jquery.com/category/selectors/) or a javascript
#' expression is provided, the functions first use it to locate the target ui
#' element(s) in shiny app, and then attach or manipulate the interactions.
#' Therefore, you can use the first way in `ui` of a shiny app to created
#' elements with interaction effects, or use the second way in `server` to
#' manipulate the interactions.
#'
#' The `operation` parameter is valid only in the second way. It determines how
#' to manipulate the interaction, which includes:
#' * `enable`: Attach the corresponding mouse interaction to the target(s).
#' * `disable`: Attach the interaction if not and disable it at once (only set the options).
#' * `destory`: Destroy the interaction.
#' * `save`: Attach the interaction if not and save the current interaction state.
#' * `load`: If interaction attached, restore the target(s) to the last saved interaction state.
#'
#' With mouse interactions attached, the corresponding interaction states, e.g.
#' `position` of draggable, `size` of resizable, `selected` of selectable and
#' `order` of sortable, will be send to server in the form of
#' `input$<id>_<state>`. The default values can be overridden by setting the
#' `shiny` option in the `options` parameter. Please see the vignette
#' `Introduction to shinyjqui` for more details.
#'
#' The functions `jqui_draggabled()`, `jqui_droppabled()`, `jqui_resizabled()`,
#' `jqui_selectabled()` and `jqui_sortabled()` are deprecated. Please use the
#' corresponding `-able()` functions instead.
#'
#' @param ui The target ui element(s) to be manipulated. Can be
#'   * A `shiny.tag` or `shiny.tag.list` object
#'   * A string of [jQuery_selector](https://api.jquery.com/category/selectors/)
#'   * A [JS()][htmlwidgets::JS()] wrapped javascript expression that returns a
#'   [jQuery object](http://api.jquery.com/Types/#jQuery).
#' @param operation A string to determine how to manipulate the mouse interaction.
#'   Should be one of `enable`, `disable`, `destroy`, `save` and `load`. Ignored
#'   when `ui` is a `shiny.tag` or `shiny.tag.list` object. See Details.
#' @param options A list of
#'   [interaction_specific_options](http://api.jqueryui.com/category/interactions/).
#'   Ignored when `operation` is set as `destroy`. This parameter also
#'   accept a `shiny` option that controls the shiny input value returned from
#'   the element. See Details.
#' @param selector,tag,switch Deprecated, just keep for backward compatibility.
#'   Please use `ui` and `operation` parameters instead.
#'
#' @return The same object passed in the `ui` parameter
#'
#' @example examples/interactions.R
#' @name Interactions
NULL


#' @rdname Interactions
#' @export
jqui_draggabled <- function(tag, options = NULL) {
  .Deprecated(
    msg = "jqui_draggabled() will be deprecated, please use jqui_draggable() instead."
  )
  addInteractJS(tag, "draggable", options)
}

#' @rdname Interactions
#' @export
jqui_droppabled <- function(tag, options = NULL) {
  .Deprecated(
    msg = "jqui_droppabled() will be deprecated, please use jqui_droppable() instead."
  )
  addInteractJS(tag, "droppable", options)
}

#' @rdname Interactions
#' @export
jqui_resizabled <- function(tag, options = NULL) {
  .Deprecated(
    msg = "jqui_resizabled() will be deprecated, please use jqui_resizable() instead."
  )
  addInteractJS(tag, "resizable", options)
}

#' @rdname Interactions
#' @export
jqui_selectabled <- function(tag, options = NULL) {
  .Deprecated(
    msg = "jqui_selectabled() will be deprecated, please use jqui_selectable() instead."
  )
  addInteractJS(tag, "selectable", options)
}

#' @rdname Interactions
#' @export
jqui_sortabled <- function(tag, options = NULL) {
  .Deprecated(
    msg = "jqui_sortabled() will be deprecated, please use jqui_sortable() instead."
  )
  addInteractJS(tag, "sortable", options)
}

#' @rdname Interactions
#' @export
jqui_draggable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL, selector = NULL, switch = NULL) {
  if(!is.null(selector)) {
    warning(
      "The selector argument is deprecated, ",
      "please use the ui argument instead"
    )
    ui <- selector
  }
  jqui_interaction(ui, "draggable", operation, options, switch)
}

#' @rdname Interactions
#' @export
jqui_droppable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL, selector = NULL, switch = NULL) {
  if(!is.null(selector)) {
    warning(
      "The selector argument is deprecated, ",
      "please use the ui argument instead"
    )
    ui <- selector
  }
  jqui_interaction(ui, "droppable", operation, options, switch)
}

#' @rdname Interactions
#' @export
jqui_resizable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL, selector = NULL, switch = NULL) {
  if(!is.null(selector)) {
    warning(
      "The selector argument is deprecated, ",
      "please use the ui argument instead"
    )
    ui <- selector
  }
  jqui_interaction(ui, "resizable", operation, options, switch)
}

#' @rdname Interactions
#' @export
jqui_selectable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL, selector = NULL, switch = NULL) {
  if(!is.null(selector)) {
    warning(
      "The selector argument is deprecated, ",
      "please use the ui argument instead"
    )
    ui <- selector
  }
  jqui_interaction(ui, "selectable", operation, options, switch)
}

#' @rdname Interactions
#' @export
jqui_sortable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL, selector = NULL, switch = NULL) {
  if(!is.null(selector)) {
    warning(
      "The selector argument is deprecated, ",
      "please use the ui argument instead"
    )
    ui <- selector
  }
  jqui_interaction(ui, "sortable", operation, options, switch)
}

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
