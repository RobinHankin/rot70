## This is a low-level helper function definition file: up(), down(),
## left(), right(), and getpos().

## Refer to 'twosquares_grid.svg' for concepts.  The 'big' square is
## 56x56 and the little one is 42x42.  Observe that 56^2 +
## 42^2=4900=70^2=1^2+...+24^2.

## The coordinate system used for a location is c(x,y,s) where (x,y)
## is the 2D Cartesian coordinates (x,y) with (0,0) corresponding to
## the lower-left corner, positive x going upwards and positive y
## going rightwards.  Thus getpos() and splot() use natural idiom (it
## is probably better to ignore R's matrix printing methods which use
## (0,0) as the top left).  The third element, s, has 0 meaning square
## A (the big one on the left in twosquares_actualsize.svg) and 1
## meaning square B.




## The coordinates are set so that the tiny squares are numbered
## "a_01_01" to "a_56_56" for square A, and "b_01_01" to "b_42_42" for
## square B.

library(magrittr)


bss <- 56  # bss = 'Big Square Size'
lss <- 42  # lss = "Little Square Size'

## For each square  we need four neighbours: up(), down(), left(), right().

`up` <- function(xys){  # low level, o=c(x,y,s), not vectorized.
    x <- xys[1]
    y <- xys[2] + 1  #NB
    s <- xys[3]

    out <- c(x,y,s)  # default behaviour, no teleporting

    ## criterion for teleporting is complicated so can't be tested for
    ## here.
    
    if(s==0) { # starts in square A
        if(y>bss){ # moves off the top of square A
            if(x > lss){  # red teleport...
                out <- c(x-lss,y-bss,0) # ...stays in square A
            } else { # green teleport...
                out <- c(x,y-bss,1)  # ...moves to square B
            }
        } else { # in square A but no teleport...
            out <- c(x,y,0) # ...stays in square A
        }
    } else if (s==1){  # starts in square B
        if(y>lss){  # sic
            out <- c(x+bss-lss,y-lss,0) # moves to square A
        }
    } else {
      stop("s must be 0 or 1")  
    }
    return(out)
}

`down` <- function(xys){  # low level, o=c(x,y,s), not vectorized.
    x <- xys[1]
    y <- xys[2] - 1   # NB
    s <- xys[3]
    
    out <- c(x,y,s)  # default behaviour, no teleporting
    if(y>0){  # no teleport
        return(out)
    }
    
    if(s==0) { # starts in square A
        if(x > bss-lss){ # red teleport...
            out <- c(x-lss+bss,lss,1) #...to square B

        } else { # still red, but this time...
            out <- c(x+bss-lss,bss,0)   #...teleports to A
        }
    } else if (s==1){  # starts in square B
        out <- c(x,y+bss,0) # moves to square A
    } else {
        stop("s must be 0 or 1")  
    }
    return(out)
}

`left` <- function(xys){  # low level, o=c(x,y,s), not vectorized.
    x <- xys[1] - 1  #NB
    y <- xys[2]
    s <- xys[3]
    
    out <- c(x,y,s)  # default behaviour, no teleporting
    if(x>0){  # no teleport (NB '1' is not teleported)
        return(out)
    }
    
    if(s==0) { # starts in square A
        if(y<lss){ #  blue teleport...
            out <- c(x+lss,y,1) #...moves to square B
        } else { # yellow teleport...
            out <- c(x+bss,y-lss,0) #...stays in A
        }
    } else if (s==1){  # starts in square B
        out <- c(x+bss,y+bss-lss,0) # regular non-teleport movement to A
    } else {
        stop("s must be 0 or 1")  
    }
    return(out)
}

`right` <- function(xys){  # low level, o=c(x,y,s), not vectorized.
    x <- xys[1] + 1 #NB
    y <- xys[2]
    s <- xys[3]

    out <- c(x,y,s)  # default behaviour, no teleporting

    ## criterion for teleporting is complicated so can't be tested for
    ## here.
    
    if(s==0) { # starts in square A
        if(x>bss){ 
            if(y > bss-lss){  # regular movement, no teleport and...
                out <- c(x-bss,y+lss-bss,1) # ... moves to square B
            } else { # yellow teleport and ...
                out <- c(x-bss,y+lss,0)  # ...stays in square A 
            }
        }
    } else if (s==1){  # starts in square B
            if(x>lss){ # blue teleport and...
                out <- c(x-lss,y,0) #...teleports to A
            }
    } else {
      stop("s must be 0 or 1")  
    }
    return(out)
}


`getpos` <- function(xys){
  xys <- rbind(xys)
  out <- matrix(NA,nrow(xys),2)
  square <- xys[,3]
  if(!all(square %in% c(0,1))){
    stop("unrecognised square")
  }

  A <- which(square==0)
  B <- which(square==1)

  out[A,] <- xys[A,1:2,drop=FALSE]
  out[B,] <- sweep(xys[B,1:2,drop=FALSE],2,c(bss,bss-lss),"+")

  return(out)
}
  
`splot` <- function(p,...){ # takes three-column matrix and plots it
  plot(1:10,xlim=c(0,100),ylim=c(0,50),asp=1,type="n")
  polygon(x=c(0,bss,bss,0),y=c(0,0,bss,bss))
  polygon(x=c(bss,bss+lss,bss+lss,bss),y=c(bss-lss,bss-lss,bss,bss))
  points(getpos(p),...)
}
  
`make_square` <-  function(start,n){  # splot(make_square(c(40,40,0),21))
  start <- rbind(start)

  p <- matrix(NA,n^2,3)


  for(i in 0:(n-1)){
    place <- start
    for(k in seq_len(i)){place <- right(place)}
    
    for(j in seq_len(n)){
      p[1+i + (j-1)*n,] <- place
      place <- up(place)
    }
  }
  return(p)
}

`stringmaker` <- function(x){  # turns c(3,4,0) to 'a_3_4'; low level
  if(x[3]==0){
    letter <- 'a'
  } else if(x[3] == 1){
    letter <- 'b'
  } else {
    stop("unrecognised square; 0 for A and 1 for B")
  }
  return(paste(letter,x[1],x[2],sep="_"))
}

  
