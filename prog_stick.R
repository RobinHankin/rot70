## creates data.txt for use with Knuth's dancing links DLX algorithm.

## This file is substantially identical to prog.R but forces one
## square tile to be stuck to the 1x1 square tile.

## The main function is write_data_file() which is defined here, and
## executed at the very end of the file.

source("helperfuncs.R")

`write_data_file` <- function(filename,stuck_square,mirror=FALSE){

  stopifnot(length(stuck_square) == 1)
  stopifnot(stuck_square == round(stuck_square))
  stopifnot(stuck_square >  1)
  stopifnot(stuck_square < 25)
  
  
  ## do the first line first:
  jj <- rbind(
      cbind(as.matrix(expand.grid(seq_len(bss),seq_len(bss))),0),
      cbind(as.matrix(expand.grid(seq_len(lss),seq_len(lss))),1)
  )
  
  firstline <- paste(apply(jj,1,stringmaker),collapse=" ")
  firstline <- paste(c(firstline,seq_len(24)[-c(1,stuck_square)]),collapse=" ")
  firstline <- paste(c(firstline,paste(1,stuck_square,sep="_")),collapse=" ")   
  write(firstline,file=filename,append=FALSE)


  ## at this point, the first line will be a_1_1 to a_56_56 and b_1_1
  ## to b_42_42 for the positions to be tiled, and also 23 (sic)
  ## square tiles and one compound tile.  If the stuck square is 10x10
  ## will have 2,3,4,5,6,7,8,9,11,12,13,14...24 [note missing 1 and
  ## 10] for the square tiles; and at the end we will have 1_10 for
  ## the compound 1x1-and-10x10 tile.

  ## A typical first line will look like this:

  ## a_1_1 a_2_1 a_3_1 a_4_1 a_5_1 [snip] b_42_42 2 3 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 1_5

  ## (this for stuck_square=5).

  
  writeoneline <- function(i,j,k,n){
    s <- make_square(start=c(i,j,k),n=n)
    oneline <- paste(apply(s,1,stringmaker),collapse=" ")
    oneline <- oneline %>% paste(n)   # put size of tile here
    write(oneline,file=filename,append=TRUE)
  }

  for(n in seq_len(24)[-c(1,stuck_square)]){    # size of square

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
      writeoneline(i,j,1,n)
    }
  }
}  # n loop closes



  ## now do the stuck square and write the final line:


  if(mirror){
    covered <-
    rbind(
        make_square(c(1,1,0),1),
        make_square(c(1,2,0),stuck_square)
    )
  } else {
  covered <-
      rbind(
        make_square(c(1,1,0),1),
        make_square(c(2,1,0),stuck_square)
    )
}
  lastline <- paste(apply(covered,1,stringmaker),collapse=" ")
  lastline <- paste(c(lastline,paste(1,stuck_square,sep="_")),collapse=" ")
  write(lastline,file=filename,append=TRUE)


  ## thus a typical last line will look like this (for stuck_square=3, mirror=FALSE):
  ## a_1_1 a_2_1 a_3_1 a_4_1 a_2_2 a_3_2 a_4_2 a_2_3 a_3_3 a_4_3 1_3
  ##
  ## See how there are 11 = 1 + 3*3 +1 entries.  The first is the
  ## position of the 1x1 tile, the next 9 are the positions of the 3x3
  ## tile (which are stuck to the 1x1 tile), and the final entry is
  ## the name of the compound tile which is the 1x1 tile stuck to the
  ## 3x3 tile.

  ## NB: the penultimate entry on the last line is "a_4_3" which looks
  ## odd because the big tile is 3x3 and we have a 4.  This is because
  ## the lower-left corner of the 3x3 tile is (2,1), not (1,1) so
  ## everything is shifted one place to the right.


  
}

## Now call function write_data_file() 23 times, one for each tile
## that might be stuck to the 1x1 tile:


f <- function(stuck_square,mirror){
  if(stuck_square < 10){
    filename <- paste("d0",stuck_square,".txt",sep="")
  } else {
    filename <- paste("d" ,stuck_square,".txt",sep="")
  }
  if(mirror){filename <- sub('.txt','_m.txt',x=filename)}
  write_data_file(filename,stuck_square,mirror)
}

## Don't make the mistake of looking at the last line of a d??.txt
## file before write_data_file() has finished.  This can cause
## unnecessary panic.

for(stuck_square in 2:24){
  print(stuck_square)
  f(stuck_square,mirror=FALSE)
  f(stuck_square,mirror=TRUE )
}
  
