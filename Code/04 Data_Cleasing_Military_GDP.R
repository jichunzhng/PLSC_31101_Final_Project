##This script performs data cleasing for the military_GDP graph

#load packages
require(readxl)
require(tidyverse)

#load the raw dataset
military_GDP <- read_excel("data/SIPRI_Data.xlsx",
                           sheet="Share of GDP")
#delete the first 4 columns
military_GDP <- military_GDP[-c(1:4),]

#make the first column the name column
colnames(military_GDP) <- as.character(unlist(military_GDP[1,]))
military_GDP <- military_GDP[-1,]

# get useful columns and rows 
military_GDP <- military_GDP %>% 
  select(-Notes) %>% 
  gather("year","Military_GDP",c(-Country)) %>% 
  filter(Country=='China'|
           Country=='USA'|
           Country=='Japan'|
           Country=='Taiwan'|
           Country=='Korea, South'
  )

# perform basic calculation to improve presentation
military_GDP$Military_GDP <- as.numeric(military_GDP$Military_GDP)*100 
military_GDP$year <- as.integer(military_GDP$year)
#change the class of `year` to integer 
military_GDP <- military_GDP %>% 
  filter(!is.na(Military_GDP))
#remove NA values

write.csv(military_GDP, "military_GDP.csv")

