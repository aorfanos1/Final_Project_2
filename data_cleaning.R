#####These are the data cleaning steps that I took
world_tweets <- parseTweets('east_coast_data_trump.json', simplify = TRUE)

##some early steps for data cleaning
non_na_world <- filter(world_tweets, !is.na(world_tweets$location))
non_na_english <- filter(non_na_world, non_na_world$lang == 'en')
retweat_index <- grep('RT', non_na_english$text)
non_retweets <- non_na_english[-retweat_index,]
non_retweets <- non_retweets %>% select(c(text, created_at, lang, location))

##Getting the first batch of geocodes
non_retweets_first <- non_retweets[1:2400,]
# trump_geocodes <- geocode(non_retweets_first$location, messaging = FALSE)
trump_geocodes <- read.csv('geocodes.csv')
trump_geocodes <- trump_geocodes %>% select(-X)
full_data <- bind_cols(non_retweets_first, trump_geocodes)
full_data <- subset(full_data, !is.na(full_data$lon))


#
#getting the second batch of geocodes
# non_retweets_second <- non_retweets[2401:4800,]
# trump_geocodes_2 <- geocode(non_retweets_second$location, messaging = F)
# non_retweets_second_geo <- bind_cols(non_retweets_second, trump_geocodes_2)
# second_geo_data <- subset(non_retweets_second_geo, !is.na(non_retweets_second_geo$lon))
# 
# full_data <- bind_rows(first_geo_data, second_geo_data)

#Text without URLS
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)

no_urls <- removeURL(full_data$text)
#No refrences to other screen names
no_names <- str_replace_all(no_urls,"@[a-z,A-Z]*","")   

#Found code for cleaning tweets
clean_tweet = gsub("&amp", "", no_names)
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
clean_tweet = gsub("@\\w+", "", clean_tweet)
clean_tweet = gsub("[[:punct:]]", "", clean_tweet)
clean_tweet = gsub("[[:digit:]]", "", clean_tweet)
clean_tweet = gsub("http\\w+", "", clean_tweet)
clean_tweet = gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", "", clean_tweet) 
clean_tweet = gsub('\n', ' ', clean_tweet)
clean_tweet = tolower(clean_tweet)
clean_tweet = gsub('trump', '', clean_tweet) 

##combined the master data with the clean tweets
full_data <- bind_cols(full_data, as.data.frame(clean_tweet))


#Adding a coast classifier
full_data$coast[full_data$lon < -105] <- "West"
full_data$coast[(full_data$lon > -105 )  & (full_data$lon < -80) ] <- "Central"
full_data$coast[(full_data$lon > -80 )  & (full_data$lon < -65) ] <- "East"
full_data$coast[(full_data$lon > -65 )] <- 'Rest of World'


# ##Wordcloud stuff
#  trumpcorpus <- Corpus(VectorSource(full_data$clean_tweet))
#  trumpcorpus <- tm_map(trumpcorpus, PlainTextDocument)
#  extra_words <- c('get', 'know', 'donald', 'the', 'just', 'will')
#  trumpcorpus <- tm_map(trumpcorpus, removeWords, c(extra_words, stopwords('english')))
#  trumpcorpus <- tm_map(trumpcorpus, stemDocument)
# 
#  wordcloud((trumpcorpus), max.words = 10, rot.per = 0, scale = c(5,.1), random.order = FALSE, colors = pal)
# 

###Getting sentiment scores

sent <- get_sentiment(clean_tweet)
full_data <- bind_cols(full_data, as.data.frame(sent))

