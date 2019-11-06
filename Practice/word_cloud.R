# code for practise word cloud
# http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know

library("tm")   # package for text mining
library(SnowballC)  # for text stemming
library(wordcloud)   # word cloud generator

# import text
filePath <- "http://www.sthda.com/sthda/RDoc/example-files/martin-luther-king-i-have-a-dream-speech.txt"
text <- readLines(filePath)
docs <- Corpus(VectorSource(text))  # convert data into Corpus
inspect(docs)   # show the details of documents

# text cleanning
    # convert symbols to space
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
    # convert to lowercase
docs <- tm_map(docs, content_transformer(tolower))
    # remove numbers
docs <- tm_map(docs, removeNumbers)
    # remove stop words
docs <- tm_map(docs, removeWords, stopwords("english"))
    # remove punctuations
docs <- tm_map(docs, removePunctuation)
    # remove extra white space
docs <- tm_map(docs, stripWhitespace)

# prepare data structure for word cloud
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
head(d)

# generate the word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words = 200, random.order = FALSE, 
          colors = brewer.pal(8,"Dark2"))





