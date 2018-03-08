source("set.R")

ui <- dashboardPage(skin = "purple", 
                    dashboardHeader(title = "Place Lo-okup"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Interact Map", tabName = "mapTab", icon = icon("binoculars")),
                        menuItem("About the App", tabName = "dataTab", icon = icon("book"))
                      )
                    ),
                    dashboardBody(
                      includeCSS("outline.css"),
                      tabItems(
                        # First tab content
                        tabItem(tabName = "mapTab",
                                h2("Interactive Map", style="color:#306800"),
                                sidebarLayout (
                                   sidebarPanel( 
                                    flowLayout(
                                      
                                        textInput("name", label = "Search for name:", value = ""),
                                        
                                   
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
                                      such as Eiffel Tower or Statue of Liberty")
                                    
                                  
                                  
                                ), style='width: 240px'),  
                                
                                mainPanel(
                                  tabsetPanel(type="tabs",
                                              tabPanel(("map1"),leafletOutput("map")),
                                              tabPanel(("map2"),leafletOutput("map2"))),
                                  conditionalPanel(
                                    p("Direction and distance:"),
                                    textOutput("direction"),
                                    condition = "input.place != '' | input.region != ''",
                                    br(),br(),
                                    htmlOutput("image"),
                                    br(),
                                    tableOutput("table"),
                                    tableOutput("reviews")
                                  )
                                )
      
                        )),
                        
                        # Second tab content
                        tabItem(tabName = "dataTab",
                                fluidRow(
                                  includeHTML("Place lookup.html")
                                 #verbatimTextOutput("info")
                                )
                        )
                        )
    )
)