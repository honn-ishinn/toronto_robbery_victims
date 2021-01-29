#### Preamble ####
# Purpose: Provide codes for analysis of Toronto robbery victims in the paper[...UPDATE ME!!!!!]
# Author: Hong Shi
# Date: 26 January 2021
# Contact: lancehong.shi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the cleaned data in "01_toronto_crime_victims_data_import.R" and saved it to inputs/data
# - Don't forget to gitignore it!
# - Change these to yours
# Any other information needed?



#### Workspace setup ####
# Use R Projects, not setwd().

library(tidyverse)
library(bookdown)
library(scales)
library(here)
library(kableExtra)
# Read in the cleaned data. 
victims_data <- read_csv(here::here("inputs/data/toronto_crime_victims_data.csv"))

#### Relevant analysis ####

# explore different types of crime victims

unique(victims_data$Subtype)


#### Table 1 ####
# Get the number of years included in the dataset
year <- length(unique(victims_data$ReportedYear))

# Obtain the table about the annual average number of victims across all crime types by sex
victims_by_sex <- 
  victims_data %>%
  group_by( Sex) %>% 
  summarise(
    Annual_Victims = sum( Count_)/ year
  ) %>% 
  mutate(across(where(is.numeric),round, 0))

# Obtain the table about the annual average number of victims for only robbery victims by sex
robbery_by_sex <- 
  victims_data %>%
  filter( Subtype == "Robbery") %>% 
  group_by( Sex) %>% 
  summarise( 
    Robbery_Victims = sum( Count_) / year
  ) %>% 
  mutate(across(where(is.numeric),round, 0))

# Join the above tables and also calculate the percentage of robbery victims cross all victims 
# Referenced the following link to convert a decimal number into percentage https://stackoverflow.com/questions/7145826/how-to-format-a-number-as-percentage-in-r
robbery_data <- victims_by_sex %>% 
  left_join( robbery_by_sex, by = "Sex") %>% 
  mutate( Percentage_of_Robbery_Victims = percent(Robbery_Victims / Annual_Victims, accuracy = 0.01))

# Display the table result  
# Referenced the following link to format the table https://bookdown.org/yihui/rmarkdown-cookbook/kableextra.html 
# Referenced the following link to hold the position of the table: https://stackoverflow.com/questions/53153537/rmarkdown-setting-the-position-of-kable 
robbery_data %>% 
  knitr::kable(
    col.names = c("Sex", "Crime Victims", "Robbery Victims", "Percentage of Robbery Victims"),
    align = "cccc",
    caption = "Average Annual Crime Victims between 2014 and 2019") %>% 
  kable_styling(latex_options = "hold_position")

#### Line chart ####

robbery_by_year <- 
  victims_data %>% 
  filter( Subtype == "Robbery") %>% 
  group_by( ReportedYear, Sex) %>% 
  summarise(
    robbery_year = sum( Count_)
  )

# Referenced the following link to center the title: https://stackoverflow.com/questions/40675778/center-plot-title-in-ggplot2
# Referenced the following link to control the ticks https://r4ds.had.co.nz/graphics-for-communication.html
ggplot( data = robbery_by_year, mapping =  aes(x = ReportedYear, y = robbery_year) ) +
  geom_line( aes( color = Sex)) +
  geom_point( aes( color = Sex)) +
  theme_minimal() +
  coord_cartesian( ylim = c(0,3200)) +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    title = "Annual Robbery Victims between 2014 and 2019",
    x = "Year",
    y = "Robbery Victims"
  ) +
  scale_y_continuous(breaks = seq(0,3200, by = 800))

#### Bar chart #### 

# Obtain the table about the annual average robbery victims by sex and age group
robbery_Victims_sexage <- 
  victims_data %>% 
  filter( Subtype == "Robbery") %>% 
  group_by( AgeCohort, Sex) %>% 
  summarise(
    Victims_by_SexAge = sum( Count_ ) / year
  ) %>% 
  mutate(across(where(is.numeric),round, 0))

# Using bar chart to display the result

ggplot( data = robbery_Victims_sexage ) +
  geom_col(mapping = aes(x = AgeCohort, y = Victims_by_SexAge, fill = Sex ), position = "dodge" ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(
    title = "Average Annual Robbery Victims by Age Group between 2014 and 2019",
    x = "Age Group",
    y = "Robbery Victims"
  )

#### Find the percentage of male robbery victims within 12-34 ages among all robbery victims

unique(victims_data$AgeCohort)
high_risk <- 
  victims_data %>% 
  filter( Subtype == "Robbery", Sex ==  "Male", AgeCohort %in% c("12-17","18-24","25-34"))

total_victims <-
  victims_data %>% 
  filter( Subtype == "Robbery")

# 53% of robbery victims are young males within 12-34 age group
percent(sum(high_risk$Count_)/sum(total_victims$Count_), accuracy = 0.01)




