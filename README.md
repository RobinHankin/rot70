# Tiling a 70x70 square

Attempt to tile a 70x70 square with a 1x1, 2x2,..., 24x24 tiles

## Getting Started

R files ```prog.R``` and ```prog_fixed_24.R``` will produce  ```data.txt``` 
### Prerequisites

You will need Knuth's dancing links c program, which I am relucant to
include here because it does not have a clear license. You can
download the program from his website.

The command I used to compile Knuth's c code is as follows:

```
gcc -mcmodel=large -O dance_long2.c
```

And it can be used here as follows:

```
R CMD BATCH prog.R          # gives data.txt
R CMD BATCH prog_fixed_24.R # gives data.txt; should be faster

cat data.txt  | ../Knuth/a.out 1 > ans1.txt   
```

To get an idea of how this works, run

``` 
cat example_exact_cover.txt  | ../Knuth/a.out 1 > ans1.txt
```

File ```example_exact_cover.txt``` looks like this:

```
a b c d e f
a b c
b c d
a b d e c
a
d e f
```

The first row shows that we need to find letters a-f exactly once by
choosing subseqent rows.  Just by inspection we can match the first
row with ```a b c``` and ```d e f``` (note that order is not
important).

Running DLX gives:


```
rot70 % cat example_exact_cover.txt | ~/Dropbox/dancing_links/Knuth/a.out 1
1:
 f d e (1 of 1)
 b c a (1 of 1)
Altogether 1 solutions, after 16 updates.
     0     1     1 nodes, 11 updates
     1     0     1 nodes, 5 updates
Total 3 nodes.
rot70 % 
```

So it finds the two rows and shows that this is the only solution.  




## Discussion

In 1875, Lucas observed that 1^2+2^2+3^2+...+24^2=4900 was a perfect square and conjectured that this was the only nontrivial example.  Lucas's conjecture was proved to be true in the early 20th century, and an elementary proof was found much later (Anglin 1990).

The conjecture suggests that it is possible to tile a 70x70 square with a 1x1, 2x2,...,24x24 square tiles but this is not the case.  I have also determined that it is not possible to tile the 70x70 torus with these tiles, if the edges of the squares tiles are aligned with the edges of the 70x70 square.

This directory contains functionality to see if there is a tiling of
the 70x70 square with 1x1, 2x2, 3x3,..., 24x24 square tiles, but
allowing for a rotated tiling pattern.


short story:  

1.  Run ```R CMD BATCH prog_fixed_24.R```  to create data.txt.
2.  Run ```cat data.txt | ../Knuth a.out 1 > ans.txt``` to start the dancing links program

This executes Knuth's algorithm X (DLX) which solves the exact cover
problem.


Longer story:



There is only one way to rotate the square (up to reflection and
rotation), as there is essentially only one integer solution to
a^2+b^2=70^2.  This is because the corners are the same point, so if
one corner is at a lattice point, then all four corners are at a
lattice point.  And the distance between corners is known to be 70.

Start with file ```twosquares_actualsize.pdf``` (the source code is
```twosquares_actualsize.svg```).  This shows how the squares are organised.
The coloured arrows are identifications which are like teleports.

File ```helperfuncs.R``` defines things like ```up()``` ```down()``` ```left()``` ```right()```
which take a point and move it one square up, down, etc but accounting
for teleportation.  That file includes loads of documentation, referring to ```twosquares_actualsize.svg```, which shows the conventions used.

File ```test.R``` shows that the stuff works: it shows a path in the
toroidal space, together with teleportation which appears as long
straight lines.

File ```test2.R``` showcases the ```make_square()``` function which is used in
prog.R.  This plots a square that straddles a number of teleportation
lines.  There will be a line of data.txt that corresponds to this
precise placing of the 21x21 tile.


File data.txt, produced by prog.R, looks like this:


```
a_1_1 a_2_1 a_3_1 _5_1 a_6_1 a_7_1 a_8_1 a_9_1 [snip] a_56_56 b_1_1 b_2_1 [snip] b_40_42 b_41_42 b_42_42 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
a_1_1 1
a_1_2 1
...
a_5_5 a_6_5 a_5_6 a_6_6 2
...
b_42_42 a_1_42 a_2_42 [snip] b_23_9 24
```

The first line defines the names of the elements.  For example, entry
"a_5_6" corresponds to "square A, coordinate (5,6)".  So the first
line has 56^2 + 42^2 = 4900 entries for coordinates, and at the end
has 1,2,3,...,24 which correspond to the tiles.

Subsequent rows correspond to placing tiles in particular places.
Consider "a_5_5 a_6_5 a_5_6 a_6_6 2".  This means placing the 2x2 tile
[as seen by the last entry, "2"] on coordinates (5,5), (5,6), (6,5),
(6,6).  If this row is chosen no other row with "2" in it may be
chosen: there is only one 2x2 tile.


If using prog.R, the last row show that the 24x24 tile spans square A and square B in
the position corresponding to the last line of data.txt

If using prog_fixed_24.R, the last row shows that the 24x24 tile has only one place to go.  So DLX *must* pick this row, to satisfy the requirement that '24' appears in the choice of rows.  

Consider the case where each of the tiles may be placed anywhere.  If there is a tiling of the 70x70 square, then from a single tiling there are 4900 translated tilings.  But prog_fixed_24.R ties down the placing of the 24x24 tile so reduces the search space by a factor of 4900.  If there is no tiling, DLX with prog_fixed_24.R should determine this fact 4900 times faster than prog.R.  Note that I have fixed the position of the largest tile.  This is the most efficacious one to fix because it limits the choices for the other tiles by the maximum amount.




## Compound tiles

Ross points out that we can exploit the special properties of the 1x1
tile, being the smallest.  We know that it must look like
```tiled_squares_klein.svg``` (or its mirror image, I guess).  In the
diagram I have drawn the larger tile as 3x3 but it could be any size
>1.  So WLOG there is a compond tile as in the diagram (but with
unknown larger square tile).  The advantage of doing it this way is
that the location marked with the red "X" is difficult to fill and it
must be one of 22 tiles with lower right corner at the X.  The
heuristic used by Knuth in DLX will identify this difficulty and use
it to prune the search tree quickly.

This device also ensures that there is one fewer tile to place.  In
addition, we have eliminated mirror images and also rotational
redundancy, which should lead to faster finishing whether or not an
exact cover exists.

This is a massive saving compared with the previous versions because,
even after you have placed the 24x24 tile there are zillions of
covering options for the next tile to be placed (or next location to
be covered).

The operational method is to place the 1x1 tile at position
(1,1,0)---that is, at the lower left corner of square A.  The compound
tile is made of the 1x1 and an nxn square, with the nxn square at
position (2,1,0)---that is, joining it as shown in
```compound_square.svg```.

File `prog_stick.R` carries out Ross's idea.  The file is heavily
documented but in essence creates files d02.txt, d03.txt,...,d24.txt,
the filename showing which nxn square tile is joined to the 1x1
square.  File 'compound runner' is a batch file (run it as
"```. ./compound_runner"```) which executes Dancing links for all the
files simultaneously.

This approach might miss solutions that have the compound tile the
"wrong way round" (the compound tile has no line of symmetry and
neither does the plane area of ```twosquares_actualsize.svg```).  I am
not sure whether this line of reasoning is correct, but have augmented
```prog_stick.R``` to include mirror images.  Function
```write_data_file()``` takes a ```mirror``` logical argument
defaulting to ```FALSE```.  If set to ```TRUE``` this effectively
changes the compound tile to its mirror image by starting at (2,1)
instead of (1,2).





## References

* W. S. Anglin 1990. "The Square Pyramid Puzzle".  _The American Mathematical Monthly_, vol 97, number 2, pp120-124
* J. R. Bitner and E. M. Reingold 1975. "Backtrack programming techniques".  _Communications of the ACM_, volume 18, number 11, pp651-656
