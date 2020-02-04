
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
#'
#' @return The same object passed in the `ui` parameter
#'
#' @example examples/interactions.R
#' @name Interactions
NULL

#' @rdname Interactions
#' @export
jqui_draggable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL) {
  jqui_interaction(ui, "draggable", operation, options)
}

#' @rdname Interactions
#' @export
jqui_droppable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL) {
  jqui_interaction(ui, "droppable", operation, options)
}

#' @rdname Interactions
#' @export
jqui_resizable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL) {
  jqui_interaction(ui, "resizable", operation, options)
}

#' @rdname Interactions
#' @export
jqui_selectable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL) {
  jqui_interaction(ui, "selectable", operation, options)
}

#' @rdname Interactions
#' @export
jqui_sortable <- function(ui,
                          operation = c("enable", "disable", "destroy", "save", "load"),
                          options = NULL) {
  jqui_interaction(ui, "sortable", operation, options)
}

