# server.R

library(shiny)

# Define server logic
shinyServer(function(input, output, session) {

  # Source the server logic for each tab
  source("server_leaflet.R", local = TRUE)  # Logic for the "Game of Atlas" tab
  source("server_source.R", local = TRUE)  # Logic for the "Sources & Licensing" tab
  source("server_pedigree.R", local = TRUE)  # Logic for the "Pedigree Tree" tab

  # You can source more files for additional tabs if needed
})


