library(shiny)
library(shinydashboard)
library(leaflet)

# Define UI for Atlas of Thrones dashboard
dashboardPage(
  dashboardHeader(title = "Game of Thrones"),  # Title of the dashboard

  dashboardSidebar(
    sidebarMenu(
      menuItem("Info Map", tabName = "info_map", icon = icon("map")),
      menuItem("Pedigree Tree", tabName = "pedigree", icon = icon("tree")),
      menuItem("Sources & Licensing", tabName = "sources", icon = icon("book"))
    )
  ),

  dashboardBody(
    # Include the external CSS file
    includeCSS("www/custom.css"),  # Reference your custom CSS file

    # Define tabs for the dashboard content
    tabItems(
      # First tab: Interactive Map (Game of Atlas)
      tabItem(tabName = "info_map",
              fluidRow(
                column(width = 3,
                       # Filtering options
                       h2("Filtering"),

                       checkboxGroupInput(
                         "kingdoms", "Select Kingdoms:",
                         choices = kingdoms, selected = kingdoms,
                         inline = TRUE  # Display inline (in a single row)
                       ),

                       checkboxGroupInput(
                         "location_types", "Select Location Type:",
                         choices = location_types, selected = location_types,
                         inline = TRUE
                       ),

                       # Add a white line separator
                       tags$hr(style = "border-top: 1px solid white;"),  # Horizontal white line

                       # Info pane
                       h2("Information"),
                       htmlOutput("popup_info")  # Placeholder for dynamic HTML popup info
                ),
                column(width = 9,
                       leafletOutput("map", width = "100%", height = "600pt")
                )
              )
      ),

      # Second tab: Pedigree Tree
      tabItem(tabName = "pedigree",
              h2("Game of Thrones Pedigree Tree"),
              selectInput(
                inputId = "dynasty",                      # The input ID to refer to in the server logic
                label = "Select Dynasty",                 # The label for the dropdown
                choices = c(
                  "(All Dynasties)" = 0,                  # Default option to show all dynasties
                  "Stark" = 1,
                  "Targaryen" = 2,
                  "Baratheon" = 3,
                  "Lannister" = 4,
                  "Greyjoy" = 5,
                  "Martell" = 6,
                  "Tyrell" = 7,
                  "Westerling" = 8,
                  "Velaryon" = 9,
                  "Spicer" = 10,
                  "Frey" = 11,
                  "Hoare" = 12,
                  "Seaworth" = 13,
                  "Mudd" = 14,
                  "Gardener" = 15
                ),
                selected = 0,                             # Default selection (Stark)
                multiple = FALSE                          # Single selection only
              ),
              plotOutput("family_tree_plot")  # Placeholder for the family tree plot
      ),

      # Third tab: Sources and Licensing
      tabItem(tabName = "sources",
              h2("Sources & Licensing"),
              htmlOutput("sources_info")  # Placeholder for dynamically generated HTML
      )
    )
  )
)
