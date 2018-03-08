library("httr")
library("jsonlite")
library("dplyr")
source("googleKey.R")
source("server.R")

base <- "https://maps.googleapis.com/maps/api/place/"
resource <- paste0(base, "nearbysearch/json?")
parameters <- list(key = google.api.key, location = "47.654966, -122.307910", radius = 1000)
body <- GET(resource, query = parameters)
place <- fromJSON(content(body, "text"))

place.id <- place$results$place_id[5]

resource <- paste0(base, "details/json?")
parameters <- list(key = google.api.key, placeid = place.id)
body <- GET(resource, query = parameters)
place.details <- fromJSON(content(body, "text"))
photo.reference <- place.details$result$photos$photo_reference[4]
print(output.obs)

resource <- paste0(base, "photo?maxwidth=400&photoreference=", photo.reference, "&key=", google.api.key)
photo <- GET(resource, query = parameters)
photo.url <- photo[["url"]]

