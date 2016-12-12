
server <- function(input, output, session) {
  output$trumpmap <- renderLeaflet({
    leaflet() %>% addTiles() %>% addMarkers(lng = full_data$lon, lat = full_data$lat, clusterOptions = markerClusterOptions())  })

  
  output$plot <- renderPlot({
    trumpcorpus <- Corpus(VectorSource(as.vector(full_data$clean_tweet[full_data$coast == input$coast])))
    trumpcorpus <- tm_map(trumpcorpus, PlainTextDocument)
    extra_words <- c('get', 'know', 'donald', 'the', 'just', 'will')
    trumpcorpus <- tm_map(trumpcorpus, removeWords, c(extra_words, stopwords('english')))
    trumpcorpus <- tm_map(trumpcorpus, stemDocument)
    pal <- brewer.pal(4, "PRGn")
    wordcloud(trumpcorpus, max.words = input$max, rot.per = 0, scale = c(5,.1), random.order = FALSE, colors = pal)
  })
  output$histogram <- renderPlot({
    qplot(full_data$sent, geom = 'histogram', xlim = c(-2,2))
  })
  
  
}

