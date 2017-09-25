predict_next_probable_words_table <-function(input,cluster=4){
  threegramDF <- threegram_final
  Katz = FALSE # initialize Katz back off flag to FALSE
  gt = FALSE # initialize Good-Turing smoothing to FALSE
  input <- prepare_input(input)
  inputSize<-length(strsplit(input, " ")[[1]])
  if (inputSize != 2) stop("Please input exactly two words.\n",
                           "Don't forget adding the space.")    # error handling
  nCount <- sum((threegramDF[which(threegramDF$Bi==input), 1]))
  if (nCount == 0) {     # bicount=0 therefore use Katz backoff
    Katz = TRUE
    input <- gsub(".* ","",input)    # isolates w2 as unigram
    nCount <- sum(threegramDF[which(threegramDF$Uni==input), 1])
    if (nCount == 0) stop("Your sentence is quite rare\n", 
                          "The model was not able to find it.")     # error handling
    
    # Subset all recorded 2-grams that begin with unigram
    seekTri<-grepl(paste("^",input,"$",sep=""),threegramDF$Uni)
    subTri<-threegramDF[seekTri,] #subset relevant outputs
    # aggregation is key here because otherwise can provide
    # multiple output words as the front of bigrams was removed
    subTri<-aggregate(subTri$counts,list(subTri$w3),sum)
    names(subTri)<-c("w3","counts")
    subTri<-subTri[order(subTri$counts,decreasing=T),]
    useTri <- create_help_table (input,subTri,cluster)
    for (i in 1:length(useTri$counts)) {
      count = useTri[i,2]
      if(count<=5) {     # employs the Good-Turing Smoothing
        useTri[i,2]<-good_turing_count[count+1,2]
        gt = TRUE
      }
    }
  } else {
    
    # Subset all recorded 3-grams that begin with bigram
    seekTri<-grepl(paste("^",input,"$",sep=""),threegramDF$Bi)
    subTri<-threegramDF[seekTri,] #subset relevant 3-grams
    subTri<-aggregate(subTri$counts,list(subTri$w3),sum)
    names(subTri)<-c("w3","counts")
    subTri<-subTri[order(subTri$counts,decreasing=T),]
    useTri <- create_help_table (input,subTri,cluster)
    for (i in 1:length(useTri$counts)) {
      count = useTri[i,2]
      if(count<=5) {     # employs the Good-Turing Smoothing
        useTri[i,2]<-good_turing_count[count+1,4]
        gt = TRUE
      }
    }
  }
  
  options(digits = 4)
  
  ## generates data frame of tabular outputs for user review
  predictWord <- data.frame(Word=useTri$w3,
                            probability=(useTri$counts/nCount)*100, stringsAsFactors=FALSE) 
  
  ## generates dotchart to visualize possible options, must invert order
  # output_table<-predictWord[order(predictWord$probability),] #order for lowest to highest
  # # dotchart(plot$probability,labels=plot$Word, pch= 1, color = "purple",
  # #     xlab=paste("Probability (in %) of top",cluster,"clusters"),
  # #      main=paste("N-Grams Starting with: \"",toupper(input),"\""))
  # 
  # output_table <- output_table %>% arrange(desc(probability))
  # output_table$Word <- as.character(output_table$Word)
  
  ## informative phrases as to what the user input was
  print(paste("Next probable words beginn with:",toupper(input)))
  if(Katz==TRUE){
    print("*Katz back off was used to improve results by reducing bigram to unigram")
  }    
  if(gt == TRUE){
    print("*Good-Turing smoothing was used to improve results regardgig n-grams frequencies smaller 6")
  }
  output <- as.character(predictWord$Word[1:4])
  return(output)
}