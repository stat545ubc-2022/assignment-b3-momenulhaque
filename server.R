library(shiny)
library(tidyverse)
library(gapminder)


shinyServer(function(input, output) {
  
  filtered_Gapdata <-
    reactive({
      gapminder %>% 
        mutate(year = factor(year)) %>% 
        filter((gdpPercap > input$gdpInput[1] & gdpPercap < input$gdpInput[2]) &
                 (continent %in% input$continentInput) & 
                 (year %in% input$yearInput)) 
    })
  
 ##### Table 1: summary statistics
  lower_ci <- function(mean, se, n, conf_level = 0.95){
    lower_ci <- mean - qt(1 - ((1 - conf_level) / 2), n - 1) * se
  }
  upper_ci <- function(mean, se, n, conf_level = 0.95){
    upper_ci <- mean + qt(1 - ((1 - conf_level) / 2), n - 1) * se
  }
  
 five_summary <- reactive({
   filtered_Gapdata() %>% 
     group_by(continent, year) %>% 
     summarise(count = n(),
               min = round(min(lifeExp), 2),
               max = round(max(lifeExp), 2),
               mean = round(mean(lifeExp, na.rm = T), 2),
               Q1 = round(stats::quantile(lifeExp, probs = .25, na.rm = TRUE), 2),
               se = round(sd(lifeExp, na.rm = T) / sqrt(count), 2),
               median = round(stats::median(lifeExp, na.rm = TRUE), 2),
               Q3 = round(stats::quantile(lifeExp, probs = .75, na.rm = TRUE), 2),
               lower_ci = round(lower_ci(mean, se, count), 2),
               upper_ci = round(upper_ci(mean, se, count), 2)
               )
 })

 
 output$five_summary <- 
   
   DT::renderDataTable({
     DT::datatable(five_summary(), options = list(
       lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')),
       pageLength = 15
     )) 
     
   })
 
 output$download_Table1 <- downloadHandler(
   
   filename = function() {
     paste("Summary_data", ".csv", sep="")
   },
   content = function(file) {
     write.csv(five_summary(), file)
   }
 )

 ######## Figure 1: boxplot ##############
 
 
 plot_output <-  reactive({
   filtered_Gapdata() %>% 
     mutate(year = factor(year)) %>% 
     ggplot(aes(x=lifeExp, y = year, color = year)) +
     labs(title = paste0("Boxplot of life expectancy in ", 
                         str_c(levels(pull(filtered_Gapdata() %>% mutate(continent=factor(continent)) %>% 
                                             select(continent) %>% unique())), collapse = ", "),
                         " for different years"),
          x = "Life expectency at birth (in years)") +
     scale_x_continuous(limits=c(0, 100)) + 
     geom_boxplot() + theme_bw() + facet_wrap(~ continent) +
     theme(legend.position="none",
           strip.text = element_text(size = 12, color="black", face="bold"),
           axis.title.x = element_text(size=12, color="black", face="bold"),
           axis.title.y = element_text(size=12, color="black", face="bold"),
           axis.text.y= element_text(size=10, color="black", face="bold"),
           axis.text.x= element_text(size=10, color="black", face="bold", angle = 45, hjust = 1),
           plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
     )+
     coord_flip()
   
 })
 
 
 output$LifeExp_output <- 
   
   renderPlot({
     
     print(plot_output())
     
     
   })
 
 
 
 output$download_plot <- downloadHandler(
   filename = "box_plot.png",
   content = function(file) {
     n1 = filtered_Gapdata() %>% summarise(length(unique(continent))) %>% pull()
     png(file, width = 300*n1, height = 450)
     print(plot_output())
     dev.off()
   })
 
 
 
 ######## scatter plot ########## 
 
 correlation_plot <- reactive({
   filtered_Gapdata() %>% 
     ggplot(aes(x=log(gdpPercap), y = lifeExp, color = continent)) +
     geom_smooth(method="gam", formula = y ~ s(x, bs = "cs"), se = TRUE,
                 aes(fill=continent)) +
     geom_point() +
     facet_wrap(~ continent) +
     labs(title = paste0("Scatter plot of GDP and life expectancy"),
          x = "Log(GDP)",
          y = "Life expectency at birth (in years)") +
     scale_y_continuous(limits=c(0, 100)) + 
     theme(legend.position="right",
           strip.text = element_text(size = 12, color="black", face="bold"),
           axis.title.x = element_text(size=12, color="black", face="bold"),
           axis.title.y = element_text(size=12, color="black", face="bold"),
           axis.text.y= element_text(size=10, color="black", face="bold"),
           axis.text.x= element_text(size=10, color="black", face="bold", angle = 45, hjust = 1),
           plot.title = element_text(size = 15, hjust = 0.5, face = "bold"))
   
   
 })
 
 output$correlation_plot <- 
   
   renderPlot({
     
     correlation_plot()
     
     
   })
 
 output$download_correlation_plot <- downloadHandler(
   filename = "correlation_plot.png",
   content = function(file) {
     png(file, width = 600, height = 450)
     print(correlation_plot())
     dev.off()
   })
 
 
 output$info1 <- renderText({
   paste0("GDP=", input$plot_click$x, "\n",
          "Life_exptancy=", input$plot_click$y)
 })
 
 
 
 
 
 
 
 ######## Data set 1 ##################

 output$search_data <- renderText({
   
   n = filtered_Gapdata() %>% 
     summarise(n=n())
   paste0("We have found ", n, " rows for you", "\n", "\n", "\n")  
   
 })
  
  
  output$download_Table2 <- downloadHandler(
    
    filename = function() {
      paste("Gapminder_data", ".csv", sep="")
    },
    content = function(file) {
      write.csv(filtered_Gapdata(), file)
    }
  )
  
  
  
  output$data_table <- 
    
    DT::renderDataTable({
      
      filtered_Gapdata()
      
    })
  
  
 
  
 ######## Times series graphics tab ########## 
  
  filtered_Gapdata1 <-
    reactive({
      gapminder %>% 
        filter(country %in% input$countrytInput) 
    })
  
  time_Series_plot <- reactive({
    filtered_Gapdata1() %>% 
    ggplot(aes(x=year, y = lifeExp, color = country)) +
    geom_point(aes(shape = country)) + geom_line(aes(linetype = country)) +
    labs(title = paste0("Line diagram of life expectancy for ", 
                        str_c(levels(pull(filtered_Gapdata1() %>% mutate(country=factor(country)) %>% 
                                            select(country) %>% unique())), collapse = ", "),
                        " from 1952 to 2007"),
         x = "Year",
         y = "Life expectency at birth (in years)") +
      scale_y_continuous(limits=c(0, 100)) + 
      scale_x_continuous(limits=c(1952, 2007), breaks = seq(1952, 2007, by = 5)) + 
    theme(legend.position="right",
          strip.text = element_text(size = 12, color="black", face="bold"),
          axis.title.x = element_text(size=12, color="black", face="bold"),
          axis.title.y = element_text(size=12, color="black", face="bold"),
          axis.text.y= element_text(size=10, color="black", face="bold"),
          axis.text.x= element_text(size=10, color="black", face="bold", angle = 45, hjust = 1),
          plot.title = element_text(size = 15, hjust = 0.5, face = "bold"),
    )
    
  })
  
  output$time_series_plot <- 
    
    renderPlot({
      
     time_Series_plot()
      
      
    })
  
  output$download_time_plot <- downloadHandler(
    filename = "time_series_plot.png",
    content = function(file) {
      png(file, width = 500, height = 450)
      print(time_Series_plot())
      dev.off()
    })
  
  
  output$info <- renderText({
    paste0("year=", input$plot_click$x, "\n",
           "Life_exptancy=", input$plot_click$y)
  })
 
   
   
  
  
  
})
