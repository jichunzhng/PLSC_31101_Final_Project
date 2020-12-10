# This script makes plots based on the `Taiwan` dataframe

#load packages
require(lubridate)
require(tidyverse)
require(gghighlight)
require(ggthemes)
require(wesanderson)
require(ggpubr)

#load the data

df_Taiwan <- read.csv("df_Taiwan.csv")
class(df_Taiwan$Date)
# notice that when reloading the dataframe from csv files
#the class of date information  turns back to character
df_Taiwan$Date <-ymd(df_Taiwan$Date) 
# reset the class to date by using lubridate

# plot the logged version

Logged <- df_Taiwan %>% 
  ggplot(aes(Date,log10(Status_Frequency),color=Status,
             fill=Status))+
  geom_count(alpha=0.8, show.legend=F)+
  #use geom_count to make the size of dots reflective of frequency
  geom_point()+
  #use geom_point to filter redundent legend
  scale_color_manual(values=c("red3", "darkgreen"))+
  # change colors
  
  labs(title="Taiwan Affairs Office Attitude towards Taiwan(Logged)",
       subtitle="Highlightening Daily News Frequency>1",
       x= "News Date",
       y="Daily News Frequency(Logged)",
       caption = "Source:http://www.gwytb.gov.cn/")+
  # change label information
  facet_grid(.~Status)+
  #split the graph
  gghighlight(Status_Frequency>1, 
              label_key = Status, 
              use_direct_label = F)+
  # use gghighlight to improve presentation
  theme_classic(base_size = 12,
                base_line_size = 0.5,
                base_rect_size = 0.5)+
  theme(legend.title = element_text(size=11),
        plot.title=element_text(face="bold"))
# revise the theme settings

# repeat the above process to create an unlogged version
Unlogged <- df_Taiwan %>% 
  ggplot(aes(Date,Status_Frequency,color=Status,
             fill=Status))+
  geom_count(alpha=0.8, show.legend=F)+
  geom_point()+
  scale_color_manual(values=c("red3", "darkgreen"))+
  labs(title="Taiwan Affairs Office Attitude towards Taiwan",
       subtitle="Highlightening Daily News Frequency>1",
       x= "News Date",
       y="Daily News Frequency",
       caption = "Source:http://www.gwytb.gov.cn/")+
  facet_grid(.~Status)+
  gghighlight(Status_Frequency>1, 
              label_key = Status, 
              use_direct_label = F)+
  theme_classic(base_size = 12,
                base_line_size = 0.5,
                base_rect_size = 0.5)+
  theme(legend.title = element_text(size=11),
        plot.title=element_text(face="bold"))

#use ggarrange to put plots into the same graph
ggarrange(Unlogged,
          Logged,
          nrow=2,ncol=1,
          common.legend = T,
          legend = "bottom")

# save the zoomed version of the graph in question by resetting width and height
ggsave("Taiwan Affairs Office Attituds.png", plot=last_plot(),
       width = 7,
       height = 6,
       limitsize = FALSE)

