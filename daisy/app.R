library("shiny")
source("ui.R")
source("server.R")
library("rsconnect")

shinyApp(ui = my.ui, server = my.server)