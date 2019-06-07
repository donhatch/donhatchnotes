Q: how to profile java?
A: Use hprof, as described in:
   https://dzone.com/articles/java-memory-and-cpu-monitoring-tools-and-technique
   The official doc is:
    https://docs.oracle.com/javase/8/docs/technotes/samples/hprof.html
    https://docs.oracle.com/javase/8/docs/technotes/guides/troubleshoot/tooldescr008.html

   Q: I'm unclear about whether I'm supposed to use it during compiling, or running, or both.

   Trying just runtime, for starters:
   So if my original command was:
     make && java -jar donhatchsw.jar puzzleDescription="frucht 9(20)" futtIfPossible=true
   my profiled command should be:
     make && java -agentlib:hprof=cpu=samples -jar donhatchsw.jar puzzleDescription="frucht 9(20)" futtIfPossible=true
   And a report comes out in java.hprof.txt.

   Hmm, it's not believable.  The top traces are *near* where I expect them to be (that is, in the same function)
   but they are in places near the end of the function, which I believe can't be the bottleneck.


