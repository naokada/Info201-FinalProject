library("shiny")
library("leaflet")
library("shinydashboard")


ui <- dashboardPage(skin = "purple",
  dashboardHeader(title = "Place Lo-okup"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Interact Map", tabName = "map", icon = icon("binoculars")),
      menuItem("Data touch", tabName = "data", icon = icon("book"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "map",
              h2("Interactive Map"),
              leafletOutput("map")
      ),
      
      # Second tab content
      tabItem(tabName = "data",
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
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
  })
  
  
  
}

shinyApp(ui = ui, server = server)

