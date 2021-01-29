#### Preamble ####
# Purpose: Use opendatatoronto to get Toronto crime victims data
# Author: Hong Shi
# Date: 29 January 2021
# Contact: lancehong.shi@mail.utoronto.ca
# License: MIT
# Pre-requisites: None



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
