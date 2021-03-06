#' Interactive 'd3.js' Parallel Coordinates Chart
#'
#' Create interactive parallel coordinates charts with this htmlwidget
#' wrapper for d3.js \href{https://github.com/bigfatdog/parcoords-es}{parallel-coordinates}.
#'
#' @param data  data.frame with data to use in the chart
#' @param rownames logical use rownames from the data.frame in the chart.  Regardless of
#'          this parameter, we will append rownames to the data that we send to JavaScript.
#'          If \code{rownames} equals \code{FALSE}, then we will use parallel coordinates
#'          to hide it.
#' @param color Color can be a single color as rgb or hex.  For a color function,
#'          provide a
#'          \code{list( colorScale = , colorBy = , colorScheme =, colorInterpolator = , colorDomain =)}
#'          where colorScale is the name of the
#'          \href{https://github.com/d3/d3-scale/blob/master/README.md#sequential-scales}{d3-scale} such as
#'          \code{scaleOrdinal} or \code{scaleSequential},
#'          colorBy with the column name from the data to determine color.  If appplying color to a
#'          discrete or ordinal variable then please also supply colorScheme, such as
#'          \code{schemCategory10}.  If applying color
#'          to a continuous variable then please also supply colorInterpolator
#'          with colorInterpolator as the name of the \href{https://github.com/d3/d3-scale/blob/master/README.md#sequential_interpolator}{d3 interpolator},
#'          such as \code{interpolateViridis}. If using a \code{d3}
#'          color scale, then make sure to use the argument \code{withD3 = TRUE}.
#' @param brushMode string, either \code{"1D-axes"}, \code{"1D-axes-multi"},
#'          or \code{"2D-strums"}
#'          giving the type of desired brush behavior for the chart.
#' @param brushPredicate string, either \code{"and"} or \code{"or"} giving
#'          the logic forthe join with multiple brushes.
#' @param alphaOnBrushed opacity from 0 to 1 when brushed (default to 0).
#' @param reorderable logical enable reordering of axes
#' @param axisDots logical mark the points where polylines meet an axis with dots
#' @param margin list of sizes of margins in pixels.  Currently
#'          \code{brushMode = "2D-strums"} requires left margin = 0, so
#'          this will change automatically and might result in unexpected
#'          behavior.
#' @param composite foreground context's composite type
#' @param alpha opacity from 0 to 1 of the polylines
#' @param queue logical (default FALSE) to change rendering mode to queue for
#'          progressive rendering.  Usually \code{ queue = T } for very large datasets.
#' @param mode string see\code{queue} above; \code{ queue = T } will set
#'          \code{ mode = "queue" }
#' @param rate integer rate at which render will queue
#' @param dimensions \code{list} to customize axes dimensions
#' @param bundleDimension character string for the column or variable on which to bundle
#' @param bundlingStrength numeric value between 0 and 1 for the strength of the bundling.  This value will
#'          not affect the parallel coordinates if \code{bundleDimension} is not set and will be ignored.
#' @param smoothness numeric value between between 0 and 1 for stength of smoothing or curvature.    This value will
#'          not affect the parallel coordinates if \code{bundleDimension} is not set and will be ignored.
#' @param tasks a character string or \code{\link[htmlwidgets]{JS}} or list of
#'          strings or \code{JS} representing a JavaScript function(s) to run
#'          after the \code{parcoords} has rendered.  These provide an opportunity
#'          for advanced customization.  Note, the \code{function} will use the
#'          JavaScript \code{call} mechanism, so within the function, \code{this} will
#'          be an object with {this.el} representing the containing element of the
#'          \code{parcoords} and {this.parcoords} representing the \code{parcoords}
#'          instance.
#' @param autoresize logical (default FALSE) to auto resize the parcoords
#'          when the size of the container changes.  This is useful
#'          in contexts such as rmarkdown slide presentations or
#'          flexdashboard.  However, this will not be useful if you
#'          expect bigger data or a more typical html context.
#' @param withD3 \code{logical} to include d3 dependency from \code{d3r}. The 'parcoords'
#'          htmlwidget uses a standalone JavaScript build and will
#'          not include the entire d3 in the global/window namespace.  To include
#'          d3.js in this way, use \code{withD3=TRUE}.
#' @param width integer in pixels defining the width of the widget.  Autosizing  to 100%
#'          of the widget container will occur if \code{ width = NULL }.
#' @param height integer in pixels defining the height of the widget.  Autosizing to 400px
#'          of the widget container will occur if \code{ height = NULL }.
#' @param elementId unique \code{CSS} selector id for the widget.
#'
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents,
#' and within Shiny output bindings.
#' @examples
#' if(interactive()) {
#'   # simple example using the mtcars dataset
#'   data( mtcars )
#'   parcoords( mtcars )
#'
#'   # various ways to change color
#'   #   in these all lines are the specified color
#'   parcoords( mtcars, color = "green" )
#'   parcoords( mtcars, color = "#f0c" )
#'   #   in these we supply a function for our color
#'   parcoords(
#'     mtcars
#'     , color = list(
#'        colorBy = "cyl"
#'        , colorScale = "scaleOrdinal"
#'        , colorScheme = "schemeCategory10"
#'     )
#'     , withD3 = TRUE
#'   )
#'
#'   if(require('ggplot2', quietly = TRUE)) {
#'   parcoords(
#'     diamonds
#'     ,rownames = FALSE
#'     ,brushMode = "1d-axes"
#'     ,reorderable = TRUE
#'     ,queue = TRUE
#'     ,color= list(
#'        colorBy="cut"
#'        , colorScale = "scaleOrdinal"
#'        , colorScheme = "schemeCategory10"
#'     )
#'     ,withD3 = TRUE
#'   )
#'   }
#' }
#' @example ./inst/examples/examples_dimensions.R
#'
#' @import htmlwidgets
#'
#' @export
parcoords <- function(
  data = NULL
  , rownames = TRUE
  , color = NULL
  , brushMode = NULL
  , brushPredicate = "and"
  , alphaOnBrushed = NULL
  , reorderable = FALSE
  , axisDots = NULL
  , margin = NULL
  , composite = NULL
  , alpha = NULL
  , queue = FALSE
  , mode = FALSE
  , rate = NULL
  , dimensions = NULL
  , bundleDimension = NULL
  , bundlingStrength = 0.5
  , smoothness = 0
  , tasks = NULL
  , autoresize = FALSE
  , withD3 = FALSE
  , width = NULL
  , height = NULL
  , elementId = NULL
) {

  crosstalk_opts <- NULL

  # convert data if SharedData and collect crosstalk options
  if (crosstalk::is.SharedData(data)) {
    crosstalk_opts <- list(
      group = data$groupName(),
      key = data$key()
    )
    data <- data$data(withKey = TRUE)
  }

  # verify that data is a data.frame
  if(!is.data.frame(data)) stop( "data parameter should be of type data.frame", call. = FALSE)

  # add rownames to data
  #  rownames = FALSE will tell us to hide these with JavaScript
  data <- data.frame(
    "names" = rownames(data)
    , data
    , stringsAsFactors = FALSE
    , check.names = FALSE
  )

  # check for valid brushMode
  #  should be either "1D-axes" or "2D-strums"
  if ( !is.null(brushMode) ) {
    if( grepl( x= brushMode, pattern = "2[dD](-)*([Ss]trum)*" ) ) {
      brushMode = "2D-strums"
    } else if( grepl( x= brushMode, pattern = "1[dD](-)*([Aa]x[ie]s)*" ) ||
               grepl( x= brushMode, pattern = "[mM](ult)" )
     ) {
      if( grepl( x= brushMode, pattern = "[mM](ult)" ) ) {
        brushMode = "1D-axes-multi" }
      else if( grepl( x= brushMode, pattern = "1[dD](-)*([Aa]x[ie]s)*" ) ) {
        brushMode = "1D-axes"
      }
    } else {
      warning( paste0("brushMode ", brushMode, " supplied is incorrect"), call. = F )
      brushMode = NULL
    }
  }

  # upper case brushPredicate
  brushPredicate = toupper( brushPredicate )

  # make margin an option, so will need to modifyList
  if( !is.null(margin) && !is.list(margin) ){
    warning("margin should be a list like margin = list(top=20); assuming margin should be applied for all sides")
    margin = list( top=margin, bottom=margin, left=margin, right = margin)
  }
  if( is.list(margin) ){
    margin =  utils::modifyList(list(top=50,bottom=50,left=100,right=50), margin )
  } else {
    margin = list(top=50,bottom=50,left=100,right=50)
  }

  # queue=T needs to be converted to render = "queue"
  if (!is.null(queue) && queue) mode = "queue"

  # verify bundling arguments and warn if not sensible
  addBundling <- !is.null(bundleDimension)
  #  check to see if bundleDimension is a valid column name
  if(addBundling && !(bundleDimension %in% colnames(data))) {
    warning(
      "bundleDimension is not a valid column name for the data provided.  Ignoring bundleDimension.",
      call. = FALSE
    )
    bundleDimension <- NULL
    addBundling = FALSE
  }
  if(!addBundling && smoothness != 0) {
    warning(
      "Smoothness specified not equal to 0 and bundleDimension not provided.  Ignoring smoothness argument.
      Please provide bundleDimension for smoothness to work correctly",
      call. = FALSE
    )
    smoothness <- 0
  }

  # convert character tasks to htmlwidgets::JS
  if ( !is.null(tasks) ){
    tasks = lapply(
      tasks,
      function(task){
        if(!inherits(task,"JS_EVAL")) task <- htmlwidgets::JS(task)
        task
      }
    )
  }

  # forward options using x
  x <- list(
    data = data,
    options = list(
      rownames = rownames
      , color = color
      , brushMode = brushMode
      , brushPredicate = brushPredicate
      , alphaOnBrushed = alphaOnBrushed
      , reorderable = reorderable
      , axisDots = axisDots
      , margin = margin
      , composite = composite
      , alpha = alpha
      , mode = mode
      , rate = rate
      , dimensions = dimensions
      , bundleDimension = bundleDimension
      , bundlingStrength = bundlingStrength
      , smoothness = smoothness
      , width = width
      , height = height
    )
    , autoresize = autoresize
    , tasks = tasks
  )

  # remove NULL options
  x$options = Filter( Negate(is.null), x$options )

  dep <- list()
  # include d3 if withD3 is TRUE
  if(withD3 == TRUE) {
    dep[[length(dep) + 1]] <- d3r::d3_dep_v5()
  }

  # include sylvester.js if bundling
  if(addBundling) {
    dep[[length(dep) + 1]] <- htmltools::htmlDependency(
      name = "sylvester",
      version = "0.1.3",
      src = system.file("htmlwidgets/lib/sylvester", package="parcoords"),
      script = "sylvester.js"
    )
  }


  # create widget
  pc <- htmlwidgets::createWidget(
    name = 'parcoords',
    x,
    width = width,
    height = height,
    package = 'parcoords',
    dependencies = dep,
    elementId = elementId
  )

  #  add crosstalk options and dependencies
  if(!is.null(crosstalk_opts)) {
    pc$x$crosstalk_opts <- crosstalk_opts
    pc$dependencies <- crosstalk::crosstalkLibs()
  }

  pc
}


#' Shiny bindings for 'parcoords'
#'
#' Output and render functions for using sunburst within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a sunburst
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()}). This
#'   is useful if you want to save an expression in a variable.
#'
#' @name parcoords-shiny
#'
#' @example inst/examples/examples_shiny.R
#'
#' @export
parcoordsOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'parcoords', width, height, package = 'parcoords')
}

#' @rdname parcoords-shiny
#'
#' @export
renderParcoords <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, parcoordsOutput, env, quoted = TRUE)
}

# custom function html so that we can contain width of the parcoords chart
parcoords_html <- function(name, package, id, style, class, ...) {
  htmltools::tags$div(
    id = id, style = style,
    style = "position:relative; overflow-x:auto; overflow-y:hidden; max-width:100%;",
    class = class, ...
  )
}
