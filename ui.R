ui <- fluidPage (
  mainPanel(
    numericInput("lat", label = "Enter Latitude:", value = 0),
    numericInput("long", label = "Enter Longitude:", value = 0),
    textInput("name", label = "Search for name:", value = ""),
    p("Relevent places:"),
    verbatimTextOutput("places"),
    p("Here is the direction and distance:"),
    textOutput("direction")
  )
)
