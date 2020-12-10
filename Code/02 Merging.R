##This scrip mearges datasets to create a large dataframe on Taiwan

#load packages
require(tidyverse)

# load the datasets
df_taibao <- read.csv("df_taibao.csv")
df_taidu <- read.csv("df_taidu.csv")

#use full_join to creat a large dataframe
df_Taiwan <- full_join(df_taibao,df_taidu)

#creat new columns
df_Taiwan<- df_Taiwan %>% 
  group_by(Date) %>% 
  mutate("Daily_Total_Frequency"=n()) %>% 
  #cont the daily total frequency
  mutate("Year"=lubridate::year(Date),
         "Month"=lubridate::month(Date),
         "Day"=lubridate::day(Date))
#creat separate columns on date information
# write the csv file
write.csv(df_Taiwan,"df_Taiwan.csv")
