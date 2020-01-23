library(shiny)
library(data.table)
library(DT)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)
library(leaflet)
library(tidyverse)
library(plotly)
library(ggthemes)
library(ggplot2)
library(egg)

abnyc <- read.csv(file = "./AB_NYC_2019.csv")

# global theme for ggplots
th <- theme_fivethirtyeight() + theme(axis.title = element_text(), axis.title.x = element_text())

# data exploration and cleaning
glimpse(abnyc)
abnyc[c("last_review")] <- abnyc[c("last_review")] %>% map(~lubridate::ymd(.x))
glimpse(abnyc) # data types checked
abnyc %>% summarise_all(~(sum(is.na(.)))) #10052 missing values in last_review/reviews_per_month; reason: no review == no last review date
#fill in missing values
abnyc$reviews_per_month[is.na(abnyc$reviews_per_month)] <-0
#abnyc$last_review[is.na(abnyc$last_review)] <-"1900-01-01"
#abnyc$neighbourhood_group<- as.character(abnyc$neighbourhood_group)
#abnyc$room_type <- as.character(abnyc$room_type)


# build abnyc2 for metadata explorer, better performance 
abnyc2<- abnyc %>% select(., -latitude,-longitude,-id,-host_id)
names(abnyc2)[names(abnyc2) == 'neighbourhood_group'] <- 'borough'
names(abnyc2)[names(abnyc2) == 'neighbourhood'] <- 'area'
names(abnyc2)[names(abnyc2) == 'minimum_nights'] <- 'min_nights'

# add another variable, min_cost: minimum cost per visit
abnyc2$min_cost <- abnyc2$min_nights * abnyc2$price

abnyc3 <-subset(abnyc2, min_cost < 2000 & min_cost>0)

# for better use reactive object, need to change borough and room_type from factor to character
abnyc2$borough <- as.character(abnyc2$borough)
abnyc2$room_type <- as.character(abnyc2$room_type)
#summary(abnyc2)


# identify the unique categories
borough_cat = unique(abnyc2$borough)
rt_cat = unique(abnyc2$room_type)


