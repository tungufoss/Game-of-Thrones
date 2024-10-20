# global.R
# Run in terminal:
# Rscript -e "shiny::runApp('~/dev/IDN302G/Game-of-Thrones/R/', port = 8080)"

# Load necessary libraries
library(tidyverse)
library(RPostgres)
library(sf)
library(leaflet)
library(dotenv)

# Load database credentials from the .env file
dotenv::load_dot_env(".env")

# Establish connection to PostgreSQL database
con <- dbConnect(RPostgres::Postgres(),
                 host = Sys.getenv("PGHOST"),
                 port = Sys.getenv("PGPORT"),
                 dbname = Sys.getenv("PGDATABASE"),
                 user = Sys.getenv("PGUSER"),
                 password = Sys.getenv("PGPASSWORD"))

# Default values for filtering
location_types <- c('Castle', 'Landmark', 'Region', 'City', 'Town', 'Ruin')
kingdoms <- c('The North', 'The Vale', 'Gift', 'The Riverlands', 'The Westerlands', 'Dorne',
              'The Reach', 'The Stormlands', 'Iron Islands', 'The Crownsland', 'Outside Westeros')


# Query for location data
location_data <- dbGetQuery(con, "SELECT * FROM shiny.locations") %>%
  # Convert Well-Known Text (WKT) format to sf spatial object with WGS 84 coordinate reference system (CRS)
  st_as_sf(wkt = "geom_wkt", crs = 4326)  # EPSG 4326 represents WGS 84, the most common GPS system

# Query for kingdom data
kingdom_data <- dbGetQuery(con, "SELECT * FROM shiny.kingdoms") %>%
  st_as_sf(wkt = "geom_wkt", crs = 4326)

# Query for house data
house_data <- dbGetQuery(con, "SELECT * FROM shiny.houses") %>%
  st_as_sf(wkt = "geom_wkt", crs = 4326)

# Create custom icons for each house
house_icons <- icons(
  iconUrl = ~coat_of_arms_url,  # URL for the custom icon
  iconWidth = 50,               # Set the width of the marker icon
  iconHeight = 50,              # Set the height of the marker icon
  iconAnchorX = 25,             # Anchor point of the icon (centered horizontally)
  iconAnchorY = 60             # Anchor point of the icon (bottom of the image)
)

# Create dynamic icons based on the type of location
location_icons <- icons(
  iconUrl = ~icon_url,        # URL for the custom icon
  iconWidth = 20,             # Set the width of the marker icon
  iconHeight = 20,            # Set the height of the marker icon
  iconAnchorX = 10,           # Anchor point of the icon (centered horizontally)
  iconAnchorY = 10            # Anchor point of the icon (bottom of the image)
)
