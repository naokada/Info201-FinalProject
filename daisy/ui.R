my.ui <- fluidPage(
  
  headerPanel("Check out the world!"),
  sidebarPanel(
    textInput("place", "position", placeholder = "format: latitude, longitude"),
    p("You need to input at least a position or a region for it to show information"),
    p("For example, you can try 47.658806, -122.313386, which is near UW"),
    p("Or you can try 40.689249, -74.0445, which is near the Statue of Liberty"),
    uiOutput("link"),
    br(),
    textInput("region", "region", placeholder = "for example: subway in Seattle, or US"),
    h5("Use the slider below to check out different places!"),
    sliderInput("place.id.number",
                "places in the database",
                value = 1,
                min = 1,
                max = 20
                ),
    br(),
    selectInput("type", 
                "types of the places", 
                c("library", "restaurant", "cafe", "cafe", "hospital",
                  "pharmacy", "bank", "atm")),
    p("It is not designed for exact search but for exploring in a global scale"),
    p("It is helpful if you want to know the surronding of any place in the world
      such as Eiffel Tower or Statue of Liberty"),
    br()
    
  ),
  
  conditionalPanel(
    
    condition = "input.place != '' | input.region != ''",
    
    htmlOutput("image"),
    br(),
    tableOutput("table"),
    tableOutput("reviews")
  )
  
)
shinyUI(my.ui)