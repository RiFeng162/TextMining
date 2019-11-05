# tidy and non-tidy format, link:https://www.tidytextmining.com/dtm.html

### tidying DocumentTermMatrix-object
  # related with tm package
require(tm)
data("AssociatedPress", package = "topicmodels")
AssociatedPress   # sparse matrix
  # access the row/column names
Docs(AssociatedPress)
head(Terms(AssociatedPress))
  # convert to tidy format
library(dplyr)
library(tidytext)
ap.tidy <- tidy(AssociatedPress)
ap.tidy # document - row, term - column, count - entry

### tidying dfm-object
  # related with quanteda package
data("data_corpus_inaugural", package = "quanteda")
inaug.dfm <- quanteda::dfm(data_corpus_inaugural, verbose = FALSE)
inaug.dfm
inaug.tidy <- tidy(inaug.dfm)
inaug.tidy

  # construct tf-idf based on tidy format
inaug.tf_idf <- inaug.tidy %>%
  bind_tf_idf(term, document, count) %>%
  arrange(desc(tf_idf))
inaug.tf_idf

### cast tidy into matrix
  # to dtm-object
ap.tidy %>% cast_dtm(document, term, count)
  # to dfm-object
inaug.tidy %>% cast_dfm(document, term, count)
  # to a sparse matrix
library(Matrix)
m <- ap.tidy %>%
  cast_sparse(document, term, count)
class(m)
dim(m)

### corpus - documents with metadata
data("acq")
acq
class(acq)
acq[[1]]
acq.tidy <- tidy(acq)
acq.tidy
View(head(acq.tidy)) # 50 documents are converted as 50 rows, metadata and text as columns
  # based on tidy format do some text analysis
acq.token <- acq.tidy %>%
  select(-places) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words, by = "word")
acq.token %>%
  count(word, sort = TRUE)
  # tf-idf
acq.token %>%
  count(id, word) %>%
  bind_tf_idf(word, id, n) %>%
  arrange(desc(tf_idf))











