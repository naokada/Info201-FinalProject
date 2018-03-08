library("httr")
library("jsonlite")
library("dplyr")
library("shiny")
library("tidyr")
library("geosphere")
library("leaflet")
library("shinydashboard")

source("apikey.R")

# icons
red.leaf.icons <- icons(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-red.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

green.leaf.icons <- icons(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

orange.leaf.icons <- icons(
  iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-orange.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,
  shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)

base.url <- "https://maps.googleapis.com/maps/api/place/"
resource <- paste0(base.url, "nearbysearch/json?")
parameters <- list(key = google.api.key, location = "47.654966, -122.307910", radius = 1000)
body <- GET(resource, query = parameters)
place <- fromJSON(content(body, "text"))

place.id <- place$results$place_id[5]

resource <- paste0(base.url, "details/json?")
parameters <- list(key = google.api.key, placeid = place.id)
body <- GET(resource, query = parameters)
place.details <- fromJSON(content(body, "text"))
photo.reference <- place.details$result$photos$photo_reference[4]

resource <- paste0(base.url, "photo?maxwidth=400&photoreference=", photo.reference, "&key=", google.api.key)
photo <- GET(resource, query = parameters)
photo.url <- photo[["url"]]