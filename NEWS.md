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



