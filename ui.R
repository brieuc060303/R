# Define styles for the dashboard
body <- dashboardBody(
  tags$style(HTML("  
  
      .skin-blue .content-wrapper {
        background-color: #00141F; /* Darker navy */
      }
      
      .skin-blue .main-header .logo {
        background-color: #005C8E; / Darker blue /
      }

      .skin-blue .main-header .navbar {
        background-color: #005C8E; / Darker blue /
      }

      .skin-blue .main-header .navbar .nav > li > a {
        color: #ffffff; / White /
      }

      .skin-blue .main-header .navbar .nav > li > a:hover {
        background: #005C8E; / Darker blue /
        color: #ffffff; / White /
      }

      .skin-blue .main-header .navbar .sidebar-toggle {
        color: #ffffff; / White /
      }

      .skin-blue .main-header .navbar .sidebar-toggle:hover {
        background: #005C8E; / Darker blue /
        color: #ffffff; / White */
      }
    ")),#css style to change the dashboard style
  tabItems(#several tabs for the different graphs
    tabItem(
      tabName = "tabCapacity",
      fluidRow(
        box(
          plotOutput("plotCapacity"),
          title = "Histogramme représentant la capacité des réacteurs dans le monde",
          width = 12
        )
      )
    ),
    tabItem(
      tabName = "tabReactor",
      fluidRow(
        box(
          plotOutput("plotReactor"),
          title = "Graphique en barre représentant les types de réacteurs dans le monde",
          width = 12
        )
      )
    ),
    tabItem(
      tabName = "operationalReactor",
      fluidRow(
        box(
          plotOutput("plotOperational"),
          title = "Graphique en barre représentant les réacteurs opérationnels dans le monde",
          width = 12
        )
      )
    ),
    tabItem(
      tabName = "mapReactor",
      fluidRow(
        tags$style(HTML("
          .irs-grid-text {
            color: white !important;
          }
          .skin-blue .control-label {
            color: #FFFFFF; /* white */
          }
          .glyphicon.glyphicon-play {
            color: #FFFFFF;  
            font-size: 24px;  
            margin-top: 5px;
          }
          .glyphicon.glyphicon-pause {
            color: white;  
            font-size: 20px;  
            margin-top: 5px;  
          }
        ")),
        column(8,  # Adjust the column width for the map
               box(
                 leafletOutput("reactorMap"),
                 title = "Carte dynamique montrant les réacteurs en activité dans le monde",
                 width = 12
               ),
            
               sliderInput("yearSlider", "Select a year", min = 1960, max = 2020, value = 1960, step = 5, sep = "", animate = TRUE)
        ),
        
        column(4,  # Adjust the column width for the checkbox
               box(
                 checkboxGroupInput("checkGroup", label = "Choisissez les types de reacteur",
                                    choices = list("Pressurized Heavy Water Reactor (PHWR)" = "PHWR", 
                                                   "Fast breeder reactors (FBR)" = "FBR", 
                                                   "Pressurized water reactor (PWR)" = "PWR", 
                                                   "Light Water Graphite Reactor" = "LWGR", 
                                                   "Boiling water reactor (BWR)" = "BWR", 
                                                   "Gas-cooled reactor (GCR)" = "GCR", 
                                                   "Heavy Water Gas Cooled Reactor (HWGCR)" = "HWGCR", 
                                                   "High-Temperature Gas-cooled Reactor (HTGR)" = "HTGR", 
                                                   "Heavy Water Light Water Reactor (HWLWR)" = "HWLWR", 
                                                   "Organic Cooled Reactor (OCR)" = "OCR", 
                                                   "Steam Generating Heavy Water Reactor (SGHWR)" = "SGHWR"),
                                    selected = c("PHWR","FBR","PWR","LWGR","BWR", "GCR", "HWGCR", "HTGR", "HWLWR","OCR", "SGHWR")
                 )
               )
        )
      )
    )
  )
)

# Define the sidebar menu
sideBar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Reactors' Capacity", tabName = "tabCapacity", icon = icon("bar-chart")),
    menuItem("Reactor Types", tabName = "tabReactor", icon = icon("bar-chart")),
    menuItem("Operational Reactors", tabName = "operationalReactor", icon = icon("bar-chart")),
    menuItem("Reactors' Map", tabName = "mapReactor", icon = icon("map"))
  )
)

# Define the header of the dashboard
head <- dashboardHeader(title = "Reactor power plant dashboard", titleWidth = 300)

# Combine UI components
ui <- dashboardPage(head, sideBar, body)