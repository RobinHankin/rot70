source("helperfuncs.R")
p <-
  rbind(
      cbind(matrix(sample(seq_len(bss),1000,replace=TRUE),ncol=2),0),
      cbind(matrix(sample(seq_len(lss),1000,replace=TRUE),ncol=2),1)
  )



a <- cbind(4,4,0)
n <- 900
p <- matrix(NA,n,3)

for(i in 1:n){
  p[i,] <- a
  if(runif(1) < 0.2){
    a <- a %>% right
  } else {
    a <- a %>% up
  }
  
}

 plot(getpos(p),cex=seq_len(nrow(p))/nrow(p)*3,asp=1,type='b')
