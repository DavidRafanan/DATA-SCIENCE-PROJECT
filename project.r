
###AFTER INSTALLING THE PACKAGE DO NOT CONNECT TO TWITTER TO RETRIEVE THE TWEETS INSTEAD START THE CODE FROM READRDS

install.packages('lsa')
??install.packages('twitteR')
install.packages('tm')
install.packages('ngram')
install.packages('wordcloud')
install.packages("SnowballC")
install.packages('lubridate')
library(lsa)
library(SnowballC)
library(wordcloud)
library(ngram)
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

##Retrieve the tweets during the game -DO NOT RUN!!!!! LOAD FROM RDS!!!!! 
twLJ = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-05', until = '2016-12-06')
twLM = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-03', until = '2016-12-04')
twLB = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-11-30', until = '2016-12-01')
twLS = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-09', until = '2016-12-10')
twLK = searchTwitter('Los Angeles Lakers', n = 1000, since = '2016-12-11', until = '2016-12-12')
#save a copy as backup # DO NOT RUN LOAD FROM RDS
saveRDS(twLJ, './NBA_TweetsLakersJazz.RDS')
saveRDS(twLM, './NBA_TweetsLakersMemphis.RDS')
saveRDS(twLB, './NBA_TweetsLakersBulls.RDS')
saveRDS(twLS, './NBA_TweetsLakersSuns.RDS')
saveRDS(twLK, './NBA_TweetsLakersKnicks.RDS')

##START THE CODE HERE#loading from file ###START OUR CODE HERE
twLJ = readRDS('./NBA_TweetsLakersJazz.RDS')
twLM = readRDS('./NBA_TweetsLakersJazz.RDS')
twLB = readRDS('./NBA_TweetsLakersBulls.RDS')
twLS = readRDS('./NBA_TweetsLakersSuns.RDS')
twLK = readRDS('./NBA_TweetsLakersKnicks.RDS')

#Convert to our timezone and refine the filter to the tweets during the game start and end time 
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

#LakersVNewYorkKnicks Starttime: 10:30pm
LakersKnicks = twListToDF(twLK)
options(tz="America/New York")
LakersKnicks$created <- with_tz(LakersKnicks$created, 'America/New York')
LiveTweetsLakersKnicks <- subset(LakersKnicks, format(LakersKnicks$created, "%H:%M:$S") > "21:00:00" & format(LakersKnicks$created, "%H:%M:$S") < "24:00:00")

#Remove emoji's and other unknown characters from the dataset
LiveTweetsLakersSuns$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersBulls$text <- sapply(LiveTweetsLakersBulls$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersMemphis$text <- sapply(LiveTweetsLakersMemphis$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersJazz$text <- sapply(LiveTweetsLakersJazz$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersKnicks$text <- sapply(LiveTweetsLakersKnicks$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))

# Make all the tweets lower case to make n-grams analysis easier
LiveTweetsLakersSuns$text <-sapply(LiveTweetsLakersSuns$text, tolower)
LiveTweetsLakersBulls$text <-sapply(LiveTweetsLakersBulls$text, tolower)
LiveTweetsLakersMemphis$text <-sapply(LiveTweetsLakersMemphis$text, tolower)
LiveTweetsLakersJazz$text <-sapply(LiveTweetsLakersJazz$text, tolower)
LiveTweetsLakersKnicks$text <-sapply(LiveTweetsLakersKnicks$text, tolower)

#setting up corpus for basket ball terms
basketballTerms= read.table("Basketball corpus.txt")
basketballVector= VectorSource(basketballTerms)
basketballCorpus= Corpus(basketballVector)


# Vizualization of the tweets via wordclouds
# Create corpus for each of the five games 
corpusLJ =Corpus(VectorSource(LiveTweetsLakersJazz$text))
corpusLS =Corpus(VectorSource(LiveTweetsLakersSuns$text))
corpusLB =Corpus(VectorSource(LiveTweetsLakersBulls$text))
corpusLM =Corpus(VectorSource(LiveTweetsLakersMemphis$text))
corpusLK =Corpus(VectorSource(LiveTweetsLakersKnicks$text))

# Remove stopwords such as: the, is, at, which, and on. This is to increase performance of our process.
corpusLJ=tm_map(corpusLJ,function(x) removeWords(x,stopwords("english")))
corpusLS=tm_map(corpusLS,function(x) removeWords(x,stopwords("english")))
corpusLB=tm_map(corpusLB,function(x) removeWords(x,stopwords("english")))
corpusLM=tm_map(corpusLM,function(x) removeWords(x,stopwords("english")))
corpusLK=tm_map(corpusLK,function(x) removeWords(x,stopwords("english")))

# convert corpus to a Plain Text Document so we can vizualize using wordcloud
corpusLJ=tm_map(corpusLJ,PlainTextDocument)

#display settings
par(mfrow=c(1,1))
col=brewer.pal(6,"Dark2")

#Wordcloud: LakersVJazz
set.seed(2245)
wordcloud(corpusLJ, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

#Wordcloud: LakersBulls
set.seed(1550)
corpusLB=tm_map(corpusLB,PlainTextDocument)
wordcloud(corpusLB, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

#Wordcloud: LakersSuns
set.seed(3211)
corpusLS=tm_map(corpusLS,PlainTextDocument)
wordcloud(corpusLS, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

#Wordcloud: LakersMemphis
set.seed(2111)
corpusLM=tm_map(corpusLM,PlainTextDocument)
wordcloud(corpusLM, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

#Wordcloud: LakersKnicks
set.seed(4241)
corpusLK=tm_map(corpusLK,PlainTextDocument)
wordcloud(corpusLK, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)


#Create a frequency table of terms used in tweets
dtmLakersJazz<- TermDocumentMatrix(corpusLJ)
m <- as.matrix(dtmLakersJazz)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsLakersJazz <- data.frame(word = names(v),freq=v)
head(freqTermsLakersJazz, 20)

dtmLakersMemphis<- TermDocumentMatrix(corpusLM)
m <- as.matrix(dtmLakersJazz)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsLakersMemphis <- data.frame(word = names(v),freq=v)
head(freqTermsLakersMemphis, 20)

dtmLakersBulls<- TermDocumentMatrix(corpusLB)
m <- as.matrix(dtmLakersBulls)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsLakersBulls <- data.frame(word = names(v),freq=v)
head(freqTermsLakersBulls, 20)

dtmLakersSuns<- TermDocumentMatrix(corpusLS)
m <- as.matrix(dtmLakersSuns)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsLakersSuns <- data.frame(word = names(v),freq=v)
head(freqTermsLakersSuns, 20)

dtmLakersKnicks<- TermDocumentMatrix(corpusLK)
m <- as.matrix(dtmLakersKnicks)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsLakersKnicks <- data.frame(word = names(v),freq=v)
head(freqTermsLakersKnicks, 20)

