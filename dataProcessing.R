library(ggplot2)
library(dplyr)

setwd("/Users/vivi/Dropbox/DataScience/Developing-Data-Products/Developing-Data-Prodects-Course-Project")

## Load the iMDB movie data 
data("movies")

## Preliminary Data Exploration
summary(movies)
table(movies$year)

# Restrict analysis to 1985-2004 data 
MData = movies %>%
        filter(year<=2004, year>=1985) %>%
        select(1:5, 17:24)

MData2 = reshape(MData, timevar="Genre",
                 varying=c("Action", "Animation", "Comedy", "Drama", "Documentary",
                           "Romance", "Short"), 
            v.names="Genre_flg", 
            times=c("Action", "Animation", "Comedy", "Drama", "Documentary",
                    "Romance", "Short"), 
            direction = "long")

MData2 = MData2 %>%
        filter(Genre_flg==1)

MData2$mpaa = as.character(MData2$mpaa)

#MData$mpaa = as.character(MData$mpaa)
#MData$mpaa[is.na(MData$mpaa)] = rep("Missing", sum(is.na(MData$mpaa)))



