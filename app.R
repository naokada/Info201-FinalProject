library("shiny")
library("leaflet")
library("shinydashboard")


ui <- dashboardPage(skin = "purple",
  dashboardHeader(title = "Place Lo-okup"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Interact Map", tabName = "mapTab", icon = icon("binoculars")),
      menuItem("Data touch", tabName = "dataTab", icon = icon("book"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "mapTab",
              h2("Interactive Map"),
              leafletOutput("map")
      ),
      
      # Second tab content
      tabItem(tabName = "dataTab",
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      )
    )
  )
)


server <- function(input, output){
  
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

shinyApp(ui = ui, server = server)

