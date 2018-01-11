## creates data.txt for use with Knuth's dancing links DLX algorithm.

## This differs from prog.R in that the position of the 24x24 square is fixed.


filename <- "data.txt"

source("helperfuncs.R")

## do the first line first:
jj <- rbind(
    cbind(as.matrix(expand.grid(seq_len(bss),seq_len(bss))),0),
    cbind(as.matrix(expand.grid(seq_len(lss),seq_len(lss))),1)
)

firstline <- paste(apply(jj,1,stringmaker),collapse=" ")
firstline <- paste(c(firstline,seq_len(24)),collapse=" ")
write(firstline,file=filename,append=FALSE)

writeoneline <- function(i,j,k,n){
  s <- make_square(start=c(i,j,k),n=n)
  oneline <- paste(apply(s,1,stringmaker),collapse=" ")
  oneline <- oneline %>% paste(n)   # put size of tile here
  write(oneline,file=filename,append=TRUE)
}

for(n in 1:24){    # size of square

  print(c("square size",n))
  ## do square A first
  for(i in seq_len(bss)){
    for(j in seq_len(bss)){
      writeoneline(i,j,0,n) 
    }
  }

  ## Now square B
  for(i in seq_len(lss)){
    for(j in seq_len(lss)){
      writeoneline(i,j,0,n)
    }
  }
}  # n loop closes



## Now do the 24x24 square, at a fixed position.  This will be a_1_1:

