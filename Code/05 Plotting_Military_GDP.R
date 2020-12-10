## This script plots the Military_GDP graph

require(tidyverse)
require(ggthemes)
require(gganimate)
require(gifski)
require(wesanderson)

military_GDP <- read.csv("military_GDP.csv")

## Reorder the graph by asigning factors
military_GDP$Country <- factor(military_GDP$Country,levels=c("China","Taiwan", "Korea, South","Japan", "USA"))

# create a static graph
military_GDP_graph <- ggplot(military_GDP, 
                             aes(year, Military_GDP, color=Country))+
  geom_point(alpha=0.7,
             size=3)+
  geom_line(size=2, alpha=0.2)+
  labs(title = "Military Expenditure as Percentage of GDP",
       x="Year",
       y="Percentage of GDP(%)",
       caption = "Source: SIPRI")+
  
  #change colors
  scale_color_manual(values=wes_palette(n=5,name="Darjeeling1"))+
  theme_solarized()+
  theme(legend.title = element_text(size=11),
        plot.title=element_text(face="bold"))+
  
  #add vertical lines to improve presentation
  geom_vline(xintercept = c(1950,1970,1990,2010),
             colour="grey",
             linetype="longdash")


# make the graph dynamic 
military_GDP_animation <- military_GDP_graph+
  transition_reveal(year)+
  shadow_wake(wake_length = 0.1)
# add a shadow tail

# set the pattern of animation
animate(military_GDP_animation, 
        height=600, 
        width=800, 
        fps=30, 
        duration=10,
        end_pause=60
        ,res=100)

# save the animation as gif
anim_save("GDP_Military.gif")