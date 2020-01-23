#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
ui<-dashboardPage(skin="black",
  dashboardHeader(title="NYC Airbnb 2019  Yutian Zhou",titleWidth = 450),
  dashboardSidebar(
    #sidebarUserPanel("Yutian Zhou"),
    sidebarMenu(
      menuItem("Introduction",tabName="intro",icon=icon("edit")),
      menuItem("Metadata Explorer",tabName="data",icon=icon("database")),
      menuItem("Exploratory Data Analysis",icon=icon("chart-bar"), 
               menuSubItem("Minimum Costs", tabName = "eda_min"), 
               menuSubItem("Others", tabName = "eda_other")),
      menuItem("Potential Relationships", tabName="rel",icon=icon("random")),
      menuItem("City View", tabName="map",icon =icon("camera-retro")),
      menuItem("Conclusion",tabName="end", icon=icon("award"))
    )),
  ####################################################################
  #dashboard body
  dashboardBody(
    tabItems(
      ####################################################################
      # Introduction
      tabItem(tabName = "intro",
              fluidRow(column(
                  h1("New York City Airbnb Open Data"),
                  h3("Airbnb listings and metrics in NYC, NY, USA (2019)"),
                  tags$p(
                    "New York City has always been a trending destination for tourists from all over the world." ),
                  tags$p(
                    "We've known that NYC has a lot of iconic hotels for people to stay, but how about the newest trend of Airbnb?"),
                  tags$p("  Let's play with this interactive tool and explore Airbnbs in NYC in 2019!"),
                  width = 12
              )),
              br(),
              fluidRow(column(
                  h2("Data Source and Data Cleaning"),
                  tags$p(
                    "The original dataset came from Kaggle and Airbnb. On Airbnb's website they have their own interesting interactive tool to play with as well. Please refer to the below links:" ),
                  #tags$br(),
                  tags$a(href = "https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data#AB_NYC_2019.csv","Kaggle Dataset"),
                  tags$br(),
                  tags$a(href = "http://insideairbnb.com/","Airbnb Original Data"),
                  tags$p(
                    "As for data cleaning, in the metadata explorer, I omitted latitude,longitude,id, and host_id since they have little meaning to explore just by scanning. Also, I did an imputation on the variable reviews_per_month. Missing values in reviews_per_month is caused by no reviews on the Airbnb. The other variable that contains missing values, last_review, was remained unchanged since I did not plan to explore on it."),
                  tags$p("In the exploratory data analysis for minimum costs, minimum costs per visit is a new variable calculated by price multiplies minimum nights to stay. This is the minimum cost visitors would have to pay if they book one Airbnb. Also, since price and minimum costs are both highly positively skewed, for visualization and demonstration, I chose a cutoff of 2000 dollars per visit, and only included data that has minimum costs within the range of 0 and 2000 exclusively."),
                  width = 12
                )),
              br(),
              fluidRow(column(
                h2("Inspiration"),
                tags$p("- What can we learn about different locations (boroughs and areas)?"),
                tags$p("- What can we learn about price?"),
                tags$p("- Is there any noticeble relationships between variables?"),
                tags$p("- Is there any noticeable difference of traffic among different boroughs and what could be the reason for it?"),
                width = 12))),
      ####################################################################
      # metadata
      tabItem(tabName = "data",fluidRow(h1("Metadata Explorer")),
                                      fluidRow(
                                          column( width = 4 , 
                                                  
                                                  box( status = "warning", width = NULL, height = 100,
                                                       sliderInput(inputId = "price1", "Select Price Range", 
                                                                   min = 0.0, max = 10000.0, step = 1, value = c(0.0, 10000.0), sep ="" ) ) 
                                                  
                                          ) ,
                                          column( 
                                            width = 4,
                                            
                                            box( status = "warning", width = NULL, height = 100,
                                                 pickerInput(
                                                   inputId = "borough1",
                                                   label = "Select one or more boroughs",
                                                   choices = borough_cat,
                                                   multiple = TRUE,
                                                   selected = borough_cat,
                                                   options =  list(
                                                     "actions-box" = TRUE)
                                                 )
                                            ) 
                                          ),
                                          column(
                                            width = 4,
                                            
                                            box( status = "warning", width = NULL, height = 100,
                                                 pickerInput( inputId = "roomtype1", 
                                                                 label = "Select one or more room types",
                                                                 choices = rt_cat,
                                                                 multiple = TRUE,
                                                                 selected = rt_cat)
                                            ) 
                                          )
                                          
                                        ), fluidRow(DT::dataTableOutput("dataset"))),
      ####################################################################
      # EDA - minimum cost
      tabItem(tabName = "eda_min", fluidRow(h1("Boxplots of Minimum Cost per Visit")),br(),fluidRow(tabBox(
        id = "eda1tabs",
        width = NULL,
        height = 600,
        tabPanel("Room Type",box(title="Boxplot of Minimum Cost by Room Type",
                                  width = 5,
                                 plotlyOutput("mincost.rt"))),
        tabPanel("Borough",box(title="Boxplot of Minimum Cost by Borough",
                               width = 5,
                               plotlyOutput("mincost.br"))),
        tabPanel("Area by Borough",selectizeInput(
          "borough_selection",
          label = 'Select Borough:',
          choices = list("Brooklyn","Manhattan","Queens","Bronx","Staten Island")),
          box(title="Boxplots of Minimum Cost by Area in Each Borough (Top 10)",
               width = NULL,
              height = 300,
               plotlyOutput("mincost.area"))
        
      )), tags$p("Note: The cleaned dataset with minimum costs ranges from 0 to 2000 exclusively was used here."))),
      
      # EDA - Other
      tabItem(tabName = "eda_other", fluidRow(tabBox(
        id = "eda2tabs",
        width = NULL,
        height = 600,tabPanel("Count by Borough",
                                              box(width = 6,
                                                  plotlyOutput("count.br"))),
                     tabPanel("Availability by Borough",box(width = 6,
                                                  plotlyOutput("ava.br")))
                                             ) , tags$p("Note: The original dataset was used here."))),
      ####################################################################
      # potential relationships
      tabItem(tabName = "rel",fluidRow(tabBox(
        id = "eda2tabs",
        width = NULL,
        height = 600,tabPanel("Min Cost & Number of Reviews",
                                       box(width = 6,
                                           plotlyOutput("rel1"))),
                    tabPanel("Min Cost & Availability", 
                                       box(width = 6,
                                           plotlyOutput("rel2"))),
                    tabPanel("Number of Reviews & Availability",
                                      box(width = 6,
                                           plotlyOutput("rel3"))
                                       )), tags$p("Note: The cleaned dataset with minimum costs ranges from 0 to 2000 exclusively was used here."))),
      
      ####################################################################
      # city view visualizations

      tabItem(tabName = "map",fluidRow(h1("City View Visualizations")),br(),
              fluidRow(
        column(
          width = 12,
          tabBox(
            id = "maptabs",
            width = NULL,
            height = 600,
            tabPanel("Number of Airbnbs",leafletOutput("count.map")),
            tabPanel("Price",leafletOutput("price.map")),
            tabPanel("Availability in 365 Days",leafletOutput("ava.map"))
          
        )), tags$p("Note: The original dataset was used here."))),
      ####################################################################
      tabItem(tabName = "end", fluidRow(column(
        h2("Conclusions"),
        tags$p("- Manhattan has the biggest amount Airbnbs within NYC, followed by Brooklyn. Also, most of the Airbnbs tend to be around Manhattan."),
        tags$p("- Manhattan has the most expensive Airbnbs within NYC, followed by Brooklyn. Also, the closer the Airbnbs to Manhattan, the more expensive it seems to be. Within Manhattan, the most expensive Airbnbs are in Upper Manhattan."),
        tags$p("- The most expensive house type is \"Entire home/Apt\". Their average minimum cost is higher than the average price of all Airbnbs in NYC."),
        tags$p("- As for availability, in Manhattan, Airbnbs around the central park and around lower middle Manhattan are the hotest ones."),
        tags$p("- There is no noticable relationships between minimum costs and availability and between minimum costs and the number of reviews. However, visitors tend to prefer cost-effective Airbnbs and leave reviews for them."),
        width = 12)),
          br(),
          fluidRow(column(
            h2("Future Plans"),
            tags$p("- Explore more about hosts. Who are the busiest and why?"),
            tags$p("- What kind of Airbnb do people most love in NYC? Explore more on the Airbnb titles."),
            width = 12)),
        br(),
        fluidRow(column(
          h2("References"),
          tags$p("https://www.kaggle.com/josipdomazet/mining-nyc-airbnb-data-using-r"),tags$p("https://www.kaggle.com/kylethomas67/airbnb-host-success-eda-nlp"),width = 12))
      )
    )
  )
)
