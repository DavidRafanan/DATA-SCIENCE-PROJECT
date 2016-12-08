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

#save a copy as backup
saveRDS(twLJ, './NBA_TweetsLakersJazz.RDS')
saveRDS(twLM, './NBA_TweetsLakersMemphis.RDS')
saveRDS(twLB, './NBA_TweetsLakersBulls.RDS')

#loading from file 
twLJ = readRDS('./NBA_TweetsLakersJazz.RDS')
twLM = readRDS('./NBA_TweetsLakersJazz.RDS')
twLB = readRDS('./NBA_TweetsLakersBulls.RDS')

#Convert to our timezone and refine the filter to game start and end time 
#LakersVJazz Starttime: 7:30pm
LakersJazz = twListToDF(twLJ)
options(tz="America/New York")
LakersJazz$created <- with_tz(LakersJazz$created, 'America/New York')
LiveTweetsLakersJazz<- subset(LakersJazz, format(LakersJazz$created, "%H:%M:$S") > "19:30:00" & format(LakersJazz$created, "%H:%M:$S") < "22:45:00")

#LakersVMemphisGrizzly's Starttime: 8:00pm
LakersMemphis = twListToDF(twLM)
LakersMemphis$created <- with_tz(LakersMemphis$created, 'America/New York')
LiveTweetsLakersMemphis<- subset(LakersMemphis, format(LakersMemphis$created, "%H:%M:$S") > "20:00:00" & format(LakersMemphis$created, "%H:%M:$S") < "23:00:00")

#LakersVChicagoBulls Starttime: 8:00pm
LakersBulls = twListToDF(twLB)
LakersBulls$created <- with_tz(LakersBulls$created, 'America/New York')
LiveTweetsLakersBulls <- subset(LakersBulls, format(LakersBulls$created, "%H:%M:$S") > "20:00:00" & format(LakersBulls$created, "%H:%M:$S") < "23:00:00")

#setting up corpus
basketballTerms= read.table("Basketball corpus.txt")
basketballVector= VectorSource(basketballTerms)
basketballCorpus= Corpus(basketballVector)
