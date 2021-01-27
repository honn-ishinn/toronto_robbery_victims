#### Preamble ####
# Purpose: Use opendatatoronto to get Toronto crime victims data
# Author: Hong Shi
# Contact: lancehong.shi@mail.utoronto.ca
# Date: 26 January 2021
# Pre-requisites: None
# TODOs: -


#### Workspace set-up ####

# install.packages("opendatatoronto")
library(opendatatoronto)
library(tidyverse)

#### Get data ####

all_data <- 
  opendatatoronto::search_packages("Police Annual Statistical Report - Victims of Crime") %>% 
  opendatatoronto::list_package_resources() %>% 
  filter( name == "Victims of Crime (2014-2019)") %>% # This is the data we are interested in.
  select(id) %>% 
  opendatatoronto::get_resource()


#### Save raw data ####
write_csv(all_data,"inputs/data/raw_data.csv")
