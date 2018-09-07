library(readr)
library(leaflet)
library(shiny)
library(shinydashboard)
library(ggmap) # for geocoding addresses
library(RANN) # for fast nearest neighbor distances
library(htmltools)

# read in data
c <- read_rds("centroids.rds")

c@data$gmap_url <- paste0("<a href = 'https://www.google.com/maps/search/",
                     # c@coords[, 2], ",+",
                     # c@coords[, 1], "'''",
                     c$addr_line0, " ",
                     "CA ",
                     c$address_zi,"/'",
                     "> Google Maps Directions</a>")




