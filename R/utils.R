.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler('shinyjqui.df', function(data, shinysession, name) {
    data <- lapply(data, function(x){
      `if`(length(x)==0, NA_character_, unlist(x))
    })
    data.frame(data, stringsAsFactors = FALSE)
  }, force = TRUE)
}


## Code obtained from
## http://deanattali.com/blog/htmlwidgets-tips/#widget-to-r-data
## with some midifications.
sendMsg <- function() {
  message <- Filter(function(x) !is.symbol(x), as.list(parent.frame(1)))
  # record locations of JS codes needed to be evaled in javascript side
  message <- c(message, list(.evals = JSEvals(message)))
  session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage('shinyjqui', message)
}

randomChars <- function() {
  paste0(sample(c(letters, LETTERS, 0:9), size = 8, replace = TRUE), collapse = '')
}

uiInteract <- function(tag, func, options = NULL) {

  if(inherits(tag, 'shiny.tag.list')) {

    x <- lapply(tag, uiInteract, func = func, options = options)
    # set the original attributes like class (shiny.tag.list) and
    # html_dependencies (for htmlwidgets) back
    attributes(x) <- attributes(tag)
    return(x)

  } else if(inherits(tag, 'shiny.tag')) {

    id <- tag$attribs$id
    if(!is.null(id)) {
      selector <- paste0('#', id)
    } else {
      class <- sprintf('jqui-interaction-%s', randomChars())
      tag <- shiny::tagAppendAttributes(tag, class = class)
      selector <- paste0('.', class)
    }

    msg <- list(selector = selector,
                method = 'interaction',
                func = func,
                switch = TRUE,
                options = options)
    msg <- c(msg, list(.evals = JSEvals(msg)))

    interaction_call <- sprintf('shinyjqui.msgCallback(%s);',
                                jsonlite::toJSON(msg, auto_unbox = TRUE, force = TRUE))

    if(!is.null(tag$attribs$class) &&
       grepl('html-widget-output|shiny-.+?-output', tag$attribs$class)) {
      # For shiny/htmlwidgets output elements, call resizable on "shiny:value"
      # event. This ensures js get the correct element dimension especially when
      # the output element is hiden on shiny initialization.
      js <- sprintf('$("%s").on("shiny:value", function(e){console.log(e.target); %s});',
                    selector, interaction_call)

    } else {
      # Wait for a while so that shiny initialized. This ensures the
      # Shiny.onInputChange works and all the shiny inputs have class
      # shiny-bound-input and all the shiny outputs have class
      # shiny-bound-output.
      js <- sprintf('setTimeout(function(){%s}, 10);',
                    interaction_call)

    }

    # run js on document ready
    js <- sprintf('$(function(){%s});', js)

    shiny::tagList(
      shiny::singleton(
        shiny::tags$head(
          shiny::tags$script(js)
        )
      ),
      tag
    )
  } else {

    warning('The tag provided is not a shiny tag. Action abort.')
    return(tag)

  }

}



