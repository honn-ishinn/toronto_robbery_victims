#### Preamble ####
# Purpose: Clean the crime victims data downloaded from opendatatoronto
# Author: Hong Shi
# Date: 29 January 2021
# Contact: lancehong.shi@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the raw data in "00_toronto_crime_victims_data_import.R" and saved it to inputs/data


#### Workspace setup ####

library(tidyverse)

# Read in the raw data. 
raw_data <- readr::read_csv("inputs/data/raw_data.csv")

#### Selecting variables of interest ####

names(raw_data)

# Since we are exploring Toronto robbery victims data, and the dataset only includes 
# all identified victims of crimes against the person, we keep "Index_" ( for easier arrangement of the dataset order),
# "ReportedYear", "Subtype", "Sex", "AgeGroup" and "AgeCohort" in reduced dataset.
# We do not include "AssaultSubtype" in our dataset since it only relates "Assault" in "Subtype" category
# and is out of robbery victims of interest

reduced_data <- 
  raw_data %>% 
  select(
    "Index_" , "ReportedYear" , "Subtype" , "Sex" , "AgeGroup" , "AgeCohort" , "Count_"
  )

# rm(raw_data)
         

#### Clean data ####

# We remove crime victim cases which "Sex" and "Agecohort" are not available
# and replace "F" with "Female" and "M" with "Male" in Sex column for better understanding

cleaned_data <- 
  reduced_data %>% 
  filter(Sex != "U" , AgeCohort != "Unknown")

cleaned_data$Sex <- ifelse( cleaned_data$Sex ==  "F", "Female", "Male")

#### Save cleaned data ####

write_csv(cleaned_data,"inputs/data/toronto_crime_victims_data.csv")








