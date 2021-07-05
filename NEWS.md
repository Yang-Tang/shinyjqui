# shinyjqui 0.4.1

## shinyjqui 0.4.0

* __New feature:__ (Experimentally) Now the interaction functions can work on static htmlwidgets in RStudio Viewer or RMarkdown (e.g. `jqui_resizable(plotly::plot_ly(data = iris, x = ~Sepal.Length, y = ~Petal.Length))`). (#44)
* __New feature:__ Now `orderInput()` can be updated with `updateOrderInput()`. (#41, #57)
* __New feature:__ Items of an `orderInput()` can now be deleted by drag and drop them to an "source" `orderInput()`. (Idea from [raytong](https://community.rstudio.com/t/customizing-shinyjqui-package/48140/4) #65)
* __New feature:__ New `jqui_position()` function to position a shiny ui relative to another.
* __New feature:__ Uses [TouchPunch](https://github.com/furf/jquery-ui-touch-punch) to enable mobile use. (Thanks @rquitales, #45)
* __Breaking change:__ The `orderInput` function is now implemented in the similar way as other shiny inputs, so its input value has been changed from `input$inputId_order` to `input$inputId`.
* __Breaking change:__ Removed `jqui_draggabled()`, `jqui_droppabled()`, `jqui_resizabled()`, `jqui_selectabled()`, `jqui_sortabled()` and `includeJqueryUI()` as they have been deprecated for a long time.
* __Breaking change:__ Removed deprecated `selector`, `tag` and `switch` parameters from interaction and effect functions.
* __Bug fix:__ Effect-specific options are no longer ignored by `jqui_effect()`. (#56)
* __Bug fix:__ `input$id_order` of sortable now return values when the `connectToSortable` option is used.
* __Bug fix:__ Nested interaction functions was not working with a shiny tag without an id (e.g. `jqui_resizable(jqui_draggable(div("aaa")))`). (#66)
* __Bug fix:__ Nested interaction functions showed "Action abort" warning to a shiny tag without an id. (#66)
* __Bug fix:__ When using `load` operation to a sortable element or `orderInput`, the items from other "source" `orderInput`s were not removed. (#70)
* __Bug fix:__ Enable `NULL` label in `orderInput()`. (#63)
* __Bug fix:__ A regression bug introduced in v0.3.3 that interactive tag is not effective when inserted by `insertUI`. (#58)


## shinyjqui 0.3.3

* __Bug fix:__ Fixed an incompatibility with Shiny v1.4.0: due to Shiny upgrading from jQuery 1.x to 3.x, the timing of shinjqui initialization routines has changed.
* __Bug fix:__ `sortableRadioButtons`/`sortableCheckboxGroupInput` do not work when inline. (@sam-harvey, #37).
* __Bug fix:__ For interaction functions, the `shiny` options with the same suffix will overwrite the default settings, thus affect the return value of other interaction widgets. (#43)
* __Bug fix:__ Interaction functions not working in `ui` mode in flexdashboard. (#53)
* Add global option `shinyjqui.debug`, can be `TURE` or `FALSE`(default), to control whether to load the original/minified `shinyjqui.js` (#39) and to display/hide javascript debug message (e.g. `options(shinyjqui.debug = TRUE)`) (#3).


## shinyjqui 0.3.2

* __Bug fix:__ The interaction functions were not working in `ui` mode when the `ui` has an id with spaces.
* __Bug fix:__ The interaction functions were not working in `ui` mode when there are other output elements exist. (#25)
* __Bug fix:__ Effect and class functions were not working duo to the upgrade of v0.3.0. (#26, #28)


## shinyjqui 0.3.1

* __Bug fix:__ The interaction functions were not working in `selector` mode duo to the v0.3.0 update.
* __Bug fix:__ For the shiny output elements created by `insertUI` or `renderUI`, the mouse interaction effects are now working.


## shinyjqui 0.3.0

* __New feature:__ Introduce `save` and `load` operations to mouse-interaction attached html elements. This enabled client-side store and restore the elements' states (eg. position, size, selection and order). (#16)
* __New feature:__ The `-able` functions can be used in both shiny `server` and `ui`, and therefore, the `-abled` functions are deprecated.
* __New feature:__ Adds shiny bookmark supporting to mouse-interaction attached html elements. This enabled server-side or across-client store and restore the elements' states (eg. position, size, selection and order). (#12)
* __New feature:__ Now, all interaction functions' `selector` argument accepts `JS()` wrapped javascript expression. This made the target element selection more flexible. 
* __New feature:__ Add `draggableModalDialog()`, `sortableCheckboxGroupInput()`, `sortableRadioButtons()`, `sortableTabsetPanel()`, `sortableTableOutput()` and `selectableTableOutput()` functions to create shiny inputs and outputs with mouse interactions.
* __Breaking change:__ The `switch` argument in mouse-interaction functions was replaced with `operation` argument to support more options.
* __Breaking change:__ The shiny input values `selected` from selectable and `order` from sortable now return elements' `innerText` instead of `innerHTML`.
* __Bug fix:__ The mouse interaction function doesn't work when the same element is inserted again. (#6, #8)
* __Bug fix:__ Resizable interferes with other interactions when the target element is a shiny output. (#10)
* __Bug fix:__ Add `htmlDependency` to `jqui_icon()` to make it work in version 0.2.0 and above.


## shinyjqui 0.2.0

* No longer needed to call `includeJqueryUI()` before using other `shinyjqui` functions.(#4)
* New `jqui_icon()` to create a jQuery UI icon.
* New `jqui_toggle()` to toggle display/hide state of a shiny html element with animation.
* New pre-defined interaction-specific shiny input values: `is_dragging` for draggable; `over`, `drop`, `dropped` and `out` for droppable; `is_resizing` for resizable; `is_selecting` for selectable.(#1) See vignettes for details. 
* Minify `shinyjqui.js`.(#3)
* Import and export `JS()` from `htmlwidgets` package.
* Add pkgdown docs.
* Documentation with Roxygen2 6.0.1.

## shinyjqui 0.1.0

* Added a `NEWS.md` file to track changes to the package.



