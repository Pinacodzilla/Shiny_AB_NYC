#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  data.choice = reactive({
    req(input$price1)
    req(input$borough1)
    req(input$roomtype1)
    
    abnyc2 %>% filter( price >= input$price1[1] &
                          price <= input$price1[2] & borough %in% input$borough1 & room_type %in% input$roomtype1) 
 
    
  })
   
  #metadata explorer
  output$dataset <- DT::renderDataTable({data.choice()})
  
  ##################################################################
  # EDA - MIN_COST
  # BY ROOM TYPES
  output$mincost.rt <- renderPlotly ({
    
    ggplotly (abnyc3 %>%  ggplot(aes(x = room_type, y = min_cost)) +
                geom_boxplot(aes(fill = room_type)) + 
                #scale_y_log10() +
                th + 
                xlab("Room type") + 
                ylab("Minimum Cost per Visit") +
                #ggtitle("Boxplots of Min Cost by Room Type") +
                geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))
  })
  
  # BY BOROUGH
  output$mincost.br <- renderPlotly ({

    ggplotly (abnyc3 %>%  ggplot(aes(x = borough, y = min_cost)) +
                geom_boxplot(aes(fill = borough)) + 
                #scale_y_log10() +
                th + 
                xlab("Borough") + 
                ylab("Minimum Cost per Visit") +
                #ggtitle("Boxplots of Min Cost by Borough") +
                geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))
  })
  
  # BY AREA
  output$mincost.area <- renderPlotly ({
    if (input$borough_selection=="Brooklyn") {
      brklyn <-abnyc3 %>% filter(.,borough == "Brooklyn")%>%
        group_by(.,area)%>%
        summarise(.,count=n())%>%
        arrange(desc(count))%>%
        top_n(10)
      brklyn2 <-merge(abnyc3,brklyn,by='area')
    ggplotly (brklyn2 %>% ggplot(aes(x = area, y = min_cost)) +
                geom_boxplot(aes(fill = area)) + 
                #scale_y_log10() +
                th + 
                coord_flip() +
                xlab("Area") + 
                ylab("Minimum Cost per Visit") +
                ggtitle("Boxplot of Min Cost by Area in Brooklyn") +
                geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))}
    
    else if (input$borough_selection=="Manhattan") {
      manh <-abnyc3 %>% filter(.,borough == "Manhattan")%>%
        group_by(.,area)%>%
        summarise(.,count=n())%>%
        arrange(desc(count))%>%
        top_n(10)
      manh2 <-merge(abnyc3,manh,by='area')
      ggplotly (manh2 %>% ggplot(aes(x = area, y = min_cost)) +
                  geom_boxplot(aes(fill = area)) + 
                  #scale_y_log10() +
                  th + 
                  coord_flip() +
                  xlab("Area") + 
                  ylab("Minimum Cost per Visit") +
                  ggtitle("Boxplot of Min Cost by Area in Manhattan") +
                  geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))}
    
    else if (input$borough_selection=="Queens") {
      que <-abnyc3 %>% filter(.,borough == "Queens")%>%
        group_by(.,area)%>%
        summarise(.,count=n())%>%
        arrange(desc(count))%>%
        top_n(10)
      que2 <-merge(abnyc3,que,by='area')
      ggplotly (que2 %>% ggplot(aes(x = area, y = min_cost)) +
                  geom_boxplot(aes(fill = area)) + 
                  #scale_y_log10() +
                  th + 
                  coord_flip() +
                  xlab("Area") + 
                  ylab("Minimum Cost per Visit") +
                  ggtitle("Boxplot of Min Cost by Area in Queens") +
                  geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))}
    
    else if (input$borough_selection=="Bronx") {
      brx <-abnyc3 %>% filter(.,borough == "Bronx")%>%
        group_by(.,area)%>%
        summarise(.,count=n())%>%
        arrange(desc(count))%>%
        top_n(10)
      brx2 <-merge(abnyc3,brx,by='area')
      ggplotly (brx2 %>% ggplot(aes(x = area, y = min_cost)) +
                  geom_boxplot(aes(fill = area)) + 
                  #scale_y_log10() +
                  th + 
                  coord_flip() +
                  xlab("Area") + 
                  ylab("Minimum Cost per Visit") +
                  ggtitle("Boxplot of Min Cost by Area in Bronx") +
                  geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))}
    
    else if (input$borough_selection=="Staten Island") {
      stid <-abnyc3 %>% filter(.,borough == "Staten Island")%>%
        group_by(.,area)%>%
        summarise(.,count=n())%>%
        arrange(desc(count))%>%
        top_n(10)
      stid2 <-merge(abnyc3,stid,by='area')
      ggplotly (stid2 %>% ggplot(aes(x = area, y = min_cost)) +
                  geom_boxplot(aes(fill = area)) + 
                  #scale_y_log10() +
                  th + 
                  coord_flip() +
                  xlab("Area") + 
                  ylab("Minimum Cost per Visit") +
                  ggtitle("Boxplot of Min Cost by Area in Staten Island") +
                  geom_hline(yintercept = mean(abnyc3$min_cost), color = "purple", linetype = 2))}
    
  })
  
  
  
  # EDA - OTHER
  output$count.br <- renderPlotly ({
     count_gpb_br<-abnyc2 %>% 
      group_by(.,borough)%>%
      summarise(.,count=n())
     
    ggplotly (count_gpb_br %>% ggplot(aes(x = borough, y = count)) +
                geom_bar(aes(fill = borough),stat = "identity") + 
                #scale_y_log10() +
                th + 
                coord_flip() +
                xlab("Borough") + 
                ylab("Number of Airbnbs") +
                ggtitle("Barplot of Number of Airbnbs by Borough")
                )
    
  })
  
  output$ava.br <- renderPlotly ({
    ggplotly (abnyc2 %>% ggplot(aes(x = borough, y = availability_365)) +
                geom_boxplot(aes(fill = borough)) + 
                #scale_y_log10() +
                th + 
                #coord_flip() +
                xlab("Borough") + 
                ylab("Availability in 365 Days") +
                ggtitle("Boxplot of Availability in 365 Days by Borough") +
                geom_hline(yintercept = mean(abnyc3$availability_365), color = "purple", linetype = 2))
  })
  
  ##################################################################
  # potential relationships
  output$rel1 <- renderPlotly({
    ggplotly(abnyc3 %>% ggplot(aes(min_cost,number_of_reviews)) +
               th + 
               theme(axis.title = element_text(), axis.title.x = element_text()) +
               geom_point(alpha = 0.05,colour = "pink") +
               xlab("Minimum Cost per Visit") +
               ylab("Number of Reviews") +
               ggtitle("Min Cost and Number of Reviews"))
  })
  
  output$rel2 <- renderPlotly({
    ggplotly(abnyc3 %>% ggplot(aes(min_cost,availability_365)) +
               th + 
               theme(axis.title = element_text(), axis.title.x = element_text()) +
               geom_point(alpha = 0.05,colour = "pink") +
               xlab("Minimum Cost per Visit") +
               ylab("Avaliability in 365 Days") +
               ggtitle("Min Cost and Availability"))
  })
  
  output$rel3 <- renderPlotly({
    ggplotly(abnyc3 %>% ggplot(aes(number_of_reviews,availability_365)) +
               th + 
               theme(axis.title = element_text(), axis.title.x = element_text()) +
               geom_point(alpha = 0.05, colour = "pink") +
               xlab("Number of Reviews") +
               ylab("Avaliability in 365 Days") +
               ggtitle("Number of Reviews and Availability"))
  })
  ##################################################################
  # city view map visualizations
  #count
  output$count.map <- renderLeaflet({ 
    pal <- colorFactor(palette = c("red", "green", "blue", "purple", "yellow"), domain = abnyc$neighbourhood_group)
  
  leaflet(data = abnyc) %>% addProviderTiles(providers$CartoDB.DarkMatterNoLabels) %>%  addCircleMarkers(~longitude, ~latitude, color = ~pal(neighbourhood_group), weight = 1, radius=1, fillOpacity = 0.1, opacity = 0.1,
                                                                                                          label = paste("Name:", abnyc$name)) %>% 
    addLegend("bottomright", pal = pal, values = ~neighbourhood_group,
              title = "Neighbourhood groups",
              opacity = 1
    )
    })
  
  
  # price
  output$price.map <- renderLeaflet({ 
    pal <- colorQuantile(
      palette = "RdYlBu",
      domain = abnyc$price)
    
    leaflet(data = abnyc) %>% addProviderTiles(providers$CartoDB.VoyagerNoLabels) %>%  addCircleMarkers(~longitude, ~latitude, color = ~pal(price), weight = 1, radius=1, fillOpacity = 0.1, opacity = 0.1,
                                                                                                           label = paste("Name:", abnyc$name)) %>% 
      addLegend("bottomright", pal = pal, values = ~price,
                title = "Price Quantile",
                opacity = 1
      )
  })
  
  # availability_365
  output$ava.map <- renderLeaflet({ 
    pal <- colorNumeric(
      palette = "YlGnBu",
      domain = abnyc$availability_365)
    
    leaflet(data = abnyc) %>% addProviderTiles(providers$CartoDB.Positron) %>%  addCircleMarkers(~longitude, ~latitude, color = ~pal(availability_365), weight = 1, radius=1, fillOpacity = 0.1, opacity = 0.1,
                                                                                             label = paste("Name:", abnyc$name)) %>% 
      addLegend("bottomright", pal = pal, values = ~availability_365,
                title = "Availability in 365 Days",
                opacity = 1
      )
  })
})
