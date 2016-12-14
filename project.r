
###AFTER INSTALLING THE PACKAGE DO NOT CONNECT TO TWITTER TO RETRIEVE THE TWEETS INSTEAD START THE CODE FROM READRDS

install.packages('lsa')
install.packages('twitteR')
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
lapply(c('twitteR', 'ggplot2', 'lubridate', 'tm'), library, character.only = TRUE)
theme_set(new = theme_bw())
source('../../R/twitterAuth.R')
set.seed(9561)
key <- 'jPEdMwCjSY01HmGCTFc9IaTik'
secret <- 'mkO1Dz9fv5MpmQhDPGBxzzgwV96tHUoCkxazs4TY501OrNuvfv'
access_token <- '805992778031366144-pMoJ8a4cWPI1VldJ6ZUk2RQ8r7Ztvla'
access_secret <- 'dguZ2IxpPi3BJIagx0T58SkN5sS6dQS00D1nVZMoYd9BZ'
options(tz="America/New York")
setup_twitter_oauth(key, secret, access_token, access_secret)

##Retrieve the tweets during the game -DO NOT RUN!!!!! LOAD FROM RDS!!!!! 
twLJ = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-05', until = '2016-12-06')
twLM = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-03', until = '2016-12-04')
twLB = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-11-30', until = '2016-12-01')
twLS = searchTwitter('Los Angeles Lakers', n = 3000, since = '2016-12-09', until = '2016-12-10')
twLK = searchTwitter('Los Angeles Lakers', n = 1000, since = '2016-12-11', until = '2016-12-12')

##OKLAHOMA CITY THUNDER TWEETS #OKCThunder
twOP = searchTwitter('OKCThunder', n = 3000, since = '2016-12-13', until = '2016-12-14')
twOC = searchTwitter('OKCThunder', n = 3000, since = '2016-12-11', until = '2016-12-12')

#save a copy as backup # DO NOT RUN LOAD FROM RDS
saveRDS(twLJ, './NBA_TweetsLakersJazz.RDS')
saveRDS(twLM, './NBA_TweetsLakersMemphis.RDS')
saveRDS(twLB, './NBA_TweetsLakersBulls.RDS')
saveRDS(twLS, './NBA_TweetsLakersSuns.RDS')
saveRDS(twLK, './NBA_TweetsLakersKnicks.RDS')

#oklahoma
saveRDS(twOP, './NBA_TweetsThunderPortland.RDS')
saveRDS(twOC, './NBA_TweetsThunderCeltics.RDS')


##START THE CODE HERE#loading from file ###START OUR CODE HERE
twLJ = readRDS('./NBA_TweetsLakersJazz.RDS')
twLM = readRDS('./NBA_TweetsLakersJazz.RDS')
twLB = readRDS('./NBA_TweetsLakersBulls.RDS')
twLS = readRDS('./NBA_TweetsLakersSuns.RDS')
twLK = readRDS('./NBA_TweetsLakersKnicks.RDS')

twOP = readRDS('./NBA_TweetsThunderPortland.RDS')
twOC = readRDS('./NBA_TweetsThunderCeltics.RDS')

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

#OklahomaVPortland Starttime: 10:30pm
ThunderPort = twListToDF(twOP)
ThunderPort$created <- with_tz(ThunderPort$created, 'America/New York')
LiveTweetsThunderPort<- subset(ThunderPort, format(ThunderPort$created, "%H:%M:$S") > "22:30:00" & format(ThunderPort$created, "%H:%M:$S") < "24:00:00")

#OklahomaVCeltics Starttime: 7:00pm
ThunderCeltics = twListToDF(twOC)
ThunderCeltics$created <- with_tz(ThunderCeltics$created, 'America/New York')
LiveTweetsThunderCeltics<- subset(ThunderCeltics, format(ThunderCeltics$created, "%H:%M:$S") > "19:00:00" & format(ThunderCeltics$created, "%H:%M:$S") < "22:30:00")

#Remove emoji's and other unknown characters from the dataset
LiveTweetsLakersSuns$text <- sapply(LiveTweetsLakersSuns$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersBulls$text <- sapply(LiveTweetsLakersBulls$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersMemphis$text <- sapply(LiveTweetsLakersMemphis$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersJazz$text <- sapply(LiveTweetsLakersJazz$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsLakersKnicks$text <- sapply(LiveTweetsLakersKnicks$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))

LiveTweetsThunderPort$text<- sapply(LiveTweetsThunderPort$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))
LiveTweetsThunderCeltics$text<- sapply(LiveTweetsThunderCeltics$text,function(row) iconv(row, "utf-8-mac", "ASCII", sub=""))

# Make all the tweets lower case to make n-grams analysis easier
LiveTweetsLakersSuns$text <-sapply(LiveTweetsLakersSuns$text, tolower)
LiveTweetsLakersBulls$text <-sapply(LiveTweetsLakersBulls$text, tolower)
LiveTweetsLakersMemphis$text <-sapply(LiveTweetsLakersMemphis$text, tolower)
LiveTweetsLakersJazz$text <-sapply(LiveTweetsLakersJazz$text, tolower)
LiveTweetsLakersKnicks$text <-sapply(LiveTweetsLakersKnicks$text, tolower)

LiveTweetsThunderPort$text <- sapply(LiveTweetsThunderPort$text, tolower)
LiveTweetsThunderCeltics$text <- sapply(LiveTweetsThunderCeltics$text, tolower)

#setting up corpus for good and bad basketball terms
goodBasketballTerms= read.table("Good basketball terms.txt")
goodBasketballVector= VectorSource(goodBasketballTerms)
goodBasketballCorpus= Corpus(goodBasketballVector)
  
badBasketballTerms= read.table("Bad basketball terms.txt")
badBasketballVector= VectorSource(badBasketballTerms)
badBasketballCorpus= Corpus(badBasketballVector)

#regex expressions removing hash tags user ids, retweets and link headers to better denoise the data
clean_tweets <- function(twitterList) {
  clean_tweet$text <- gsub("&amp", "", twitterList$text)
  clean_tweet$text <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet$text)
  clean_tweet$text <- gsub("@\\w+", "", clean_tweet$text)
  clean_tweet$text <- gsub("[[:punct:]]", "", clean_tweet$text)
  clean_tweet$text <- gsub("[[:digit:]]", "", clean_tweet$text)
  clean_tweet$text <- gsub("http\\w+", "", clean_tweet$text)
  clean_tweet$text <- gsub("[ \t]{2,}", "", clean_tweet$text)
  clean_tweet$text <- gsub("^\\s+|\\s+$", "", clean_tweet$text) 
  return(clean_tweet)
}

sanitizedLakersJazz <-clean_tweets(LiveTweetsLakersJazz)
sanitizedLakersBulls <-clean_tweets(LiveTweetsLakersBulls)
sanitizedLakersMemphis <-clean_tweets(LiveTweetsLakersMemphis)
sanitizedLakersSuns <-clean_tweets(LiveTweetsLakersSuns)
sanitizedLakersKnicks <-clean_tweets(LiveTweetsLakersKnicks)
sanitizedThunderPortland <-clean_tweets(LiveTweetsThunderPort)
sanitizedThunderCeltics <- clean_tweets(LiveTweetsThunderCeltics)


# Vizualization of the tweets via wordclouds
# Create corpus for each of the five games 
corpusLJ =Corpus(VectorSource(sanitizedLakersJazz))
corpusLS =Corpus(VectorSource(sanitizedLakersSuns))
corpusLB =Corpus(VectorSource(sanitizedLakersBulls))
corpusLM =Corpus(VectorSource(sanitizedLakersMemphis))
corpusLK =Corpus(VectorSource(sanitizedLakersKnicks))

corpusTP =Corpus(VectorSource(sanitizedThunderPortland))
corpusTC =Corpus(VectorSource(sanitizedThunderCeltics))

# Remove stopwords such as: the, is, at, which, and on. This is to increase performance of our process.
corpusLJ=tm_map(corpusLJ,function(x) removeWords(x,stopwords("english")))
corpusLS=tm_map(corpusLS,function(x) removeWords(x,stopwords("english")))
corpusLB=tm_map(corpusLB,function(x) removeWords(x,stopwords("english")))
corpusLM=tm_map(corpusLM,function(x) removeWords(x,stopwords("english")))
corpusLK=tm_map(corpusLK,function(x) removeWords(x,stopwords("english")))

corpusTP=tm_map(corpusTP,function(x) removeWords(x,stopwords("english")))
corpusTC=tm_map(corpusTC,function(x) removeWords(x,stopwords("english")))

corpusLJ <- tm_map(corpusLJ, removeWords, c("los", "angeles", "lakers"))
corpusLS <- tm_map(corpusLS, removeWords, c("los", "angeles", "lakers"))
corpusLB <- tm_map(corpusLB, removeWords, c("los", "angeles", "lakers"))
corpusLK <- tm_map(corpusLK, removeWords, c("los", "angeles", "lakers"))
corpusLM <- tm_map(corpusLM, removeWords, c("los", "angeles", "lakers"))

#oklahoma
corpusTP <- tm_map(corpusTP, removeWords, c("okcthunder", "oklahoma", "city","thunder"))
corpusTC <- tm_map(corpusTP, removeWords, c("okcthunder", "oklahoma", "city","thunder"))
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

#Oklahoma Port
set.seed(4211)
corpusTP=tm_map(corpusTP,PlainTextDocument)
wordcloud(corpusTP, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

#Oklahoma Celtics
set.seed(3011)
corpusTC=tm_map(corpusTC,PlainTextDocument)
wordcloud(corpusTC, min.freq=25,rot.per = 0.35, random.color=F, max.word=45, random.order=F,colors=col)

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


dtmThunderPort<- TermDocumentMatrix(corpusTP)
m <- as.matrix(dtmThunderPort)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsThunderPort <- data.frame(word = names(v),freq=v)
head(freqTermsThunderPort, 20)

dtmThunderCeltics<- TermDocumentMatrix(corpusTC)
m <- as.matrix(dtmThunderCeltics)
v <- sort(rowSums(m),decreasing=TRUE)
freqTermsThunderCeltics <- data.frame(word = names(v),freq=v)
head(freqTermsThunderCeltics, 20)



#file for player statistics
PlayerStats<-read.csv("PlayerStats.csv")
  
#unigrams for Lakers, Offense, Defense
LakersJazzUnigram = ngram(LiveTweetsLakersJazz$text, n=1)
waget.ngrams(LakersJazzUnigram)

LakersMemphisUnigram = ngram(LiveTweetsLakersMemphis$text, n=1)
get.ngrams(LakersMemphisUnigram)

LakersBullsUnigram = ngram(LiveTweetsLakersBulls$text, n=1)
get.ngrams(LakersBullsUnigram)

LakersSunsUnigram = ngram(LiveTweetsLakersSuns$text, n=1)
get.ngrams(LakersSunsUnigram)

LakersKnicksUnigram = ngram(LiveTweetsLakersKnicks$text, n=1)
get.ngrams(LakersKnicksUnigrams)

#bigrams for names
LakersJazzBigram = ngram(LiveTweetsLakersJazz$text, n=2)
get.ngrams(LakersJazzBigram)

LakersMemphisBigram = ngram(LiveTweetsLakersMemphis$text, n=2)
get.ngrams(LakersMemphisBigram)

LakersBullsBigram = ngram(LiveTweetsLakersBulls$text, n=2)
get.ngrams(LakersBullsBigram)

LakersSunsBigram = ngram(LiveTweetsLakersSuns$text, n=2)
get.ngrams(LakersSunsBigram)

LakersKnicksBigram = ngram(LiveTweetsLakersKnicks$text, n=2)
get.ngrams(LakersKnicksBigrams)

#trigrams for plays
LakersJazzTrigram = ngram(LiveTweetsLakersJazz$text, n=3)
get.ngrams(LakersJazzTrigram)

LakersMemphisTrigram = ngram(LiveTweetsLakersMemphis$text, n=3)
get.ngrams(LakersMemphisTrigram)

LakersBullsTrigram = ngram(LiveTweetsLakersBulls$text, n=3)
get.ngrams(LakersBullsTrigram)

LakersSunsTrigram = ngram(LiveTweetsLakersSuns$text, n=3)
get.ngrams(LakersSunsTrigram)

LakersKnicksTrigram = ngram(LiveTweetsLakersKnicks$text, n=3)
get.ngrams(LakersKnicksTrigrams)
  



