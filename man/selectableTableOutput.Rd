% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/selectableTableOutput.R
\name{selectableTableOutput}
\alias{selectableTableOutput}
\title{Create a table output element with selectable rows or cells}
\usage{
selectableTableOutput(outputId, selection_mode = c("row", "cell"))
}
\arguments{
\item{outputId}{output variable to read the table from}

\item{selection_mode}{one of \code{"row"} or \code{"cell"} to define either entire row
or individual cell can be selected.}
}
\value{
A table output element that can be included in a panel
}
\description{
Render a standard HTML table with its rows or cells selectable. The server
will receive the index of selected rows or cells stored in
\verb{input$<outputId>_selected}.
}
\details{
Use mouse click to select single target, lasso (mouse dragging) to select
multiple targets, and Ctrl + click to add or remove selection. In \code{row}
selection mode, \verb{input$<outputId>_selected} will receive the selected row
index in the form of numeric vector. In \code{cell} selection mode,
\verb{input$<outputId>_selected} will receive a dataframe with \code{rows} and
\code{columns} index of each selected cells.
}
\examples{
## Only run this example in interactive R sessions
if (interactive()) {
  shinyApp(
    ui = fluidPage(
      verbatimTextOutput("selected"),
      selectableTableOutput("tbl")
    ),
    server = function(input, output) {
      output$selected <- renderPrint({input$tbl_selected})
      output$tbl <- renderTable(mtcars, rownames = TRUE)
    }
  )
}

}
\seealso{
\link[shiny:renderTable]{shiny::tableOutput}, \link{sortableTableOutput}
}
