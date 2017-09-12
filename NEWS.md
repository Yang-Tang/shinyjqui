## shinyjqui 0.2.9001

* Fix a bug that the mouse interaction function `-abled()` doesn't work when the same element is inserted again. (#6, #8)
* Fix a bug that resizable interfere other interactions when the target element is a shiny output. (#10)
* Add `htmlDependency` to `jqui_icon()` to make it work in version 0.2.0 and above.

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



