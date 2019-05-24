## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(mtcars, height = 450)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  brushMode = '1D-axes', # "1D-axes", "1D-axes-multi", or "2D-strums" 
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  brushMode = '1D-axes',
  brushPredicate = "or", # "and" "or"
  alphaOnBrushed = 0.3,
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  color = "#3e3",
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  color = list(
    # discrete or categorical column
    colorScale = "scaleOrdinal",
    colorBy = "cyl",
    colorScheme = "schemeCategory10"
  ),
  withD3 = TRUE,
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  color = list(
    # continuous variable
    colorScale = "scaleSequential",
    colorBy = "mpg",
    colorInterpolator = "interpolateMagma"
  ),
  withD3 = TRUE,
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  bundleDimension = "cyl",
  bundlingStrength = 0.5,
  smoothness = 0.2,
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  brushMode = "1D-axes",
  queue = TRUE,
  rate = 2, # probably will be bigger (15 - 100) than this in real use
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

parcoords(
  mtcars,
  mode = "tiled",
  brushMode = "1D-axes",
  height = 500
)

## ------------------------------------------------------------------------
library(parcoords)

pc <- parcoords(
  data = mtcars,
  color = list(
    colorBy = "hp",
    colorScale = "scaleSequential"
  ),
  alpha = 0.5,
  brushMode = "1d",
  # requires withD3 for now but will change so this is not necessary
  #  after some iteration since this will pollute global namespace
  #  and potenially conflict with other htmlwidgets using a different version of d3
  withD3 = TRUE,
  elementId = "parcoords-snapshot-example"
)

htmltools::tagList(
  htmltools::tags$script(
"
function snapshotPC() {
  var pc = HTMLWidgets.find('#parcoords-snapshot-example').instance.parcoords;
  pc.snapshot();
}
"    
  ),
  htmltools::tags$button(
    "snapshot",
    onclick = "snapshotPC()"
  ),
  pc
)

