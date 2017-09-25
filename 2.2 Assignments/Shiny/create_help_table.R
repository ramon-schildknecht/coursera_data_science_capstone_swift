create_help_table <-function(input,subTri,cluster) {
  diff = 0 # initialize counter - compares diff in probabilities of rows
  row.use=1 # initialize counter - counts total rows to subset from DF
  size <- dim(subTri)[1]
  if (size == 1){        # if the total trigrams found equals one
    useTri <- subTri   # simply use the one phrase and return as output
    return(useTri)
  } else {               # else build table of outputs based on cluster input
    remain = size - 1  # counter to work through list
    while (diff < cluster && remain >0) {
      if (subTri[row.use,2] - subTri[row.use+1,2] > .00001) diff=diff + 1
      row.use <-row.use + 1
      remain <- remain - 1    # calculates when end-of-list is reached
    }
    if (remain == 0) {
      useTri <- subTri[1:row.use,]  # when list is fully used
      return(useTri)
    } else {
      useTri <- subTri[1:row.use-1,]  # if max is reached first
      return(useTri)
    }
  }
}