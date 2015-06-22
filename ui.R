# Load packages
library(shiny)
library(dplyr)
require(rCharts)
library(ggplot2)



shinyUI(
        pageWithSidebar(
                # Application title
                headerPanel("iMDB Movie Database 1985-2004"),
                
                sidebarPanel(
                        # Timeline control
                        sliderInput("timeline",
                                    "Timeline:",
                                    min = 1985,
                                    max = 2004,
                                    value = c(1985, 2004)),
                        
                        # Genre control
                        uiOutput("genreControl"),
                        
                        actionButton(inputId = "clearAll1",
                                     label = "Clear All",
                                     icon = icon("square-o")),
                        
                        actionButton(inputId = "selectAll1",
                                     label = "Select All",
                                     icon = icon("check-square-o")),
                        
                        # MPAA rating control
                        uiOutput("mprateControl"),
                        
                        actionButton(inputId = "clearAll2",
                                     label = "Clear All",
                                     icon = icon("square-o")),
                        
                        actionButton(inputId = "selectAll2",
                                     label = "Select All",
                                     icon = icon("check-square-o"))
                ),
                
                mainPanel(
                        h4('Total Number of Movies Released'),
                        #plotOutput("totalByYear"),
                        #showOutput("totalByYear", "nvd3"),
                        #htmlOutput("totalByYear"),
                        #chartOutput("totalByYear", lib = NULL),
                        dataTableOutput("dataAgg")
                        #tableOutput("testtable") 
                )  
        )
)

