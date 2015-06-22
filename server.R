library(shiny)
library(dplyr)
require(rCharts)
library(ggplot2)

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
names(MData2)[1] = c("MovieTitle")

# Get movie genre
genres = sort(unique(MData2$Genre))
# Get unique MPAA rating
mprate = sort(unique(MData2$mpaa))

# Create Functions
groupByYear = function(dt, minYear, maxYear, genres, mprate) {
        result = dt %>% 
                filter(year >= minYear, year <= maxYear,
                        Genre %in% genres, mpaa %in% mprate) 
        return(result)
}

groupByYearAgg = function(dt, minYear, maxYear, genres, mprate) {
        dt = groupByYear(dt,minYear, maxYear, genres, mprate)
        result = dt %>%
                group_by(year) %>%
                summarise(Total = n()) %>%
                arrange(year)
        return(result)
}

groupByYearPlot = function(dt) {
        totalByYear = nPlot(Total ~ year, data = dt, type = "multiBarChart",
                            width = 650)
        totalByYear$chart(margin = list(left = 100))
        totalByYear$yAxis(axisLabel = "Number of Movies")
        totalByYear$xAxis(axisLabel = "Year")
        totalByYear
}

shinyServer(
        function(input, output){
                
                # Genre selection
                values1 = reactiveValues()
                values1$genres = genres
                
                output$genreControl = renderUI({
                        checkboxGroupInput('genres', 'Movie Genres:', 
                                           genres, selected = values1$genres)
                })
                
                observe({
                        if(input$selectAll1 == 0) return()
                        values1$genres = genres
                })
                
                observe({
                        if(input$clearAll1 == 0) return()
                        values1$genres = c()
                })
                
                # MPAA rating selection
                values2 = reactiveValues()
                values2$mprate = mprate
                
                output$mprateControl = renderUI({
                        checkboxGroupInput('mprate', 'MPAA Ratings:', 
                                           mprate, selected = values2$mprate)
                })
                
                observe({
                        if(input$selectAll2 == 0) return()
                        values2$mprate = mprate
                })
                
                observe({
                        if(input$clearAll2 == 0) return()
                        values2$mprate = c()
                })
                
                # Total movie by year
                FinalData = reactive({
                        groupByYear(MData2,input$timeline[1], input$timeline[2],
                                    input$genres, input$mprate)
                })
                

                dataAgg = reactive({
                        groupByYearAgg(MData2,input$timeline[1], input$timeline[2],
                                       input$genres, input$mprate)
                })
                
                output$totalByYear = renderChart({
                        plot(year, Total, dataAgg())
                })
                
                output$dataAgg = renderDataTable({
                        dataAgg()
                })
                
        }
)


