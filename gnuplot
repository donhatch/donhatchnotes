Great reference: "not so Frequently Asked Questions"
    http://folk.uio.no/hpl/scripting/doc/gnuplot/Kawano/index-e.html (update 2003/9/15)
    http://lowrank.net/gnuplot/index-e.html (update 2005/11/19)

ANSWERED QUESTIONS:

Q: wtf is wrong with my history? when ~/.gnuplot_history gets longer than 961 or so... ?

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

Q: can I set the initial plot window size from the command line?
A:  -geometry 100x100

Q: how to get the plot window and graph come up square, and stay that way?
A:
   set term wxt size 1000,1000  # or x11 if wxt not available
   set size square
   (or for other aspect, e.g. set size ratio 2)

Q: how to print numbers exactly?
A:
   EXACT(z) = imag(z)==0. ? sprintf("%.17g", z) : sprintf("{%.17g, %.17g}", real(z), imag(z))
   print EXACT(sqrt(1/9.))
   print EXACT(sqrt(-1/9.))
   print EXACT((-1)**.25)

Q: Can I increase the recursion depth limit
   to get around "recursion depth limit exceeded"?
   Apparently the default limit is 250.
A: Nope. :-(

Q: Then how the heck do I debug stack overflows?
A: Keep track of recursion level and max recursion level seen.
   When max recursion level seen increases,
   take snapshot of input params.
   When max recursion level seen is 249 (or so), return 0/0
   instead of recursing further.
   Then print the max recursion level and offending params at the end.

Q: Can I print during function evaluation/recursion, for debugging?
A: Accumulate into a string and printing it afterwards, like so:
      traceString = ""
      f(x) = (traceString = traceString . sprintf("f(%.17g) called\n",x), x**2)
      set samples 11
      plot [-1:1] f(x)
      print traceString

Q: Say I have a complex-valued (or multi-valued) function
   that's expensive to compute, and I want to use both parts
   of it (or two functions of it) in a parametric plot.
   Do I have to evaluate the expensive function twice at every plot point?
   E.g.
        set parametric
        i = {0,1}
        f(x,y) = exp(x + y*i) # or something more expensive
        splot real(f(u,v)), imag(f(u,v)), v
   Here's an idea: cache the most recently
    computed value:
        xOfCachedF = NaN
        yOfCachedF = NaN
        cachedF = NaN
        fCached(x,y) = x==xOfCachedF&&y==yOfCachedF ? cachedF : \
                       (xOfCachedF=x,yOfCachedF=y,cachedF=f(x,y))
        splot real(fCached(u,v)), imag(fCached(u,v)), v
    Argh it doesn't work! Doesn't interleave the calls properly;
    apparently it gets all the x's into an array, then all the y's,
    then all the z's.
    To see the unfortunate calling order:
      #!/usr/bin/gnuplot
      set term wxt size 400,400
      set size square
      a(u,v) = (traceString = traceString . sprintf("a(%.17g, %.17g) called\n",u,v), u)
      b(u,v) = (traceString = traceString . sprintf("b(%.17g, %.17g) called\n",u,v), v)
      c(u,v) = (traceString = traceString . sprintf("c(%.17g, %.17g) called\n",u,v), u**2+v**2)
      set parametric
      set samples 5
      set isosamples 3
      traceString = ""
      splot a(u,v),b(u,v),c(u,v)
      print traceString, "====="
      pause -1




Q: Can I make pm3d get the z-order right?
A: Yes! There are a couple of different methods:
   (Same page two different versions I think)
    http://gnuplot.sourceforge.net/demo/hidden2.html
    http://skuld.bmsc.washington.edu/~merritt/gnuplot/demo_canvas/hidden2.html
   The secret seems to be:
        set pm3d
        set pm3d depthorder
   But I haven't figured out how to get this to interact well
   with lines or linespoints of the same surface though :-(
   "help hidden3d" in version 4 for how pm3d is supposed to interact...
   but apparently that will change in version 5.  Bleah!

Q: can I get it to run a script and then take commands from the terminal?
PA: gnuplot myscript.gp -
    (works best if script does *not* end in "pause -1")

Q: can I put a conditional "pause -1" in my script, so that it pauses
   only if not followed by terminal input?

Q: what is GPFUN for?
   "show var GPFUN" shows strings of all function definitions,
   and there is something that explicitly sets it in http://gnuplot.sourceforge.net/demo/hidden2.1.gnu, but I don't know why it does this

Q: Bug? In 4.6 patchlevel 4, if I type "test",
   it shows "8.98847e+307, 8.98847e+307" for the mouse
   and ruler values. (either with term = wxt, or x11)


Q: is there a way to get gnuplot to print how much time certain operations took?
   (i.e. is there a way to get the current time)
A:
   t0 = time(0.)
   t1 = time(0.)
   print sprintf("splot took %.6f seconds.", (t1-t0))

Q: file name extension that's clearly gnuplot?
A: .gnuplot!

Q: can I get command-line arguments into a gnuplot script?
PA:
    Looks like some day "#!/usr/bin/gnuplot -c" will work, but not today.

    See https://groups.google.com/forum/#!topic/comp.graphics.apps.gnuplot/sCOqvk7EzRU, Laurianne Gardeux's answer looks promising:
    Sometimes, I use gnuplot in a here-document:
          #!/bin/sh
          gnuplot <<EOF
             [...] "$VARIABLE" [...]
          EOF
    Unfortunately it doesn't seem to interact well with "pause -1" :-(

Q: how to set top-down viewing angle?
PA:
    set view 0,0,1,1
    set view equal xy

