# A good resource: https://stat545.com/shiny-tutorial.html

library(shiny)
library(dplyr)
# library(ggplot2)
library(plotly)

agri <- read.csv('data/Agri2.csv')
crops <- read.csv('data/Crops2.csv')
food <- read.csv('data/Food2.csv')
livestock <- read.csv('data/Livestock2.csv')
non_food <- read.csv('data/Non-food2.csv')
prod_regions <- read.csv('data/Gross_PIN_regions.csv')

agri_ctry <- read.csv('data/Agri_ctry.csv')
agri_regions <- read.csv('data/Agri_regions.csv')

forest_ctry <- read.csv('data/Forest_ctry.csv')
forest_regions <- read.csv('data/Forest_regions.csv')

server <- function(input, output, session) {
  updateSelectizeInput(session, 'countries',
                       choices = unique(agri[,1]),
                       server = TRUE)
  updateSelectizeInput(session, 'regions',
                       choices = unique(prod_regions[,1]),
                       server = TRUE)
  
  updateSelectizeInput(session, 'share_countries',
                       choices = unique(agri[,1]),
                       server = TRUE)
  updateSelectizeInput(session, 'share_regions',
                       choices = unique(prod_regions[,1]),
                       server = TRUE)

  ## Gross production tab:
  ### Chart 1
  datasetInput <- reactive({
    switch(input$cpin_category,
           "Agriculture" = agri,
           "Crops" = crops,
           "Food" = food,
           "Livestock" = livestock,
           "Non-food" = non_food)
  })

  # output$pin_country <- renderPlot({
  #   new <- datasetInput() %>% 
  #     filter(Region %in% input$countries) %>%
  #     select(Region, Year, PIN)
  # 
  #   # create a plot
  #   ggplot(new, aes(x = Year, y = PIN)) +
  #     geom_line(aes(color = Region), size = 1.3) +
  #     ggtitle(paste0("Gross Production Index Number, ",
  #                    input$cpin_category)) +
  #     labs(x='Year', y='') +
  #     theme(plot.title = element_text(hjust=0.5)) +
  #     scale_x_continuous(breaks=c(1962, 1967, 1972, 1977, 1982,
  #                                 1987, 1992, 1997, 2002, 2007))
  # })
  mrg <- list(l = 50, r = 20, b = 50, t = 50,
              pad = 20)

  output$pin_country <- renderPlotly({
    req(input$countries)
    if(identical(input$countries, "")) return(NULL)

    new <- datasetInput() %>% 
      filter(Region %in% input$countries) %>%
      select(Region, Year, PIN)

    p <- plot_ly(new, x = ~Year, y = ~PIN, type = 'scatter',
            mode = 'lines', split = ~Region)
    p <- p %>% layout(title = paste0(
      "Gross Production Index Number, ",
      input$cpin_category,
      "<br><sup> Base period: 1999-2001 </sup><br>"),
      xaxis = list(title = 'Year'))

    p <- p %>% layout(legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = mrg)
    p <- p %>% config(displayModeBar = F)
  })

  ### Chart 2
  output$pin_region <- renderPlotly({
    req(input$regions)
    if(identical(input$regions, "")) return(NULL)

    # create subset of data
    small_region <- prod_regions %>%
      filter(Region %in% input$regions,
             Category == input$rpin_category)

    p <- plot_ly(small_region, x = ~Year, y = ~PIN, type = 'scatter',
                 mode = 'lines', split = ~Region)
    p <- p %>% layout(title = paste0(
      "Gross Production Index Number, ",
      input$rpin_category,
      "<br><sup> Base period: 1999-2001 </sup><br>"),
      xaxis = list(title = 'Year'))

    p <- p %>% layout(legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = mrg)
    p <- p %>% config(displayModeBar = F)
  })

  ## Land use tab:
  ### Charts 1: 
  output$forest_share_ctry <- renderPlotly({
    req(input$share_countries)
    if(identical(input$share_countries, "")) return(NULL)

    data_to_plot <- forest_ctry %>%
      filter(Region %in% input$share_countries) %>%
      select(Region, Year, FRatio)

    p <- plot_ly(data_to_plot, x = ~Year, y = ~FRatio,
                 type='scatter', mode='lines', split=~Region)
    p <- p %>% layout(title = 'Share of total land area under forests',
                      xaxis = list(title = 'Year'),
                      yaxis = list(title = '% of total land area'))
    p <- p %>% layout(legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = list(t=33))
    p <- p %>% config(displayModeBar = F)
  })

  output$land_share_ctry <- renderPlotly({
    req(input$share_countries)
    if(identical(input$share_countries, "")) return(NULL)

    data_to_plot <- agri_ctry %>%
      filter(Region %in% input$share_countries) %>%
      select(Region, Year, ARatio)

    p <- plot_ly(data_to_plot, x = ~Year, y = ~ARatio,
                 type='scatter', mode='lines', split=~Region)
    p <- p %>% layout(xaxis = list(title = 'Year',
                                   range = c('1990', '2007'),
                                   rangeslider = c(autorange=TRUE)),
                      yaxis = list(title = '% of total land area'))

    p <- p %>% layout(title = 'Share of total land area for agriculture use',
                      legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = list(t=33))
    p <- p %>% config(displayModeBar = F)
  })

  ### Charts 2:
  output$forest_share_reg <- renderPlotly({
    req(input$share_regions)
    if(identical(input$share_regions, "")) return(NULL)

    data_to_plot <- forest_regions %>%
      filter(Region %in% input$share_regions) %>%
      select(Region, Year, FRatio)

    p <- plot_ly(data_to_plot, x = ~Year, y = ~FRatio,
                 type='scatter', mode='lines', split=~Region)
    p <- p %>% layout(title = 'Share of total land area under forests',
                      xaxis = list(title = 'Year'),
                      yaxis = list(title = '% of total land area'))

    p <- p %>% layout(legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = list(t=33))
    p <- p %>% config(displayModeBar = F)
  })

  output$land_share_reg <- renderPlotly({
    req(input$share_regions)
    if(identical(input$share_regions, "")) return(NULL)

    data_to_plot <- agri_regions %>%
      filter(Region %in% input$share_regions) %>%
      select(Region, Year, ARatio)

    p <- plot_ly(data_to_plot, x = ~Year, y = ~ARatio,
                 type='scatter', mode='lines', split=~Region)
    p <- p %>% layout(xaxis = list(title = 'Year',
                                   range = c('1990', '2007'),
                                   rangeslider = c(autorange=TRUE)),
                      yaxis = list(title = '% of total land area'))

    p <- p %>% layout(title = 'Share of total land area for agriculture use',
                      legend = list(orientation="h", yanchor="bottom",
                                    y=-0.31, xanchor="left", x=0),
                      hovermode = 'x unified',
                      margin = list(t=33))
    p <- p %>% config(displayModeBar = F)
  })

}