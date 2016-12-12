library(shiny)
library(leaflet)
library(grid)
library(dplyr)
library(ggmap)
library('shinythemes')
require(twitteR)
library(devtools)
library(magrittr)
library(syuzhet)
library(SnowballC)
library('wordcloud')
library(tm)
library(streamR)
library(stringr)
library(shinythemes)

ui <-
  fluidPage(theme = shinytheme('superhero'),
    h1("The Whirlwind of our New President Elect"),
    p(em("Designed by Alex Orfanos")),
    br(),
    tabsetPanel(
     tabPanel('Word Cloud Page',
              sidebarLayout(
                sidebarPanel( 
                  selectInput('coast', 'Area:', c('East' = 'East', 'West' = 'West', 'Central' = 'Central', 'Rest of World' = 'Rest of World')),
                  sliderInput('max', "Maximum Number of Words:",
                                         min = 1, max = 200, value = 20))
                ,
              mainPanel(
                plotOutput('plot'),
                'This is a wordcloud where we can visualize what people were talking about around the world having to do with Donald Trump. If you look at the news reports regarding Trump around Deceber 10th, 2016, you will see how these word clouds reflect the times. '
              ))
              ),
     tabPanel('Interactive Map Page',
              sidebarLayout(
                sidebarPanel( h1("This is a map of Tweets"),
                              'This map is showing us clusters of where people around the world are tweeting about Donald Trump. Click on the icons to zoom in further and see where commentary is concentrated.'
                )
                ,
                mainPanel(
                  leafletOutput('trumpmap')
                ))),
     tabPanel('Sentiment Analysis',
              sidebarLayout(
                sidebarPanel("Here is where I am putting the sentiment analysis of all the donald trump tweets. This is just a basic sentiment analysis. We know that Donald Trump is a very volatile character so this graph could show us one of two things. Either much of the world has leveled out on their opinions of Trump (not likely), or the sentiment analysis packages avaliable through R are not as good yet at analyizing political rhetoric, considering much of it is tounge in cheek."),
                mainPanel(plotOutput('histogram'))
              ))
    )
    )