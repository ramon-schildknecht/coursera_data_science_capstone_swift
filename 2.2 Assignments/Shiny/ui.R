library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict next probable words"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    # change sidebar width if time
    sidebarPanel(
      # TextInput to get the user phrase
      h1("Input"),
      br(),
      p("Please enter your word/s or phrase below and wait for about 15 seconds. The algorithm will check over 1 million word combinations for you!"), 
      textInput(inputId = "phrase",
                label = "Phrase to predict next word:",
                value = "",
                width = "12cm"),
      br(), 
      a("You find more details here about this data product here", href= "http://rpubs.com/ramon_schildknecht/predict_next_probable_word")
      
    ),

        
    # Show a plot of the generated distribution
    mainPanel(
       br(), 
       h1("Results"),
       br(),
       p("You find 4 suggestions regarding your next probable word below, enjoy!"),
       
       h3("Suggestions next Probable Word"),
       
       textOutput("npw_words"),
       
       br(),
       
       h3("Next Probable Words Graph with probabilities"),
       
       plotOutput("npw_plot"),
       p("Hint: You can ignore the errors if there are no input words.")
       
    )
  )
))
