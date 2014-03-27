# Startup R script for the trailer shiny app
####11
###############################################################################
# clean data
rm(list=ls())
# set working dir
frame_files <- lapply(sys.frames(), function(x) x$ofile)
frame_files <- Filter(Negate(is.null), frame_files)
PATH <- dirname(frame_files[[length(frame_files)]])
setwd(paste(PATH, "/uk/ac/bolton/trailer-analytics/view/", sep=""))
# get shiny..
library(shiny)
# start the shiny app
runApp()
###2
