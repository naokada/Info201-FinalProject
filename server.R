#source("set.R")
server <- function(input, output) {
  
  click <- reactive({
    return(input$map_click)
    
  })
  
  base <- "https://maps.googleapis.com/maps/api/place/"
  
  place.id <- reactive({
    
    resource <- paste0(base, "textsearch/json?")
    parameters <- list(key = google.api.key, 
                       location = paste0(click()$lat,", ",click()$lng), radius = 600)
    body <- GET(resource, query = parameters)
    place <- fromJSON(content(body, "text"))
    
    place.id <- place$results$place_id[input$place.id.number]
    
    return(place.id)
  })
  
  place.details <- reactive({
    
    resource <- paste0(base, "details/json?")
    parameters <- list(key = google.api.key, placeid = place.id())
    body <- GET(resource, query = parameters)
    place.details <- fromJSON(content(body, "text"))
    
    return(place.details)
    
  })
  
  pic.url <- reactive({
    
    photo.reference <- place.details()$result$photos$photo_reference[1]
    resource <- paste0(base, "photo?maxwidth=500&maxheight=400&photoreference=", photo.reference, "&key=", google.api.key)
    parameters <- list(key = google.api.key, placeid = place.id())
    photo <- GET(resource, query = parameters)
    photo.url <- photo[["url"]]
    
    return (photo.url)
  })
  
  basic.info <- reactive({
    address <- place.details()$result$formatted_address
    phone <- place.details()$result$formatted_phone_number
    name <- place.details()$result$name
    if(is.null(address) | is.null(phone) | is.null(name)) {
      return("No results")
    } else {
      info <- data.frame(name, phone, address)
      return(info)
    }
  })
  
  place.reviews <- reactive({
    reviews<- place.details()$result$reviews
    author_name <- reviews$author_name
    rating <- reviews$rating
    text <- reviews$text
    review.data <- data.frame(author_name, rating, text)
    if(nrow(review.data) == 0) {
      return("No results")
    }
    return(review.data)
  })
  
  url <- a("Click me", href="https://www.latlong.net/")
  
 
  
  output$image <- renderText({
    c('<img src="', pic.url(),'">')
  })
  
  
  output$table <- renderTable({
    basic.info()
  })
  
  output$reviews <- renderTable({
    place.reviews()
  })
  
  # get the JSON result from the API
  data <- reactive({
    base <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    resource <- list(key = google.api.key, location = paste0(click()$lat, ", ", click()$long), 
                     radius = 1000, name = input$name)
    body <- GET(base, query = resource)
    search <- fromJSON(content(body, "text"))
    search
  })
  
  # Print the relevent places to the search word
  output$places <- renderPrint({
    print(data()$results$name)
  })
  
  # Print the distance and direction of the first thing in the relevent search results
  output$direction <- renderText({
    base <- "https://maps.googleapis.com/maps/api/place/details/json?"
    # get the first relevent place
    resource <- list(key = google.api.key, placeid = data()$results$place_id[1])
    body <- GET(base, query = resource)
    final <- fromJSON(content(body, "text"))
    # get shop's lat and long
    loc.shop <- c(final$result$geometry$location$lat, final$result$geometry$location$lng)
    # calculate distance
    dist <- distm( c(loc.shop[2], loc.shop[1]), c(click()$long, click()$lat), fun = distHaversine) *
            0.000621
    # calculate difference in position
    dlat <- loc.shop[1] - click()$lat
    dlong <- loc.shop[2] - click()$long
    # to determin what direction the angle changes from
    di <- "North"
    if (dlat < 0) {
      if (dlong < 0) {
        di <- "South"
      } else {
        di <- "East"
      }
    } else {
      if (dlong < 0) {
        di <- "West"
      }
    }
    # calculates the angle. (the angle goes clockwise)
    angle <- atan2(abs(dlat), abs(dlong)) / pi * 180 
    paste0("The distance is ", round(dist, 3), " miles, and ", round(angle, 2), 
           " degrees from ", di, ".")
  })
  
  leafIcons <- icons(
    iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
    iconWidth = 38, iconHeight = 95,
    iconAnchorX = 22, iconAnchorY = 94,
    shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    shadowWidth = 50, shadowHeight = 64,
    shadowAnchorX = 4, shadowAnchorY = 62
  )
  
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>% # Add default OpenStreetMap map tiles
      setView(lng = -122.304010391235, lat = 47.6500093694438, zoom = 15) # UW lock
  })
  
  observeEvent(input$map_click, {
    click <- input$map_click
    text<-paste("Lattitude ", click$lat, "Longtitude ", click$lng)
    
    leafletProxy("map") %>% clearPopups() %>% clearMarkers() %>%
      addMarkers(lng =  click$lng, lat =  click$lat, icon = leafIcons) %>%
      addPopups(click$lng, click$lat + click$lat * 0.00005, text)
  })
  
  
  
}

shinyServer(server)