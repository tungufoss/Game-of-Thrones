# Server logic for the Game of Thrones Leaflet map

# Render the initial Leaflet map
output$map <- renderLeaflet({
  leaflet() %>%
    addTiles(
      urlTemplate = 'https://cartocdn-gusc.global.ssl.fastly.net//ramirocartodb/api/v1/map/named/tpl_756aec63_3adb_48b6_9d14_331c6cbc47cf/all/{z}/{x}/{y}.png'
    ) %>%
    # Set the initial view of the map to King's Landing and zoom level
    setView(lng = 19, lat = 4, zoom = 6) %>%
    # Add layer control to toggle between layers
    addLayersControl(
      overlayGroups = c("Kingdoms", "Locations", "Houses"),
      options = layersControlOptions(collapsed = FALSE)
    )
})

# Observe changes to the selected location types and update markers on the map
observe({
  # Filtered kingdoms based on the selected values
  filtered_kingdoms <- kingdom_data %>%
    filter(kingdom_name %in% input$kingdoms)

  # Filter location_data based on the selected values
  filtered_locations <- location_data %>%
    filter(location_type %in% input$location_types) %>%
    filter(kingdom_name %in% input$kingdoms)

  # Filter house_data based on the selected values
  filtered_houses <- house_data %>%
    filter(kingdom_name %in% input$kingdoms)

  # Use leafletProxy to update the map
  leafletProxy("map") %>%
    clearMarkers() %>%   # Clear existing markers
    clearShapes()  # Clear existing polygons

  # Only add kingdom polygons if filtered_kingdoms is not empty
  if (nrow(filtered_kingdoms) > 0) {
    leafletProxy("map") %>%
      addPolygons(
        data = filtered_kingdoms,
        group = "Kingdoms",                           # Group kingdoms for layer control
        fillColor = ~color,                           # Color each kingdom polygon differently
        weight = 2,                                   # Line thickness for the polygon boundary
        opacity = 1,                                  # Line opacity
        color = "black",                              # Border color of polygons
        dashArray = "3",                              # Dashed line style for the borders
        fillOpacity = 0.3,                            # Opacity of the polygon fill color
        layerId = ~kingdom_name,                      # Use kingdom name as the layer ID
        highlightOptions = highlightOptions(          # Highlight options when hovering over the polygon
          weight = 3,
          color = "#666",
          fillOpacity = 0.7,
          bringToFront = TRUE
        )
      )
  }

  # Only add house markers if house_data is not empty
  if (nrow(filtered_houses) > 0) {
    leafletProxy("map") %>%
      addMarkers(
        data = filtered_houses,
        group = "Houses",                     # Group houses for layer control
        lng = ~st_coordinates(geom_wkt)[, 1], # Longitude from spatial data
        lat = ~st_coordinates(geom_wkt)[, 2], # Latitude from spatial data
        layerId = ~house_name,                # Use house_name as the marker ID
        icon = house_icons                    # Use the custom icons created
      )
  }

  # Only add markers if filtered_locations is not empty
  if (nrow(filtered_locations) > 0) {
    leafletProxy("map") %>%
      addMarkers(
        data = filtered_locations,
        group = "Locations",                  # Group locations for layer control
        lng = ~st_coordinates(geom_wkt)[, 1], # Longitude from spatial data
        lat = ~st_coordinates(geom_wkt)[, 2], # Latitude from spatial data
        layerId = ~location_name,             # Use location_name as the marker ID
        icon = location_icons                 # Use the custom icons created
      )
  }
})

# Observe marker click events (houses and locations)
observeEvent(input$map_marker_click, {
  click <- input$map_marker_click  # Get clicked marker info

  # Check if a valid click has been made
  if (!is.null(click$id)) {
    # First, try to match the click with house_data
    selected_house <- house_data %>% filter(house_name == click$id)

    if (nrow(selected_house) > 0) {
      # If a house was clicked, display house info
      output$popup_info <- renderUI({
        HTML(selected_house$house_info)
      })
    } else {
      # If no house was clicked, check if it matches location_data
      selected_location <- location_data %>% filter(location_name == click$id)

      if (nrow(selected_location) > 0) {
        # Display location info if a location marker was clicked
        output$popup_info <- renderUI({
          HTML(selected_location$location_info)
        })
      }
    }
  }
})

# Observe polygon (kingdom) click events using map_shape_click
observeEvent(input$map_shape_click, {
  click <- input$map_shape_click  # Get clicked polygon info

  # Check if a valid click has been made
  if (!is.null(click$id)) {
    # Match the click with kingdom_data
    selected_kingdom <- kingdom_data %>% filter(kingdom_name == click$id)

    if (nrow(selected_kingdom) > 0) {
      # Display kingdom info if a kingdom polygon was clicked
      output$popup_info <- renderUI({
        HTML(selected_kingdom$kingdom_info)
      })
    }
  }
})
