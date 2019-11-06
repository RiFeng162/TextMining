# code for TF-IDF tutorial
library(dplyr)
library(janeaustenr)
library(tidytext)

# tokenization: one-token-per-row
book_words <- austen_books() %>%
  unnest_tokens(word, text) %>%
  count(book, word, sort = TRUE)

total_words <- book_words %>%
  group_by(book) %>%
  summarise(total = sum(n))   # calculate the total words for each book

book_words <- left_join(book_words, total_words, by = "book")
book_words

book_words <- book_words %>%
  bind_tf_idf(word, book, n)  # calculate tf-idf values
book_words %>% 
  select(-total) %>%
  arrange(desc(tf_idf))
  
  
  
  
  
  
  