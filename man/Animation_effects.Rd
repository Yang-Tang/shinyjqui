% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/effects.R
\name{Animation_effects}
\alias{Animation_effects}
\alias{jqui_effect}
\alias{jqui_show}
\alias{jqui_hide}
\alias{jqui_toggle}
\title{Animation effects.}
\usage{
jqui_effect(ui, effect, options = NULL, duration = 400, complete = NULL)

jqui_show(ui, effect, options = NULL, duration = 400, complete = NULL)

jqui_hide(ui, effect, options = NULL, duration = 400, complete = NULL)

jqui_toggle(ui, effect, options = NULL, duration = 400, complete = NULL)
}
\arguments{
\item{ui}{The target ui element(s) to be manipulated. Can be
\itemize{
\item A string of \href{https://api.jquery.com/category/selectors/}{jQuery_selector}
\item A \link[htmlwidgets:JS]{JS()} wrapped javascript expression that returns a
\href{https://api.jquery.com/Types/}{jQuery object}.
}}

\item{effect}{A string indicating which
\href{https://jqueryui.com/effect/}{animation effect} to use for the
transition.}

\item{options}{A list of effect-specific
\href{https://api.jqueryui.com/category/effects/}{properties} and
\href{https://api.jqueryui.com/easings/}{easing}.}

\item{duration}{A string or number determining how long the animation will
run.}

\item{complete}{A function to call once the animation is complete, called
once per matched element.}
}
\description{
Allow element(s) to show animation effects.
\itemize{
\item \code{jqui_effect()}: Apply an animation effect to matched element(s).
\item \code{jqui_hide()}: Hide the matched element(s) with animation effect.
\item \code{jqui_show()}: Display the matched element(s) with animation effect.
\item \code{jqui_toggle()}: Display or hide the matched element(s) with animation effect.
}
}
\details{
These functions are R wrappers of
\href{https://api.jqueryui.com/effect/}{\code{effect()}},
\href{https://api.jqueryui.com/hide/}{\code{hide()}},
\href{https://api.jqueryui.com/show/}{\code{show()}} and
\href{https://api.jqueryui.com/toggle/}{\code{toggle()}} from jQuery UI library. They
should be used in \code{server} of a shiny document.
}
\examples{
\dontrun{
  # in shiny ui create a plot
  plotOutput('foo')

  # in shiny server apply a 'bounce' effect to the plot
  jqui_effect('#foo', 'bounce')

  # in shiny server hide the plot with a 'fold' effect
  jqui_hide('#foo', 'fold')

  # in shiny server show the plot with a 'blind' effect
  jqui_show('#foo', 'blind')
}
}
