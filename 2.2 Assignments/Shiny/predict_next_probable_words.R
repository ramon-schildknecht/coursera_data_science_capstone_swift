predict_next_probable_words <-function(input,cluster=4){
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
  plot<-predictWord[order(predictWord$probability),] #order for lowest to highest
  # dotchart(plot$probability,labels=plot$Word, pch= 1, color = "purple",
  #     xlab=paste("Probability (in %) of top",cluster,"clusters"),
  #      main=paste("N-Grams Starting with: \"",toupper(input),"\""))
  
  plot2 <- plot %>% arrange(desc(probability))
  plot2$Word <- as.character(plot2$Word)
  temp1 <- plot2$Word[4]
  temp2 <- plot2$Word[3]
  temp3 <- plot2$Word[2]
  temp4 <- plot2$Word[1]
  temp.all <- c(temp1, temp2, temp3, temp4)
  plot2$Word <- factor(plot2$Word, levels = temp.all)
  rm(temp.all, temp1, temp2, temp3, temp4)
  # Generate plot
  add.colors <- c("A", "B", "C", "D")
  cbPalette <- c("#F8766D", "#00BA38", "#619CFF", "#C77CFF", "F8766D", "#00BA38", "#619CFF", "#C77CFF")
  plot2 %<>% mutate(add.colors)
  p <- ggplot(plot2, aes(x=Word, y=probability, fill = add.colors)) + geom_bar(stat="identity") + coord_flip() + scale_color_brewer(palette="Dark2") + ggtitle("Next Probable Words (upper = more likely)") + xlab("Next Probable Words") + ylab("Probability in %") + guides(fill = FALSE) + scale_fill_manual(values=cbPalette)
  print(p)
  
  ## informative phrases as to what the user input was
  print(paste("Next probable words beginn with:",toupper(input)))
  if(Katz==TRUE){
    print("*Katz back off was used to improve results by reducing bigram to unigram")
  }    
  if(gt == TRUE){
    print("*Good-Turing smoothing was used to improve results regardgig n-grams frequencies smaller 6")
  }
  
  return(predictWord)
}