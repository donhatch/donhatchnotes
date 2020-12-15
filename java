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

Q: Why is javac -source 1.5 allowing @Override on interface methods?
   asked as https://stackoverflow.com/questions/63541942/why-is-javac-source-1-5-allowing-override-on-interface-methods
A: Apparently @Override on interface methods isn't regarded as a language change,
   but, rather, a bug in some 1.5 SDK compilers.

Q: Do I like GroupLayout?
   PA: docs:
   https://docs.oracle.com/en/java/javase/15/docs/api/java.desktop/javax/swing/GroupLayout.html
   https://docs.oracle.com/javase/tutorial/uiswing/layout/group.html
     https://docs.oracle.com/javase/tutorial/uiswing/layout/groupExample.html
A: Well, it helps to write a subclass ConciseGroupLayout with helpers seq,par,
   so that, for example, the bulk of the tutorial example can be rewritten from this:
        layout.setHorizontalGroup(layout.createSequentialGroup()
            .addComponent(label)
            .addGroup(layout.createParallelGroup(LEADING)
                .addComponent(textField)
                .addGroup(layout.createSequentialGroup()
                    .addGroup(layout.createParallelGroup(LEADING)
                        .addComponent(caseCheckBox)
                        .addComponent(wholeCheckBox))
                    .addGroup(layout.createParallelGroup(LEADING)
                        .addComponent(wrapCheckBox)
                        .addComponent(backCheckBox))))
            .addGroup(layout.createParallelGroup(LEADING)
                .addComponent(findButton)
                .addComponent(cancelButton))
        );
        layout.setVerticalGroup(layout.createSequentialGroup()
            .addGroup(layout.createParallelGroup(BASELINE)
                .addComponent(label)
                .addComponent(textField)
                .addComponent(findButton))
            .addGroup(layout.createParallelGroup(LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGroup(layout.createParallelGroup(BASELINE)
                        .addComponent(caseCheckBox)
                        .addComponent(wrapCheckBox))
                    .addGroup(layout.createParallelGroup(BASELINE)
                        .addComponent(wholeCheckBox)
                        .addComponent(backCheckBox)))
                .addComponent(cancelButton))
        );
    to this:
        setHorizontalGroup(seq(label,
                               par(LEADING,
                                   textField,
                                   seq(par(LEADING, caseCheckBox, wholeCheckBox),
                                       par(LEADING, wrapCheckBox, backCheckBox))),
                               par(LEADING, findButton, cancelButton)));
        setVerticalGroup(seq(par(BASELINE, label, textField, findButton),
                             par(LEADING,
                                 seq(par(BASELINE, caseCheckBox, wrapCheckBox),
                                     par(BASELINE, wholeCheckBox, backCheckBox)),
                                 cancelButton)));
    However, overall I don't like it.
    The killer for me is that it *requires* each component
    to be a variable, since each must be referred to twice.
    So it's impossible to just create anonymous stuff on the fly,
    as can be done with any other layout, e.g.
        add(new JLabel("Hey"));
    I suppose further helpers might help?  E.g. something like:
        setGrouping(row(label,
                        col(textField,
                            grid(2,2, caseCheckBox, wrapCheckBox, wholeCheckBox, backCheckBox)),
                        col(findButton, cancelButton)))
    which is how I'd probably code it, but to fully express all the original constraints,
    it would be:
        setGrouping(grid(3,2, label, textField, findButton,
                              null,  grid(2,2, caseCheckBox, wrapCheckBox, wholeCheckBox, backCheckBox), cancelButton))
    (I'd have to figure out the BASELINE and LEADING stuff.)
                         



