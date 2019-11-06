# code for stringr tutorial and language processing
library(stringr)

string.1 <- "Example STRING, with example numbers (12, 15 and also 10.2)?!"
string.1

string.lower <- tolower(string.1) # turn characters into lower case
string.lower

string.2 <- "Wow, two sentences."

string.both <- paste(string.1, string.2) # concatenate two strings
string.both

string.vector <- str_split(string.both, "!")[[1]] # split the string
string.vector

grep(pattern = "\\?", string.vector) # find the strings with pattern
grepl("\\?", string.vector)

str_replace(string.vector, "e", "___")  # replace pattern with something
str_replace_all(string.vector, "e", "___")
str_extract(string.vector, "[0-9]+") # extract pattern from the string
str_extract_all(string.vector, "[0-9]+")

clean_string <- function(string) {
  temp <- tolower(string)
  # replace non-alphabetic characters into space
  temp <- str_replace_all(temp, "[^a-zA-Z\\s]", " ")
  # replace more space with one
  temp <- str_replace_all(temp, "[\\s]+", " ")
  # split sentence into words
  temp <- str_split(temp, " ")[[1]]
  # get rid of "" if necessary
  indexes <- which(temp == "")
  if(length(indexes)>0) {
    temp <- temp[-indexes]
  }
  return(temp)
}

sentence <- "The term 'data science' (originally used interchangeably with 'datalogy') has existed for over thirty years and was used initially as a substitute for computer science by Peter Naur in 1960."
clean_string(sentence)







