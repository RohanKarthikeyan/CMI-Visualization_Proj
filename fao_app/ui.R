library(shiny)
library(plotly)

## Start UI for dashboard
## Home page / about tab:

about_page = fluidPage(
  includeCSS("www/about_us.css"),
  fluidRow(
    shiny::HTML("<br><br><center> 
                 <h1>Welcome to FAO Analysis!</h1>
                 <p> FAO Analysis is the only application that you,
                 as a researcher, need to get an accurate picture <br> of
                 land output and land use patterns anywhere in the world.
                 </p></center>"),
    style = "height:150px;"),
  br(),
  fluidRow(
    column(3),
    column(6,
           shiny::HTML("<h4><br>
                        How have gross production of key components
                        like, agriculture, crops, and livestock changed over time
                        across the world's nations?</h4>
                        <ul style=\"list-style-type: square\">
                        <li>Go to the <b>'Gross Production'</b>
                        tab to know more!</li>
                        </ul><br>")
    ),
    column(3)
    # column(4,
    #        img(src="land.jpg", height=280, align="centre")
    #        )
  ),
  fluidRow(
    column(3),
    column(6,
           shiny::HTML("<h4>How have land use patterns for agriculture and forestry
                        evolved in different parts of the world?</h4>
                        <ul style=\"list-style-type: square\">
                        <li>Visit the <b>'Land use'</b>
                        tab for more information!</li>
                        </ul>")
    ),
    column(3)
  )
)

about_tab = tabPanel(
  "Home",
  about_page)

## Gross production tab
pin_country = fluidRow(
  column(4,
         wellPanel(
           selectInput(inputId = "cpin_category",
                       label = "Choose a category:",
                       choices = c("Agriculture", "Crops", "Food",
                                   "Livestock", "Non-food")),
           selectizeInput(inputId = "countries",
                          label="Choose one or more countries:",
                          choices = c("Select here" = "", NULL),
                          multiple = TRUE)
         )
  ),
  column(8,
         plotlyOutput('pin_country')
  )
)

pin_regions = sidebarLayout(
  sidebarPanel(
    selectInput(inputId = "rpin_category",
                label = "Choose a category:",
                choices = c("Agriculture" = "agriculture",
                            "Crops" = "crops",
                            "Food" = "food",
                            "Livestock" = "livestock",
                            "Non-food" = "non_food")),
    selectizeInput(inputId = "regions",
                   label="Choose one or more regions:",
                   choices = c("Select here" = "", NULL),
                   multiple = TRUE)
  ),
  mainPanel(plotlyOutput('pin_region'))
)

production_tab = navbarMenu(
  "Gross Production",
  tabPanel(
    "Countries",
    pin_country
  ),
  tabPanel(
    "Regions",
    pin_regions
  )
)

## Land use tab:
land_use_country = fluidPage(
  fluidRow(
    column(6,
           plotlyOutput('forest_share_ctry')
    ),
    column(6,
           plotlyOutput('land_share_ctry')
    )
  ),
  hr(),
  fluidRow(
    column(4, offset = 4,
           selectizeInput(inputId = "share_countries",
                          label="Choose one or more countries:",
                          choices = c("Select here" = "", NULL),
                          multiple = TRUE)
    )
  )
)

land_use_regions = fluidPage(
  fluidRow(
    column(6,
           plotlyOutput('forest_share_reg')
    ),
    column(6,
           plotlyOutput('land_share_reg')
    )
  ),
  hr(),
  fluidRow(
    column(4, offset = 4,
           selectizeInput(inputId = "share_regions",
                          label="Choose one or more regions:",
                          choices = c("Select here" = "", NULL),
                          multiple = TRUE)
    )
  )
)

land_use_tab = navbarMenu(
  "Land use",
  tabPanel(
    "Countries",
    land_use_country
  ),
  tabPanel(
    "Regions",
    land_use_regions
  )
)


## Master UI for dashboard
navbarPage(
  title = tags$head(tags$link(
    rel="shortcut icon", href="favicon.ico")),
  about_tab,
  production_tab,
  land_use_tab,
  collapsible = TRUE,
  inverse = TRUE,
  windowTitle = "FAO Analysis",
  header = tags$style(
    ".navbar-nav {
    float: right !important;
    padding-right: 50px;
    }")
)