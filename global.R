# Function to create the capacity plot
capacityPlot <- function(){
  # Exclude rows with NA in ReactorType
  df <- na.omit(df)
  
  # Define colors
  bar_color <- "#66C5CC"  # rgb(102, 197, 204)
  background_color <- "#FCF8F4"  # rgba(252,248,244,1.00)
  
  # Create the capacity plot using ggplot2
  Capacity <- ggplot(df, aes(x = Capacity)) +
    geom_histogram(fill = bar_color, color = "black", binwidth = 30) +
    labs(
      x = "Capacity",
      y = "Frequency") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
          panel.background = element_rect(fill = background_color),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = element_line(color = "black"),
          axis.text = element_text(color = "black"))
  
  return(Capacity)
}

# Function to create the reactor map
createReactorMap <- function(df, selectedYear) {
  # Filter out rows with incomplete data in OperationalFrom_Year
  df_map <- df[complete.cases(df$OperationalFrom_Year), ]
  
  # Define color palette for reactor types
  color_palette <- alpha(hex(HLS(seq(120, 400, length.out = 11), seq(0.40, 0.70, length.out = 11), seq(0.8, 1, length.out = 11))), 1)
  reactor_color_mapping <- setNames(color_palette, unique(df_map$ReactorType))
  df_map$Color <- reactor_color_mapping[df_map$ReactorType]
  
  # Filter data based on selected year
  df_map <- df_map[df_map$OperationalFrom_Year <= selectedYear, ] 
  df_map <- df_map[(is.na(df_map$OperationalTo_Year) | df_map$OperationalTo_Year > selectedYear), ]
  
  # Create and return the leaflet map
  leaflet_map <- leaflet(df_map) %>%
    addTiles() %>%
    addCircleMarkers(
      lat = ~Latitude,
      lng = ~Longitude,
      radius = 5,
      fillColor = ~Color,
      fillOpacity = 0.9,
      color = "#000000",
      weight = 1,
      popup = ~Name
    ) %>%
    addLegend(
      "bottomright",
      title = "Reactor Type",
      colors = unique(df_map$Color),
      labels = unique(df_map$ReactorType),
      opacity = 1
    )
  
  return(leaflet_map)
}

# Function to import and preprocess data
import <- function() {
  # Load necessary libraries
  library(ggplot2)
  library(dplyr)
  library(lubridate)
  library(shiny)
  library(leaflet)
  library(colorspace)
  library(scales)
  library(RColorBrewer)
  library(shinydashboard)
  library(shinydashboardPlus)
  
  # Read data from CSV file
  df <- read.csv('nuclear_power_plants.csv', sep = ';')
  
  # Convert ReactorType and Status to factors
  df$ReactorType <- as.factor(df$ReactorType)
  df$ReactorType <- trimws(df$ReactorType)
  df$Status <- as.factor(df$Status)
  
  # Create a new variable indicating whether the reactor is still operational
  df$isStillOperational <- ifelse(df$OperationalTo =='','OPERATING','DECOMMISSIONED')
  
  # Extract year information from date variables
  df$OperationalFrom_Date <- as.Date(df$OperationalFrom)
  df$OperationalFrom_Year <- year(df$OperationalFrom_Date)
  df$OperationalTo_Date <- as.Date(df$OperationalTo)
  df$OperationalTo_Year <- year(df$OperationalTo_Date)
  df$OperationalLife <- df$OperationalTo_Year - df$OperationalFrom_Year
  
  # Return the preprocessed dataframe
  return(df)
}

# Function to create the reactor type plot
reactorType <- function(){
  # Subset data to include only relevant reactor types
  df_rt <- df[!(is.na(df$ReactorType)), ]
  df_rt <- df_rt[!df_rt$ReactorType %in% c("", "ABWR", "APWR"), ]
  
  # Define colors
  bar_color <- "#66C5CC"  # rgb(102, 197, 204)
  background_color <- "#FCF8F4"  # rgba(252,248,244,1.00)
  
  # Create the reactor type plot using ggplot2
  ReactorType <- ggplot(df_rt, aes(x = ReactorType, fill = ReactorType)) +
    geom_bar() + 
    labs(
      x = "Reactor Type",
      y = "Frequency") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
          panel.background = element_rect(fill = background_color),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = element_line(color = "black"),
          axis.text = element_text(color = "black")) +
    scale_fill_manual(values = rep(bar_color, length(unique(df_rt$ReactorType))))  # Set bar color
  
  return(ReactorType)
}

# Import data at the beginning
df <- import()
