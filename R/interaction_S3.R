jqui_interaction <- function(ui, interaction,
                             operation = c("enable",
                                           "disable",
                                           "destroy",
                                           "save",
                                           "load"),
                             options = NULL) {
  UseMethod("jqui_interaction")
}

jqui_interaction.character <- function(ui, interaction,
                                       operation = c("enable",
                                                     "disable",
                                                     "destroy",
                                                     "save",
                                                     "load"),
                                       options = NULL) {
  type <- "interaction"

  func <- interaction
  rm(interaction)

  operation <- match.arg(operation)

  debug <- getOption("shinyjqui.debug")

  sendMsg()

  return(ui)
}

jqui_interaction.JS_EVAL <- function(ui, interaction,
                                     operation = c("enable",
                                                   "disable",
                                                   "destroy",
                                                   "save", "
                                                   load"),
                                     options = NULL
) {
  jqui_interaction.character(ui, interaction, operation, options)
}

jqui_interaction.shiny.tag <- function(ui, interaction,
                                       operation = c("enable",
                                                     "disable",
                                                     "destroy",
                                                     "save",
                                                     "load"),
                                       options = NULL) {
  addInteractJS(ui, interaction, options)
}

jqui_interaction.shiny.tag.list <- function(ui, interaction,
                                            operation = c("enable",
                                                          "disable",
                                                          "destroy",
                                                          "save",
                                                          "load"),
                                            options = NULL) {
  ui[] <- lapply(ui, addInteractJS,
                 func = interaction, options = options)
  return(ui)
}
