# This file contains the code to preprocess Product Evaluation

library(readxl)
library(tidytext)
library(stringr)
library(Rwordseg)
library(dplyr)

# import data
product.xlsx <- read_excel("1_评价数据.xlsx", sheet = 1)
product.xlsx
names(product.xlsx)
names(product.xlsx) <- c("product_id", "product_name","review",
                         "quantity", "poor_review", "keyword_1",
                         "keyword_2", "keyword_3", "keyword_4")

# process on reviews
info <- product.xlsx$review
  # transform all non-Chinese character into space
info.trim <- str_replace_all(info,"[0-9[:punct:]\\r\\n\\s]+"," ")
  # word split
info.split <- segmentCN(info.trim, analyzer = "jiebaR", returnType = "tm")

# process on poor_review
poor_review <- product.xlsx$poor_review
poor_review[is.na(poor_review)] <- 0
poor_review <- as.factor(poor_review)

# select only useful columns
product.data <- product.xlsx
product.data$review <- info.split
product.data$poor_review <- poor_review
product.data <- product.data[,c(2,3,5)]

# calculate tf-idf
 # tokenization, one-token-per-row
product.data <- product.data %>%  # add index for each review(document)
  mutate(index = row_number())
review.tfidf <- product.data %>%   
  unnest_tokens(word, review, token = "regex") %>%
  count(index, word) %>%
  bind_tf_idf(word, index, n)

# convert tidy format to matrix format
library(Matrix)
review.matrix <- cast_sparse(review.tfidf,row = index,
                             column = word, value = tf_idf)   # very sparse matrix
review.df <- as.data.frame(as.matrix(review.matrix))
review.sparse <- review.df %>%
  mutate(index = as.numeric(rownames(review.df))) 
review.sparse <- product.data %>%
  left_join(review.sparse, by = "index") %>%
  select(-review)

# export object
library(openxlsx)
write.xlsx(review.df, "sparse_review.xlsx")

