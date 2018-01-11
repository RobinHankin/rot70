# Project Title

Attempt to tile a 70x70 square with a 1x1, 2x2,..., 24x24 tiles

## Getting Started

R files prog.R and prog_fixed_24.R will produce 
### Prerequisites

You will need Knuth's dancing links c program.

```
R CMD BATCH prog.R          # gives data.txt
R CMD BATCH prog_fixed_24.R # gives data2.txt

cat data.txt  | ../Knuth/a.out 1 > ans1.txt   
cat data2.txt | ../Knuth/a.out 1 > ans2.txt  # should be faster

```


## Discussion

This directory contains functionality to see if there is a tiling of
the 70x70 square with 1x1, 2x2, 3x3,...,24x24 square tiles, but
allowing for a rotated tiling pattern.


short story:  

1.  Run R CMD BATCH prog_fixed_24.R  to create data2.txt.
2.  Run cat data2.txt | ../Knuth a.out 1 > ans.txt

This executes Knuth's algorithm X (DLX) which solves the exact cover
problem.


Longer story:

There is only one way to rotate the square (up to reflection and
rotation), as there is essentially only one integer solution to
a^2+b^2=70^2.  This is because the corners are the same point, so if
one corner is at a lattice point, then all four corners are at a
lattice point.  And the distance between corners is known to be 70.

Start with file twosquares_actualsize.pdf (the source code is
twosquares_actualsize.svg).  This shows how the squares are organised.
The coloured arrows are identifications which are like teleports.

File "helperfuncs.R" defines things like up() down() left() right()
which take a point and move it one square up, down, etc but accounting
for teleportation.

File "test.R" shows that the stuff works: it shows a path in the
toroidal space, together with teleportation which appears as long
straight lines.

File "test2.R" showcases the make_square() function which is used in
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

The last row shows that the 24x24 tile spans square A and square B in
the position corresponding to the last line of data.txt


1.  Run R CMD BATCH prog.R  to create data.txt.
2.  Run cat data.txt | ../Knuth a.out 1 > ans.txt


