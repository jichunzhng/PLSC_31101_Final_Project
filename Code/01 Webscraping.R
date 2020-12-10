##This scrip creates functions for webscraping
##and gathers information from the website.

#load packages

require(rvest)
require(tidyverse)
require(stringr)
require(lubridate)

#get news information on `Taiwan Independence Advocates`

get_news_taidu <- function(i){
  
  basic_url <- paste0("http://zhannei.baidu.com/cse/search?q=%E5%8F%B0%E7%8B%AC&p=",i,"&s=17966175311737985339&stp=1&nsid=0&entry=1")
  #set page number = i
  
  web <- basic_url %>% 
    read_html(encoding='utf-8') 
  #load url information
  
  
  title <- web %>% html_nodes('body') %>% 
    html_nodes("div[class='result f s0']") %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_text()
  #get news title
  
  news_link <-web %>% 
    html_nodes("div[class='result f s0']") %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_attr('href')
  #get news link
  
  date <- web %>% 
    html_nodes(".c-showurl") %>% 
    html_text() %>% 
    str_trim() %>% 
    str_sub(-10,-1) %>% #stringr
    ymd()##lubridate
  #use stringr to collect date info from news links
  #use lubridate to transform the info to data type
  
  taidu_df <- data.frame("Title"=title,"News_Link"=news_link,"Date"=date)
  # create a dataframe
  
  return(taidu_df)
}
# Repeat the above process to
#get news information on "Taiwan Compatriots"

get_news_taibao <- function(p){ 
  basic_url <- paste0("http://zhannei.baidu.com/cse/search?q=%E5%8F%B0%E8%83%9E&p=",p,"&s=17966175311737985339&stp=1&nsid=0&entry=1")
  
  web <- basic_url %>% 
    read_html(encoding = 'utf-8')
  
  title <- web %>% html_nodes('body') %>% 
    html_nodes("div[class='result f s0']") %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_text()
  
  news_link <-web %>% 
    html_nodes("div[class='result f s0']") %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_attr('href')
  
  date <- web %>% 
    html_nodes(".c-showurl") %>% 
    html_text() %>% 
    str_trim() %>% 
    str_sub(-10,-1) %>% 
    ymd()
  
  taibao_df <- data.frame("Title"=title,"News_Link"=news_link,"Date"=date)
  
  return(taibao_df)
}
  


#Mapping

df_taidu <- map_df(0:21,get_news_taidu)
df_taibao <-map_df(0:74, get_news_taibao)

#create dataset
df_taidu <- df_taidu %>% 
  mutate(Status="Independence Advocates") %>%
  #creare the `Status`column for polting
  distinct(News_Link,.keep_all = TRUE) %>%
  #filter repeated values
  group_by(Date) %>%
  mutate("Status_Frequency"=n())
# count frequency

# repeat the above process
df_taibao <- df_taibao %>% 
  mutate(Status="Compatriots") %>% 
  distinct(News_Link,.keep_all = TRUE) %>% 
  group_by(Date)%>% 
  mutate("Status_Frequency"=n())

#write csv files

write.csv(df_taidu,"df_taidu.csv")
write.csv(df_taibao,"df_taibao.csv")

