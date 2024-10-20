# server.R

library(shiny)
library(htmlwidgets)

# Define server logic
shinyServer(function(input, output, session) {

  # Source the server logic for each tab
  source("server_leaflet.R", local = TRUE)  # Logic for the "Game of Atlas" tab
  source("server_source.R", local = TRUE)  # Logic for the "Sources & Licensing" tab

  # You can source more files for additional tabs if needed
})


