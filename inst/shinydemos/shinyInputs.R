library(shiny)

ui <- fluidPage(

  "id along with shiny-input-container:",
  checkboxGroupInput("checkboxGroupInput", "checkboxGroupInput", choices = 1:3),
  dateInput("dateInput", "dateInput"),
  dateRangeInput("dataRangeInput", "dataRangeInput"),
  radioButtons("radioButtins", "radioButtons", month.abb),

  "id inside shiny-input-container:",
  checkboxInput("checkboxInput", "checkboxInput", value = 1),
  fileInput("fileInput", 'fileInput'),
  numericInput("numericInput", "numericInput", 100),
  selectInput("selectInput", "selectInput", month.abb),
  sliderInput("sliderInput", "sliderInpug", 1, 10, 5),
  textInput("textInput", "textInput"),
  textAreaInput("textAreaInput", "textAreaInput"),
  passwordInput("passwordInput", "passwordInput"),

  "no shiny-input-container:",
  div(actionButton("actionButton", "actionButton")),

  "no id:",
  submitButton(),
  modalButton("modalButton")
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
