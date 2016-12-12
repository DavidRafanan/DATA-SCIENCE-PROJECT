install.packages('lsa')
install.packages('twitteR')
install.packages('tm')
install.packages('lubridate')
library(lsa)
library(twitteR)
library(tm)
library(lubridate)
lapply(c('twitteR', 'ggplot2', 'lubridate', 'qdap', 'tm'), library, character.only = TRUE)
theme_set(new = theme_bw())
source('../../R/twitterAuth.R')
set.seed(9561)
key <- 'jPEdMwCjSY01HmGCTFc9IaTik'
secret <- 'mkO1Dz9fv5MpmQhDPGBxzzgwV96tHUoCkxazs4TY501OrNuvfv'
access_token <- '805992778031366144-pMoJ8a4cWPI1VldJ6ZUk2RQ8r7Ztvla'
access_secret <- 'dguZ2IxpPi3BJIagx0T58SkN5sS6dQS00D1nVZMoYd9BZ'

setup_twitter_oauth(key, secret, access_token, access_secret)

##Retrieve the tweets during the game 
twLJ = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-05', until = '2016-12-06')
twLM = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-03', until = '2016-12-04')
twLB = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-11-30', until = '2016-12-01')
twLS = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-09', until = '2016-12-10')

#save a copy as backup
saveRDS(twLJ, './NBA_TweetsLakersJazz.RDS')
saveRDS(twLM, './NBA_TweetsLakersMemphis.RDS')
saveRDS(twLB, './NBA_TweetsLakersBulls.RDS')
saveRDS(twLS, './NBA_TweetsLakersBulls.RDS')

#loading from file 
twLJ = readRDS('./NBA_TweetsLakersJazz.RDS')
twLM = readRDS('./NBA_TweetsLakersJazz.RDS')
twLB = readRDS('./NBA_TweetsLakersBulls.RDS')
twLS = readRDS('./NBA_TweetsLakersBulls.RDS')

#Convert to our timezone and refine the filter to game start and end time 
#LakersVJazz Starttime: 7:30pm
LakersJazz = twListToDF(twLJ)
options(tz="America/New York")
LakersJazz$created <- with_tz(LakersJazz$created, 'America/New York')
LiveTweetsLakersJazz<- subset(LakersJazz, format(LakersJazz$created, "%H:%M:$S") > "19:30:00" & format(LakersJazz$created, "%H:%M:$S") < "22:45:00")

#LakersVMemphisGrizzly's Starttime: 8:00pm
LakersMemphis = twListToDF(twLM)
options(tz="America/New York")
LakersMemphis$created <- with_tz(LakersMemphis$created, 'America/New York')
LiveTweetsLakersMemphis<- subset(LakersMemphis, format(LakersMemphis$created, "%H:%M:$S") > "20:00:00" & format(LakersMemphis$created, "%H:%M:$S") < "23:00:00")

#LakersVChicagoBulls Starttime: 8:00pm
LakersBulls = twListToDF(twLB)
options(tz="America/New York")
LakersBulls$created <- with_tz(LakersBulls$created, 'America/New York')
LiveTweetsLakersBulls <- subset(LakersBulls, format(LakersBulls$created, "%H:%M:$S") > "20:00:00" & format(LakersBulls$created, "%H:%M:$S") < "23:00:00")

#LakersVPheonixSuns Starttime: 10:30pm
LakersSuns = twListToDF(twLS)
options(tz="America/New York")
LakersSuns$created <- with_tz(LakersSuns$created, 'America/New York')
LiveTweetsLakersSuns <- subset(LakersSuns, format(LakersSuns$created, "%H:%M:$S") > "21:30:00" & format(LakersSuns$created, "%H:%M:$S") < "24:00:00")

#Remove emoji's and other unknown characters from the dataset
LiveTweetsLakersSuns$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
LiveTweetsLakersBulls$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
LiveTweetsLakersMemphis$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
LiveTweetsLakersJazz$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "latin1", "ASCII", sub=""))

# Make all the tweets lower case to make n-grams analysis easier
LiveTweetsLakersSuns$text <-sapply(LiveTweetsLakersSuns$text, tolower)
LiveTweetsLakersBulls$text <-sapply(LiveTweetsLakersSuns$text, tolower)
LiveTweetsLakersMemphis$text <-sapply(LiveTweetsLakersSuns$text, tolower)
LiveTweetsLakersJazz$text <-sapply(LiveTweetsLakersSuns$text, tolower)

#setting up corpus
basketballTerms= read.table("Basketball corpus.txt")
basketballVector= VectorSource(basketballTerms)
basketballCorpus= Corpus(basketballVector)
