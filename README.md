# Data Dive into Game of Thrones
This repository contains the source code for an interactive _Shiny_ dashboard that allows users to explore _Game of Thrones_ locations and houses on a _Leaflet_ map. The application connects to a _PostgreSQL_ database for retrieving geographic data.

## Getting Started
### Prerequisites
Before running the _Shiny_ app, you need the following:
 
- _R_ installed on your system
- The following _R_ libraries: `shiny`, `leaflet`, `RPostgres`, `sf`, `dotenv`
- _PostgreSQL_ database with the necessary credentials

### Setup
1. **Clone the repository:**

    First, clone the repository to your local machine:

    ```bash
    git clone git@github.com:tungufoss/Game-of-Thrones.git
    cd Game-of-Thrones
    ```
2. **Environment Variables:** 

    In the `R/` directory of this repository, create a `.env` file with your PostgreSQL 
   connection details. The app requires this file to securely connect to the database.
    
    Example `.env` file:
    ```bash
    PGHOST=your_postgresql_host
    PGPORT=your_postgresql_port
    PGDATABASE=your_postgresql_database
    PGUSER=your_postgresql_username
    PGPASSWORD=your_postgresql_password
    ```
    Replace the placeholders with your actual PostgreSQL credentials.

3. **Install Required R Packages:**

    Ensure that all necessary R packages are installed:

    ```R
    install.packages(c("tidyverse", "RPostgres", "dotenv", "shiny", "leaflet", "sf", 
   "shinydashboard", "kinship2"))
    ```

### Running the Application
1. **Navigate to the project directory:**

    After cloning the repository, navigate to the `R/` directory where the Shiny app is located 
   along with the `.env` file:

    ``` bash
    cd R/
    ```
2. **Run the Shiny Application:**

    To run the Shiny application, execute the following command in your terminal:

    ```bash
    Rscript -e "shiny::runApp('.', port = 8080)"
    ```
    This will start the Shiny app on port 8080. 
    You can access it in your web browser at http://localhost:8080.

## Folder Structure
The following is the expected folder structure for the project:

```plaintext 
Game-of-Thrones/
│
├── R/                            # Directory containing the Shiny app code
│   ├── .env                      # Environment file for PostgreSQL credentials (not included in the repository)
│   ├── ui.R                      # Shiny UI definition
│   ├── server.R                  # Shiny server logic
│   ├── global.R                  # Global definitions for database connections
│   ├── server_leaflet.R          # Server logic for the first tab (interactive map)
│   └── server_source.R           # Server logic for the second tab (sources and licensing)
│
├── www/                          # Static assets (e.g., custom CSS, images)
│   └── custom.css                # Custom CSS for styling the app
│
└── README.md                     # Project documentation (this file)
```

## Features
- **Interactive Leaflet Map**: Explore the world of _Game of Thrones_, with markers for important 
locations and houses.
- **Filtering Options**: Filter displayed locations by kingdom and type (e.g., castles, cities, towns).
- **Information Pane**: Detailed information about the selected house or location is shown in the 
  right pane.
- **Data Source**: The app uses a _PostgreSQL_ database to retrieve geographic data about the locations 
  and houses.

## Sources and Licensing
This project is open source under the Creative Commons license.

Data sources used in the project:

- [Atlas Of Thrones: A Game of Thrones Interactive Map by Patrick Triest](https://github.com/triestpa/Atlas-Of-Thrones)
- [An API of Ice And Fire by Joakim Skoog](https://anapioficeandfire.com/)

