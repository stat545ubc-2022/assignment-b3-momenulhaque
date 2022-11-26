

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
  
  
  output$search_data <- renderText({
    
    n = filtered_Gapdata() %>% 
      summarise(n=n())
    paste0("We have found ", n, " rows for you", "\n", "\n", "\n")  
    
  })
  
  
  output$downloadData <- downloadHandler(
    
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
  
  plot_output <-  reactive({
    filtered_Gapdata() %>% 
      mutate(year = factor(year)) %>% 
      ggplot(aes(x=lifeExp, y = year, color = year)) +
      labs(title = paste0("Boxplot of life expectancy in ", 
                          str_c(levels(pull(filtered_Gapdata() %>% mutate(continent=factor(continent)) %>% 
                                              select(continent) %>% unique())), collapse = ", "),
                          " for different years"),
           x = "Life expectency at birth (in years)") +
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
  
  
}
)
