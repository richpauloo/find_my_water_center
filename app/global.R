library(readr)
library(leaflet)
library(shiny)
library(shinydashboard)
library(ggmap) # for geocoding addresses
library(RANN) # for fast nearest neighbor distances

# read in data
c <- read_rds("centroids.rds")

#p <- read_rds("polygons_simp.rds")


