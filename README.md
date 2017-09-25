# Coursera Data Science Capstone Swift

## Summary
The goal is to create a data product that takes one or words as input and predicts the next best word. The use case comes from the company SwiftKey. The benefit for the end user is simple: He saves time and is more efficient. If we can predict the next best word with an accuracy of 50% the user will then save about 50% personal time regarding the "typing process" on his mobile device.

## Result
A shiny app which takes one to several words as input and predicts the next best word as outcome. A brief presentation using RStudio Presenter shows you the way from your input to the generated output including the predictive performance KPI. The access to the final presentation as well as the data product is below (see R code).

## Method
The following steps are necessary to reach the result.
- Understanding the problem 
- Data acqusition and cleaning 
- Exploratory analysis 
- Statistical modeling & predictive modeling 
- Creative exploration 
- Creating a shiny data product 
- Creating a short slide deck pitching the product 

## Organization

### README file 
The file gives the data product user an overview to the raw data and the final data product.

### Data
- data origin: https://help.github.com/articles/working-with-large-files/
- raw data
    + Load data and unzip it
    + stored local because GitHub just allows 100 MB per file and the files are over 100 MB
- processed data 
- shows way from raw to processed/tidy data 


### R code
You'll find these scripts and figures in the folders below:
- Quizzes 
    + Solution to Quiz 1
- Assignments
    + You'll find the milestone report on [RPubs](http://rpubs.com/ramon_schildknecht/dscmr) 
    + You'll find the final presentation with the most important information on [RPubs](http://rpubs.com/ramon_schildknecht/predict_next_probable_word)
    + You'll find the final Shiny data product to predict the next probable word [here on Shinyapps.io](https://rasch.shinyapps.io/predict_next_probable_words/). The necessary files to reproduce the shiny app are in the folder 2.2 Assignments/Shiny/. Hint: You need to [download this trigram file](https://www.evernote.com/l/Ai_KzaCMxqVEd7syWS2__SrF9D8FIgcDM-8) as well. The file size didn't met Githubs limits.
