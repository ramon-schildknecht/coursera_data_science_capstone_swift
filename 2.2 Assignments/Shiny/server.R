# load libraries
library(shiny)
library(stringi)
library(ggplot2)
library(dplyr)
library(magrittr)

options(shiny.maxRequestSize=150*1024^2) 

# set working directory
#setwd("/Users/Ramon/Documents/R/DS Capstone Project/shiny/Predict_next_probable_words/")

# read necessary help files
threegram_final <- read.csv("threegram_final.csv")[,-1]
good_turing_count <- read.csv("good_turing_count.csv")[,-1]

# load necessary functions
source("prepare_input.R", local = TRUE) # part of predict function
source("create_help_table.R", local = TRUE) # part of predict function
source("predict_next_probable_words.R", local = TRUE)
source("predict_next_probable_words_table.R", local = TRUE)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # output$next_best_words <- renderText ({
  #   phrase <- "going to new york"
  #   phrase_origin <- input$phrase
  #   phrase <- input$phrase
  #   # testing
  #   # phrase <- "i was going to new york and to the"
  #   last.word <- stri_extract_last_words(phrase)
  #   phrase <- gsub("\\s*\\w*$", "", phrase)
  #   second.last.word <- stri_extract_last_words(phrase)
  #   next_best_words <- paste(second.last.word, last.word)
  # })
  
  # not working start
  # x <- reactive({
  #   input$phrase
  # }) 
  # 
  # output$next_best_words <- ({
  #   x()
  # })
  # not working end
  
  output$npw_words <- renderText({
    #   
    #next_best_words <- "new york"
    phrase <- input$phrase
    last.word <- stri_extract_last_words(phrase)
    phrase <- gsub("\\s*\\w*$", "", phrase)
    second.last.word <- stri_extract_last_words(phrase)
    next_best_words <- paste(second.last.word, last.word)
    predict_next_probable_words_table(next_best_words)
    #   # generate bins based on input$bins from ui.R
    #   x    <- faithful[, 2] 
    #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
    #   
    #   # draw the histogram with the specified number of bins
    #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
    #   
  })
  
  output$npw_plot <- renderPlot({
  #   
      #next_best_words <- "new york"
      phrase <- input$phrase
      last.word <- stri_extract_last_words(phrase)
      phrase <- gsub("\\s*\\w*$", "", phrase)
      second.last.word <- stri_extract_last_words(phrase)
      next_best_words <- paste(second.last.word, last.word)
      predict_next_probable_words(next_best_words)
  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2] 
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #   
  })
  
})
