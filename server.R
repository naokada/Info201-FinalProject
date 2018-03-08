source("set.R")

server <- function(input, output) {
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>% # Add default OpenStreetMap map tiles
      setView(lng = -122.304010391235, lat = 47.6500093694438, zoom = 15) # UW lock
  })
  
  click <- reactive({
    return(input$map_click)
  })
  
  observeEvent(input$map_click, {
    click <- input$map_click
    text<-paste("Lattitude ", click$lat, "<br>Longtitude ", click$lng)
    
    leafletProxy("map") %>% clearPopups() %>% clearMarkers() %>%
      addMarkers(lng =  click$lng, lat =  click$lat, icon = orange.leaf.icons)
  })
  
  # get the JSON result from the API
  data <- reactive({
    
    lat <- 47.6500093694438
    lng <- -122.304010391235
    if(!is.null(click())){
      lat <- click()$lat
      lng <- click()$lng
    }
    base <- paste0(base.url, "nearbysearch/json?")
    resource <- list(key = google.api.key, location = paste0(lat, ",", lng), 
                     type = input$type, radius = 1000, name = input$name)
    body <- GET(base, query = resource)
    search <- fromJSON(content(body, "text"))
    search
  })
  
  
  place.id <- reactive({
    place.id <- data()$results$place_id[input$place.id.number]
    
    return(place.id)
  })
  
  place.details <- reactive({
    
    resource <- paste0(base.url, "details/json?")
    parameters <- list(key = google.api.key, placeid = place.id())
    body <- GET(resource, query = parameters)
    place.details <- fromJSON(content(body, "text"))
    
    return(place.details)
    
  })
  
  pic.url <- reactive({
    
    photo.reference <- place.details()$result$photos$photo_reference[input$place.id.number]
    resource <- paste0(base.url, "photo?")
    parameters <- list(maxwidth = 500, maxheight = 400,photoreference=photo.reference, key = google.api.key, placeid = place.id())
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
  

  
  output$image <- renderText({
    c('<img src="', pic.url(),'">')
  })
  
  
  output$table <- renderTable({
    basic.info()
  })
  
  output$reviews <- renderTable({
    place.reviews()
  })
  
  
  # Print the distance and direction of the first thing in the relevent search results
  output$direction <- renderText({
    lat <- 47.6500093694438
    lng <- -122.304010391235
    if(!is.null(click())){
      lat <- click()$lat
      lng <- click()$lng
    }
    base <- paste0(base.url, "details/json?")
    # get the first relevent place
    resource <- list(key = google.api.key, placeid = data()$results$place_id[input$place.id.number])
    body <- GET(base, query = resource)
    final <- fromJSON(content(body, "text"))
    # get shop's lat and long
    loc.shop <- c(final$result$geometry$location$lat, final$result$geometry$location$lng)
    # calculate distance
    dist <- distm(c(loc.shop[2], loc.shop[1]), c(lng, lat), fun = distHaversine) *
            0.000621
    # calculate difference in position
    dlat <- loc.shop[1] - lat
    dlong <- loc.shop[2] - lng
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
           " degrees from ", di)
  })
  
  output$map2 <- renderLeaflet({
    
    
    name <-  data()$result$name
    place.id <- data()$result$place_id
    lat <- data()$result$geometry$location$lat
    lng <- data()$result$geometry$location$lng
    
    marks <- data.frame(name, place.id, lat, lng) %>%
      mutate(info = paste0("<h3>", name, "</h3>"))
    
    map2 <- leaflet(marks) %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=~lng, lat=~lat, popup=~info)
    
    
    
  })
  
output$info <- renderText({
  "Since"
})


}