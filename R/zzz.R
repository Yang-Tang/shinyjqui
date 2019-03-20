.onLoad <- function(libname, pkgname) {

  op <- options()
  op.shinyjqui <- list(shinyjqui.debug = FALSE)
  toset <- !(names(op.shinyjqui) %in% names(op))
  if(any(toset)) options(op.shinyjqui[toset])

  shiny::registerInputHandler("shinyjqui.df", function(data, shinysession, name) {
    data <- lapply(data, function(x) {
      `if`(length(x) == 0, NA_character_, unlist(x))
    })
    data.frame(data, stringsAsFactors = FALSE)
  }, force = TRUE)

  invisible()

}
