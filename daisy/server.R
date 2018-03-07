library("httr")
library("jsonlite")
library("dplyr")
source("googleKey.R")

my.server <- function(input, output) {
  
  base <- "https://maps.googleapis.com/maps/api/place/"
  
  place.id <- reactive({
    
    resource <- paste0(base, "textsearch/json?")
    parameters <- list(key = google.api.key, query = input$region, 
                       type = input$type, location = input$place, radius = 600)
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
    
  output$link <- renderUI({
     tagList("Use this to search for latitude and longitude for a place:", url)
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
  
}
shinyServer(my.server)