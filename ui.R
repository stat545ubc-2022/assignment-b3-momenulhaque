
library(shiny)
library(tidyverse)
library(gapminder)

shinyUI(fluidPage(
  titlePanel("Life expectancy of people in continents from 1952 to 2007"),
  br(),
  fluidRow(
    
    column(5,
           h4("Enter a GDP range!"), br(),
           sliderInput("gdpInput", "gdpPercap", 200, 10000,
                       value = c(1000, 8000), pre = "$ "),
    ),
    
    column(4,
           h4("Select the continent!"), br(),
           selectInput("continentInput", "continent", choices = c("Africa", "Americas", "Asia", "Europe", "Oceania"),
                       selected = c("Asia", "Europe"), multiple = TRUE, selectize = TRUE)),
    
    
    column(3,
           h4("Select the year!"), br(),      
           checkboxGroupInput("yearInput", "year", choices = factor(seq(from = 1952, to = 2007, by = 5)),
                              selected = factor(seq(from = 1952, to = 2007, by = 5)),
                              inline = FALSE)),
    
    
  ),
  
  
  
  
  mainPanel(
    fluidRow(
      align = "center",
      tabsetPanel(
        tabPanel("Box plot", 
                 plotOutput("LifeExp_output"), 
                 br(), br(),
                 downloadButton('download_plot',label='Download the plot', class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br()),
        
        tabPanel("Data set", 
                 textOutput("search_data"),
                 DT::dataTableOutput("data_table"),
                 br(), br(),
                 downloadButton("downloadData", "Click here to download the data", class = "butt"),
                 tags$head(tags$style(".butt{background-color:#add8e6;} .butt{color: blue;}")),
                 br(), br(), br())
      )
    )
  )
)
)