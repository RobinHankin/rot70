## Here, function make_square() is tested on the torus.  Function
## make_square() constructs a square and returns its coordinates.  It
## takes two arguments, the first of which is the position of the
## lower-left point of the square, in standard notation documented at
## the top of helperfuncs.R.  The second argument to make_square() is
## the size of the square.


source("helperfuncs.R")
splot(make_square(c(40,40,0),21))
dev.new()

splot(
    rbind(
        make_square(c(40,40,0),21),
        make_square(c(20,20,1),04),
        make_square(c(33,33,1),11),
        make_square(c(02,51,0),08),
        make_square(c(54,03,0),05),
        make_square(c(54,20,0),06)
    ),
    col = c(
        rep("red",441),
        rep("black",16),
        rep("green",121),
        rep("blue",64),
        rep("yellow",25),
        rep("orange",36)
    ),
    pch=15,main='asddfs'
)
