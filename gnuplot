To set initial plot window size:

    -geometry 100x100


Great reference:
    http://t16web.lanl.gov/Kawano/gnuplot/index-e.html


ANSWERED QUESTIONS:
Q: how to separate curves when plotting datafiles with lines?
A: According to "help datafile":
   In datafiles, blank records (records with no characters other than blanks and
   a newline and/or carriage return) are significant---pairs of blank records
   separate `index`es (see `plot datafile index`).  Data separated by double
   blank records are treated as if they were in separate data files.

Q: after upgrade to ubuntu 14.04.1, gnuplot wasn't showing graph window.
A: per http://askubuntu.com/questions/277363/gnuplot-not-showing-the-graph-window :
    sudo apt-get install gnuplot-x11
    now it works!
    (and when gnuplot starts it says "terminal type set to wxt" instead of unknown)

Q: how to get the graph to be exactly square?
A: set size square

QUESTIONS:
Q: how to get the plot window come up square, and stay that way?


