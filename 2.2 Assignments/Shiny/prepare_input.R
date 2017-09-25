prepare_input <-function(word) {
  word <- tolower(word) #ensure input is in lower case
  word <- gsub("[^[:alnum:][:space:]\']", "",word)
  word <- gsub("^[ ]{1,10}","",word)
  word <- gsub("[ ]{2,10}"," ",word)
  return(word)
}