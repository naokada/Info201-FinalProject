server <- function(input, output) {
  data <- reactive({
    base <- "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    resource <- list(key = my.key, location = paste0(input$lat, ", ", input$long), 
                     radius = 1000, name = input$name)
    body <- GET(base, query = resource)
    search <- fromJSON(content(body, "text"))
    search
  })
  
  output$places <- renderPrint({
    print(data()$results$name)
  })
  
  output$direction <- renderText({
    base <- "https://maps.googleapis.com/maps/api/place/details/json?"
    resource <- list(key = my.key, placeid = data()$results$place_id[1])
    body <- GET(base, query = resource)
    final <- fromJSON(content(body, "text"))
    loc.shop <- c(final$result$geometry$location$lat, final$result$geometry$location$lng)
    dist <- distm(c(loc.shop[2], loc.shop[1]), c(input$long, input$lat), fun = distHaversine) *
            0.000621
    dlat <- loc.shop[1] - input$lat
    dlong <- loc.shop[2] - input$long
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
    angle <- atan2(abs(dlat), abs(dlong)) / pi * 180 
    paste0("The distance is ", round(dist, 3), " miles, and ", round(angle, 2), 
           " degrees from ", di, ".")
  })
  
}