source("helperfuncs.R")

a <- cbind(4,4,0)
n <- 900
p <- matrix(NA,n,3)

for(i in 1:n){
  p[i,] <- a
  if(runif(1) < 0.5){
    a <- a %>% right
  } else {
    a <- a %>% up
  }
  
}

splot(p,type='b')
