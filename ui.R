
library(shiny)
library(tidyverse)
library(gapminder)
library(bslib)

shinyUI(fluidPage(
  theme = bs_theme(version = 4, bootswatch = "minty"),
  titlePanel("Life expectancy of people worldwide from 1952 to 2007"),
  p("The", strong("Gapminder"), " is a popular data set set where it contains historical
    (1952-2007) data on various indicators, such as life expectancy, GDP, and population 
      for countries worldwide. This app is built to explore, summarize, display the
      life expectancy of people at different perspectives. Besides the app will
      help to compare the life expectancy between countries or continents in different years.
      Finally, the app will allow to explore the trend in life-expectancy over time in countries."),
  br(),
  fluidRow(
    
    column(5,
           h4("Enter a GDP range!"),
           p("It affects only on the", strong("Exploratory analysis"), "tab"),
           br(),
           sliderInput("gdpInput", "gdpPercap", 200, 10000,
                       value = c(1000, 8000), pre = "$ "),
    ),
    
    column(4,
           h4("Select the continent!"),
           p("Its selection affects only on the", strong("Exploratory analysis"), "tab"),
           selectInput("continentInput", "continent", choices = unique(gapminder$continent),
                       selected = c("Asia", "Europe"), multiple = TRUE, selectize = TRUE), br(),
           
           h4("Select the countries for times series graphs!"), 
           p("Its selection affects only on the", strong("Time series graphics"), "tab"),
           selectInput("countrytInput", "country", choices = unique(gapminder$country),
                       selected = c("Canada", "Bangladesh"), multiple = TRUE, selectize = TRUE),
           
           
           ),
    
    
    column(3,
           h4("Select the year!"), 
           p("It affects only on the", strong("Exploratory analysis"), "tab"), br(),      
           checkboxGroupInput("yearInput", "year", choices = factor(seq(from = 1952, to = 2007, by = 5)),
                              selected = factor(c(1952, 2007)),
                              inline = FALSE)),
    
    
  ),
  
  
  
  
  mainPanel(
   
    fluidRow(
      align = "left",
      tabsetPanel(
        tabPanel("Exploratory analysis", 
                 br(), br(),
                 h5(strong("Table 1:"),"The following table displays a summary statistics of life-expectancy
                 among continents" ,
                   align = "left"),
                 br(), br(),
                 DT::dataTableOutput("five_summary"),
                 br(), br(), 
                 downloadButton("download_Table1", "Click here to download Table 1", class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br(),
                 
                
                
                 h5(strong("Figure 1:"),"The following boxplot displays and compares the five number summary [minimum, Q1, median,
                   Q3, and maximum] of life-expectancy among continents. The summary is calculated based on
                   multiple years or a single year statistics (upon your selection)" ,
                   align = "left"),
                 br(), br(),
                 plotOutput("LifeExp_output"), 
                 br(), br(),
                 downloadButton('download_plot',label='Download Figure 1', class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br(),
        

                 h5(strong("Figure 2:"),"Correlation between GDP and Life expectancy in continents. " ,
                    align = "left"),
                 br(), br(),
                 plotOutput("correlation_plot", click = "plot_click"),
                 verbatimTextOutput("info1"), 
                 br(), br(),
                 downloadButton('download_correlation_plot',label='Download Figure 2', class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br(),
                 
                 
                 
                                  
               h5(strong("Data set 1:"),"The following table displays the data set searched" ,
                  align = "left"),
               br(), br(), 
                textOutput("search_data"),
                DT::dataTableOutput("data_table"),
                br(), br(),
                downloadButton("download_Table2", "Click here to download Data set 1", class = "butt"),
                tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                br(), br(), br()),
        
        tabPanel("Times series graphics",
                 h5(strong("Figure 3:"),"The following line plot displays and compares the yearly life-expectancy
                 among countries. Click on the graph to see the coordinate." ,
                    align = "left"),
                 br(), br(),
                 plotOutput("time_series_plot", click = "plot_click"),
                 verbatimTextOutput("info"),
                 br(), br(),
                 downloadButton('download_time_plot',label='Download Figure 3', class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br(),
                 
        )
      )
    )
  )
)
)