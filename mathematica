Good docs:
    Introduction to Mathematica, good descr of lambda functions
    http://www.outbacksoftware.com/mathematica/mathematica-intro.html

    Mathematica Tips, Tricks, and Techniques by Michael A. Morrison
    http://www.nhn.ou.edu/~morrison/Mathematica/TipSheets/GettingStarted.pdf

    Ted Ersek's Tricks
    http://www.verbeia.com/mathematica/tips/Tricks.html

    Array Processing Idioms, by Mark D. Reeve (very cool!)
    http://library.wolfram.com/infocenter/Conferences/422/

    A Review of Mathematica (by Richard Fateman)
    http://http.cs.berkeley.edu/~fateman/papers/mma.review.pdf

    Working with Unevaluated Expressions
    http://library.wolfram.com/conferences/devconf99/villegas/UnevaluatedExpressions/index.html

    Controlled Evaluation of Mathematica Expressons  by David Park
    from http://home.comcast.net/~djmpark/Mathematica.html


    thread on strangeness of evaluation
    http://coding.derkeiler.com/Archive/Lisp/comp.lang.lisp/2005-08/msg02051.html


    http://www.physics.ohio-state.edu/~jeremy/mathematica/keybindings/
    http://www.mathematica-users.org/webMathematica/wiki/wiki.jsp?pageName=FAQ_Front_ends



Things I do to customize:
    - make the font bigger (see "How to make the default font bigger" below)
    - Turn off "Show the intro window every time I log in"
    - say no, don't show me again in "why the beep"?
    - Off[General::spell1]
        - can this be done in preferences?
    - Make keyboard shortcuts for quitting the kernel, as follows.
      Put this at the bottom of the "File" menu in
      ~/.Mathematica/SystemFiles/FrontEnd/TextResources/X/MenuSetup.tr :
                , (* don't leave out this comma! *)
                Delimiter,
                Item["(nonstandard) Quit Kernel (sometimes seg faults)", KernelExecute[FrontEndExecute[EvaluatorQuit]], MenuKey["q", Modifiers->{Command}], MenuEvaluator->Automatic], (*XXX ARGH!!!!! SOMETIMES FrontEndExecute[EvaluatorQuit] kills the whole program with a seg fault, in 5.2 :-( *)
                Item["(nonstandard) Quit Kernel Without Confirmation", KernelExecute[Print["- Quitting Kernel -"]; Quit[]], MenuKey["q", Modifiers->{Control, Command}], MenuEvaluator->Automatic] (* sometimes the Print works and sometimes it does nothing. Neat. *)
    - Put this in my ~/.exrc for vim:
        au BufRead,BufNewFile *.mathematicapp set filetype=mma

Things I do in my scratch mathematica scripts:
    (*
        <<"!/path/to/mathematicapp.pl /path/to/this/script.mathematicapp"
    *)
    dummy = 0 (* suppress Remove::rmnsm: There are no symbols matching "Global`*" *)
    Remove["Global`*"]



QUESTIONS (most recent first):

Q: How to make it stop flashing after the mouse is released
   after manipulating a graphic?


Q: Is there a convenient way to browse a large expression tree?
A (partial): TreeForm, but if it's a huge expression that's no good...
   Can use something like this to preprocess.
       TreeFormLimit[expr_,maxChildren_] := TreeForm[expr /. (z : x_[___] /; Length[z] > maxChildren) -> HoldForm[x]["..." <> ToString[Length[z]] <> " args ..."]]
       expr = a + b + c d e f g
       TreeFormLimit[expr,3]
   Bleah, but it gets really small and I don't know how to control it.
   Hmm, what I really want is a tree browser that I can
   expand and collapse levels on.  Surely I can do this via
   notebook levels or something?
   Yes!  Use OpenerView!
   So let's see,
    a b + c d^2 // FullForm
    Plus[Times[a,b],Times[c,Power[d,2]]]
   should turn into some tree of OpenerViews ...
   OpenerView[{Plus,
                {OpenerView[{
                    Times,
                    "..."
                }],
                OpenerView[{
                    Times,
                    "..."
                }]
                }
               }]
   (messing around with this in the directory openerview_mathematica)


Q: How do I place a ContourPlot slice in the same 3d view
   as a ContourPlot3D surface?
A: Well, Show combines graphics,
   so I think the real question is how to turn a 2d graphic
   into a 3d graphic.

Q: Can I make ContourPlot3D faster?

Q: How do I show more than one help window at the same time?
   I've resorted to bringing up the help in a web browser (from the wolfram site)
   instead of the help browser.

Q: How to see the value of a given variable without evaluating it?
   E.g.
       funs = {x,x^2,x^3}
       x = 3
   funs is still {x,x^2,x^3}, (not {3,9,27}), as can be seen from the following:
       Trace[funs]
           {funs, {x,x^2,x^3},{x,3},{{x,3},3^2,9},{{x,3},3^2,27},{3,9,27}}
   however I can't seem to print just the value of funs: {x,x^2,x^3}.
       funs
           {3, 9, 27}
       Unevaluated[funs]
           Unevaluated[funs]
       Hold[funs]
           Hold[funs]
       Trace[funs][[2]]
           {x,x^2,x^3}
   hmm, that works, however it does a lot of extra work in general,
   as demonstrated in the following:
       funs = {x,x^2,x^3,x^Q[]};
       Q := (Print["Hey!!"];0);
       Trace[funs][[2]]
           Hey!!
           {x,x^2,x^3,x^Q[]}
   It looks like maybe the TraceDepth option is supposed to help,
   but it doesn't:
       funs = {x,x^2,x^3,x^Q[]};
       Q := (Print["Hey!!"];0);
       Trace[funs,TraceDepth->1]
           Hey!!
           {funs, {x,x^2,x^3,x^Q[]}, {x,x^2,x^3,x^0[]}}
       funs = {x,x^2,x^3,x^Q[]};
       Q := (Print["Hey!!"];0);
       Trace[funs,TraceDepth->0]
           Hey!!
           {}
   Apparently Trace simply turns on and off internal tracing; I can't get it to inhibit
   inner evaluation like I'd like to.
   TODO: Look at the "OK, here is the real cleverness" part of Scaled plot, /usr/local/Wolfram/Mathematica/5.2/AddOns/StandardPackages/Graphics/Graphics.m , it might have the answer.
   Partial answer:
   You can see it using Definition[funs].
   However Definition just prints the definition; it doesn't return anything
   that you can look at programmatically.

Q: How to tell, within a program, whether two variables
   have identical definitions?  (As reported by Definition or Trace)
   I.e. I want True in this case:
       x = 100
       y = 100
       Definition[x]
           x = 100
       Definition[y]
           y == 100
       x == y
           True
       x === y
           True
       Definition[x]==Definition[y]
           x = 100
           y = 100
   (huh?)
       Definition[x]===Definition[y]
           False
   But I want False in this case:
       x = b
       b = 3
       y = x
       Definition[x]
           x = b
       Definition[y]
           y = 3
       x == y
           True
       x === y
           True
       Definition[x]==Definition[y]
           x = b
           y = 3
   (huh?)
       Definition[x]===Definition[y]
           False
A (partial): The following seems to work,
  although it suffers full evaluation:
       Trace[x][[2]] == Trace[y][[2]]
  (see related question
  "How to see the value of a variable without evaluating it?")


Q: How to define a variable y
   to have the same definition as x,
   as reported by Definition?
   The following doesn't do it:
       x = b
       b = 3
       y = x
       Definition[x]
           x = b
       Definition[y]
           y = 3
A (partial):
  y = Unevaluated[x]
  but that actually sets it to x, not the value of x.
  y = Trace[x][[2]]
  but (1) that actually has a HoldForm in it (use ReleaseHold to use it, which will fully evaluate it)
      (2) it does a whole lot of unnecessary evaluation, as described above

    





Q: Can I make a front-end to Plot (and LogLogPlot, etc.)
   that make it more friendly like gnuplot, so that I can
   plot a bunch of functions with associated colors?
   This is a pain to work with because the functions and colors
   are in two parallel arrays:
       Plot[{x,x^2,x^3},{x,-2,2}, 
            PlotStyle->{RGBColor[1,0,0],RGBColor[0,1,0],RGBColor[0,0,1]}]
       LogLogPlot[{x,x^2,x^3},{x,.1,10},
            PlotStyle->{RGBColor[1,0,0],RGBColor[0,1,0],RGBColor[0,0,1]}]
   Perhaps something like:
       Gnu[Plot,{{x,Red},{x^2,Green},{x^3,Blue}},{x,-2,2}]
       Gnu[LogLogPlot,{{x,Red},{x^2,Green},{x^3,Blue}},{x,1/100,100}]
   And it would be cool if it gave a legend too.
A (partial):
  Definitely read the following, it was indispensible:
        http://library.wolfram.com/conferences/devconf99/villegas/UnevaluatedExpressions/index.html
  Here is an attempt; it seems to get the scoping right (even though LogLogPlot itself doesn't!)
  but the legends leave something to be desired.
    <<Graphics`

    Attributes[Gnu] = HoldAll;
    Gnu[plotfun_, funAndPlotstylePairs_, range:{rangeVar_Symbol,_,_}, opts___] := Module[{heldFuns,heldPlotstyles,template},

        heldFunAndPlotstylePairs = Hold[funAndPlotstylePairs];
        (* fun or {fun} by itself should be the same as {fun,Black} *)
        heldFunAndPlotstylePairs = Replace[heldFunAndPlotstylePairs,fun_:>{fun,Black}/;Head[fun]=!=List,{2}];
        heldFunAndPlotstylePairs = Replace[heldFunAndPlotstylePairs,{fun_}:>{fun,Black},{2}];
        heldFuns = Replace[heldFunAndPlotstylePairs,{first_,_}:>first,{2}];
        heldPlotstyles = Replace[heldFunAndPlotstylePairs,{_,second_}:>second,{2}];

        (* holy mackeral, each bug I fix opens up another can of them... if I just set heldFunStrings to heldFuns, I get 2 y instead of y+y... but if I do this replace with strings instead, then the exponents come out too big *)
        heldFunStrings = Replace[heldFuns,fun_:>ToString[Unevaluated[fun]],{2}];
        heldFunStrings = heldFuns;

        #PRINT[range];
        #PRINT[heldFunAndPlotstylePairs];
        #PRINT[heldFuns];
        #PRINT[heldPlotstyles];
        #PRINT[heldFunStrings];

        (* What we want to evaluate is the following, with Block in place of Hold. *)
        (* note that without the With,
           plotfun and rangeVar and range and opts get substituted in,
           but the values of the local variables do not. *)
        template = With[{heldFuns=heldFuns,
                         heldPlotstyles=heldPlotstyles,
                         heldFunStrings=heldFunStrings},
                        Hold[{rangeVar},
                             plotfun[heldFuns,
                                     range,
                                     PlotStyle->heldPlotstyles,
                                     PlotLegend->heldFunStrings, (* ARGH!!!!!! PlotLegend comes out right in Plot but not in LogLogPlot *)
                                     opts]]];

        (* see the following link if I want to try to get legends working for LogLogPlot:
            http://forums.wolfram.com/mathgroup/archive/2002/Sep/msg00470.html *)

        #PRINT[template];
        (* get rid of Hold at all levels except the top one, i.e. not level 0 *)
        template = Replace[template,Hold[expr__]:>expr,{1,Infinity},Heads->True];
        #PRINT[template];
        (* replace the top-level Hold with Block and evaluate *)
        Block @@ template
    ]

    Gnu[Plot, {{y,Red},{y+y},y+y+y,{y^2,Green},{y^3,Blue}}, {y,-2,2},ImageSize->{400,400}];
    Gnu[LogLogPlot, {{y,Red},{y+y},y+y+y,{y^2,Green},{y^3,Blue}}, {y,.1,10},ImageSize->{150,150}];
    y = 3
    Gnu[Plot, {{y,Red},{y+y},y+y+y,{y^2,Green},{y^3,Blue}}, {y,-2,2},ImageSize->{400,400}];
    Gnu[LogLogPlot, {{y,Red},{y+y},y+y+y,{y^2,Green},{y^3,Blue}}, {y,.1,10},ImageSize->{150,150}];


Q: When Mathematica spits out an answer with lots of ^'s in it,
   how can I copy-paste it as text, without a lot of extra stuff showing up?
   I thought "copy as text" should do it, but it doesn't.
   E.g. I just want x^2 to show up as x^2, not \!\(x\^2\).
   Then I also want a tweaked CForm in which x^2
   comes up as sqr(x) instead of Power(x,2).
   And braces, too
A (partial):
       InputForm[(x^2+1)^2]
            (1 + x^2)^2
       OutputForm[(x^2+1)^2]
                   2 2
             (1 + x )
   (hard to copy-paste that though, usually needs manual tweaking)
       (x^2 + 1)^2 //. x_^2 -> sqr[x] // CForm
          sqr(1 + sqr(x))
   Note that the //. (ReplaceRepeated) is necessary instead of /. (ReplaceAll);
   otherwise we'd get this:
       (x^2 + 1)^2 /. x_^2 -> sqr[x] // CForm  (* WRONG *)
           sqr(1 + Power(x,2))
   Now how about the braces? Not usually a problem,
   except when I'm trying to copy-paste the result of Trace... and even that's not usually a problem:
       Trace[{x+1,y+1}]
           {{x + 1, 1 + x}, {y + 1, 1 + y}, {1 + x, 1 + y}}
           and it copy-pastes fine
   but this is a huge problem:
       Trace[{x^2+1,y+1}]
           {{x^2 + 1, 1 + x^2}, {y + 1, 1 + y}, {1 + x^2, 1 + y}}
           and no way to copy-paste it without a ton
            of nested row-box stuff coming out! what the hell?

Q: What does Axes->Automatic (which is the default) mean?
   I can't seem to find it in any documentation.  Is it different from True?

Q: How do I control the size of the points in ListPlot
   and the vectors in ListPlotVectorField?
   They seem to be random sizes, correlated with image size
   but I don't understand how yet.
A: The answer is in terms of the *width* of the plot ("inner image").
   The default is PointSize[0.008] for 2d graphics and PointSize[0.01] for 3d.
   To express this explicitly, put that PointSize call in the Graphics
   call, or add this option to the ListPlot command:
   PlotStyle->PointSize[.008]
   Note, there seems to be a huge difference between .008
   and .005 ... I think this is a bug.

Q: Okay that controls the point size... what about the arrow head size?
A: There seem to be a ton of options:
     HeadScaling:
         Automatic means relative to width of the graphic
         Relative means relative to arrow length
         Absolute means in device absolute units.
   So make the arrow head size always .25 times the length of the vector,
   use the following:
     HeadScaling->Relative, HeadLength->.25


Q: I always want to do the following, over and over,
   to run a script after I edit it.  Can I do it in just
   one or two keystrokes, so that it doesn't demand my attention every time?
      Arrow up to top
      Arrow down one (to get to the <<myscript command I have on first line)
      Shift-Enter or Numpad-Enter
   Perhaps I can get Ctrl-Enter to do the above?
A (partial): There are keyboard translations in here:
    /usr/local/Wolfram/Mathematica/5.2/SystemFiles/FrontEnd/TextResources/X/KeyEventTranslations.tr
    /usr/local/Wolfram/Mathematica/5.2/SystemFiles/FrontEnd/TextResources/X/MenuSetup.tr
   You can copy them to your local directory to mess with them:
    ~/.Mathematica/SystemFiles/FrontEnd/TextResources/X/
   There are some decent pointers in:
      http://www.mathematica-users.org/webMathematica/wiki/wiki.jsp?pageName=FAQ_Front_ends
    - I don't think it's possible to do more than one front-end command
      in a keyboard shortcut, so this mechanism is useless for what
      I want to do.  XXX oh wait, there are some complicated commands-- are they compound or not?  doesn't look like it but I'm not absolutely sure
   Here is an alternative... put the following on the last line,
   so I can execute it to get back to the top and execute that,
   then end up back on that last line...
        Do[FrontEndTokenExecute[MovePreviousLine], {100}];
        FrontEndTokenExecute[MoveNextLine];
        FrontEndTokenExecute[EvaluateNextCell];
        FrontEndTokenExecute[MoveNextLine];
        FrontEndTokenExecute[MoveLineEnd];
   Or maybe, just put this at the bottom of the script:
        Do[FrontEndTokenExecute[MovePreviousLine], {25}];
        FrontEndTokenExecute[MoveNextLine];
        FrontEndTokenExecute[MoveLineEnd];
   That way it will end up scrolled at the top,
   and just hitting numpad enter (or shift-enter) will re-execute.
   I think I like that best.
   ALTHOUGH... using this method, everything gets completely messed up
   if there are any warnings or errors in the output.  In that case we are much much better off not doing this.  THIS REALLY SUCKS.

Q: How do I define a keyboard shortcut Alt-Q that quits the kernel?
A: See:
      http://www.physics.ohio-state.edu/~jeremy/mathematica/keybindings/
      http://www.mathematica-users.org/webMathematica/wiki/wiki.jsp?pageName=FAQ_Front_ends
   The following is the best I could come up with.
   Alt-Q quits with confirmation (sometimes seg faults),
   Ctrl-Alt-Q quits without confirmation (and prints "Quitting Kernel" when
   you're lucky).
   Note that Mod1 seems to mean Alt.
    % mkdir ~/.Mathematica/SystemFiles/FrontEnd/TextResources
    % mkdir ~/.Mathematica/SystemFiles/FrontEnd/TextResources/X
    % cp /usr/local/Wolfram/Mathematica/5.2/SystemFiles/FrontEnd/TextResources/X/MenuSetup.tr ~/.Mathematica/SystemFiles/FrontEnd/TextResources/X/MenuSetup.tr
    % vi ~/.Mathematica/SystemFiles/FrontEnd/TextResources/X/MenuSetup.tr
                , (* don't leave out this comma! *)
                Delimiter,
                Item["(nonstandard) Quit Kernel (sometimes seg faults)", KernelExecute[FrontEndExecute[EvaluatorQuit]], MenuKey["q", Modifiers->{Command}], MenuEvaluator->Automatic], (*XXX ARGH!!!!! SOMETIMES FrontEndExecute[EvaluatorQuit] kills the whole program with a seg fault, in 5.2 :-( *)
                Item["(nonstandard) Quit Kernel Without Confirmation", KernelExecute[Print["- Quitting Kernel -"]; Quit[]], MenuKey["q", Modifiers->{Control, Command}], MenuEvaluator->Automatic] (* XXX ARGH! sometimes the Print works and sometimes it does nothing.  This is really frustrating.  I'm thinking maybe I should write my own front end, I don't know, I've wasted a ton of time fighting this stuff *)

Q: How to substitute a variable into a formula?
   E.g. Integrate[x,x][y] doesn't work
A: Integrate[x,x][y] /. x->y
   And if foo is a bunch of assignments, e.g. foo = {a->1, b->2}
   then can say a /. foo, to get 1

Q: (posted this to the mathgroup list)
   To: mathgroup@smc.vnet.net
   Subject: please subscribe hatch@plunk.org

   Hello,
   I would like to subscribe to the MathGroup mailing list.
   My e-mail address is:
        hatch@plunk.org
   Thank you!
   Don Hatch
   hatch@plunk.org



   To: support@wolfram.com
   To: mathgroup@wolfram.com
   Summary: variable of integration not localized in Integrate and Sum?

    Apparently I need to explicitly localize t in the following,
    otherwise it messes up when I pass in t as the second argument.
        In:
            F[f_, x_] := Integrate[f[x + t], {t, -1/2, 1/2}]
            F[Sin, x]
            F[Sin, t]
        Out:
            2 Sin[1/2] Sin[x]  <---- correct
            0                  <---- ?!?!
    This is surprising to me-- I thought that
    the fact that t is the integration variable
    would cause it to be automatically localized, but apparently not.
    To get the right answer, I can say:
        In:
            F[f_, x_] := Module[{t}, Integrate[f[x + t], {t, -1/2, 1/2}]]
            F[Sin, x]
            F[Sin, t]
        Out:
            2 Sin[1/2] Sin[x]  <---- correct
            2 Sin[1/2] Sin[t]  <---- correct
    (note, I really have to use Module, not Block-- it still messes up using Block).

    The documentation for Integrate doesn't seem to support my hope that t gets
    localized, as far as I could see;
    however, note that exactly the same problem
    occurs for Sum, whose documentation does explicitly state:
       The iteration variable i is treated as local. 
    So here is an example that seems to clearly contradict the documentation of Sum:
       In:
           F[f_, x_] := Sum[f[x + t], {t, -1/2, 1/2, 1/10}]/11
           F[Identity, x]
           F[Identity, t]
       Out:
           x              <---- correct
           0              <---- ?!?!
    Just as for Integrate, it works properly when I explicitly
    localize using Module (but not Block):
       In:
           F[f_, x_] := Module[{t}, Sum[f[x + t], {t, -1/2, 1/2, 1/10}]/11]
           F[Identity, x]
           F[Identity, t]
       Out:
           x              <---- correct
           t              <---- correct

    Is this a bug in Sum and/or Integrate?
    I'm using Mathematica version 5.2.0.0, on Linux/X.

    Don Hatch



A: I think maybe it doesn't get localized so things like the following
   can work, even though I think this way of doing things is awful:
        f[x_] := x + t
        F[x_] := Integrate[f[x], {t, -1/2, 1/2}]
        F[x]
        F[t]
   I don't think we can have it both ways.
   I'm going to file a bug... (see above).



Q: Is MathReader available to everyone, so that I can distribute my notebooks
   and have it do something?  (Show graphs, etc.)

Q: Can I make a PRINT function, such that: x = 5; PRINT[x] prints "x = 5"?
A: Use a preprocessor; see answer to question about line numbers.
   Barring that, Mathematica's facilities for this are rather unsatisfactory...
       PRINT[x_] := Print[Unevaluated[x], " = ", x];
       SetAttributes[PRINT, HoldAll];
   Or, to get spiffy and allow zero or more arguments:
       PRINT[x___] := Scan[Print[Unevaluated[#]," = ",#]&, {x}]
       SetAttributes[PRINT, HoldAll];
   XXX Note, the latter works from the top level, but doesn't seem to work
   when printing local vars and things inside a function body... weird.
   So just use the single-argument version, I guess.
   Even the single-arg version doesn't work for printing params... weird.
   (It always substitutes the passed-in argument for the param name,
   which is definitely not what I want.)

   I'll post a question about this...

    Subject: debug printing

    When I'm debugging a program, I tend to use a lot of print statements,
    like so:
        Foo[x_,y_] := Module[{i,j,k},
                Print["x = ", x];
                Print["y = ", y];
                i = 20;
                Print["i = ", i];
                Print["x + i + 3 = ", x + i + 3];
                Return[x + i + 3];
            ];
        a = 100;
        Print["a = ", a];
        Print["Foo[a,b] = ", Foo[a,b]];
    The output is:
        a = 100
        x = 100
        y = b
        i = 20
        x + i + 3 = 123
        Foo[a,b] = 123
    This gets tedious and error prone since I'm always typing in
    the same thing twice.
    So my first question is, is it possible to define a PRINT function
    so that I can rewrite the above as:
        Foo[x_,y_] := Module[{i,j,k},
                PRINT[x];
                PRINT[y];
                i = 20;
                PRINT[i];
                PRINT[x + i + 3];
                Return[x + i + 3];
            ];
        a = 100;
        PRINT[a];
        PRINT[Foo[a,b]];
    and get exactly the same output as before?

    The best I could come up with is:
        PRINT[x_] := Print[Unevaluated[x], " = ", x];
        SetAttributes[PRINT, HoldAll];
    But then the output is:
        a = 100                 <--- good
        100 = 100               <--- no good
        b = b                   <--- no good
        i$33 = 20               <--- not good enough
        100 + i$33 + 3 = 123    <--- no good
        Foo[a,b] = 123          <--- good
    So it works well at the global scope, but not well at all
    when trying to print local variables (the names get mangled)
    or function parameters (the names get lost completely).
    I really need to get exactly the same output as I originally listed above,
    or it's not going to be helpful enough to be worth using.

    My second question is, is there a way of getting the current line number
    in the program file that is being executed?
    Something like __LINE__ in the C language preprocessor, so that
    if I want to trace some places in the program, instead of saying:
        Print["I am here"];
        ...
        Print["I am there"];
        ...
        Print["I am some other place"];
    I could just say the following (less effort):
        Print["I am at line ", __LINE__];
        ...
        Print["I am at line ", __LINE__];
        ...
        Print["I am at line ", __LINE__];

    Don Hatch


   




Q: How to delete/undefine a single variable or function definition?
A; lhs =.  or  Unset[lhs]  removes any rules defined for lhs.
   Clear[x, y, ...] clears values and definitions for the symbols.
      Doesn't clear attributes, messages, or defaults associated with them.
   ClearAll[x, y, ...] clears all values, definitions, attributes, messages
      and defaults associated with the symbols.
      (Not that I know what that means... it's explained under 
       examples for Clear though.)
   Remove[x, y, ...] removes symbols completely, so that their names are no
      longer recognized by Mathematica.

   So it seems Remove is the simplest thing to completely remove it,
   however it actually doesn't do what I want at all :-(
        a = {x,y}
            {x,y}
        Remove[x]
        a
            {Removed[x],y}


Q: Can I use my mathematica kernel process across the web?
   (e.g. from work)... It seems like my license allows me
   to run 2 graphical mathematicas and 2 maths (or jmaths...
   something that uses MLink).
A:(partial) look here for advice:
        http://www.mathematica-users.org/webMathematica/wiki/wiki.jsp?pageName=FAQ_Remote_Kernels&action=AlmostEdit
   Or here?
       http://support.wolfram.com/gridmathematica/rsh/overview.html
   Under "Passive Connection", mentions doing this:
       math -mathlink -linkcreate
   But no clue how to use it.
   This is really bizarre.  It's like they purposely omit any
   documentation or clues on how to make it work.
   Let's see, the process table says the kernel is being run as
   "MathKernel -mathlink"... so it's a MathLink connection,
   Ah, and if I run that from the command line, it's going
   into some socket conversation.
   All right, some clues in pdf doc I found on the web called "MathLinkRef.pdf"
   from Mathematica 2.2 back in 1991... page 11
        % MathKernel   (or just math)
            In[1]:= mylink = LinkOpen["5000", LinkMode->Listen]
            Out[1]= LinkObject[5000@192.168.1.2, 32976@192.168.1.2, 1, 1]
   Then netstat says it's listening on those two ports.
   For what exactly? Hmm.
   Okay then if I run Mathematica in a different window as:
        % Mathematica -linkmode connect -linkname 5000
   it brings up the gui but doesn't let me type in it?
   And if I exit the kernel, the gui exits.
   Hmm, or I can start Mathematica as:
        % Mathematica -linkmode listen -linkname 5000
   and then another one as:
        % Mathematica -linkmode connect -linkname 5000
   and if I exit the first one, the second one exits...
   however, they don't seem to be sharing variables??
   Oh, the new one is NOT using that kernel to evaluate stuff...
   so what is it using it for???
   Trying this in the connecting one:
        In[1]: link = LinkOpen["5000", LinkMode->Connect]
        Out[1]: LinkObject[5000@192.168.1.2, 2, 2]
   Ooh!
        In[1]: LinkRead[link]
        $Failed
   :-(
   Oh I see, the LinkOpen just returned something, doesn't really mean
   anything I don't think :-(
   Oh wait, each time I open it, it gives new numbers, e.g. 2,2 then 3,3 ...
   Oh wait, it does that even when I give it non-listening ports,
   so it STILL doesn't mean anything...
   But if I send this...
        LinkWrite[link, "1"]
   then the listening mathematica gives errors about not understanding 1!
   Yay!  Maybe!
   Hmm, now can't even replicate that success.

   All right, let's see if I can do their Peer-to-Peer example
   on page 41...
        session A:
            linkToB = LinkOpen["5000", LinkMode -> Listen]
                LinkObject[5000@192.168.1.2,33010@192.168.1.2, 2, 2]
        session B:
            linkToA = LinkOpen["5000@localhost", LinkMode->Connect]
                LinkObject[5000@192.168.1.2, 2, 2]
        session A:
            LinkWrite[linkToB, N[Pi]]
        session B:
            LinkRead[linkToA]
    ARGH it's just hanging
    More to experiment with, but this sucks so far.
    Really I just want to run a front end on one machine
    and a kernel on another.  Why is it so impossible?

    To follow up on:
        WITM - Web Interface to Mathematica  http://witm.sourceforge.net/ 








        

        



Q: Can I simulate something like command line history editing
   in the gui version?  I.e. hit a key and have it
   copy the previous command...  And completion (of function names or whatever)

Q: Trying to figure out a conformal mapping from square to torus.
   Tried:
       NDSolve[{f'[x]  ==  3 + 1  Cos[f[x]], f[0] == 0}, f[x], {x, 0, 1}]
    but it says:
       NDSolve::ndnum: Encountered non-numerical value for a derivative at x == 0.`
    Tried the examples straight out of the book and same problem!?


ANSWERED (most recent first):

Q: How do I get the exact definition of the default color scheme
   for contour plots, and of other color schemes?
A: The default color scheme for contour plots is called "LakeColors".
       In: ColorData["LakeColors"]
       In: ColorData["LakeColors"]//InputForm
       Out: ColorDataFunction["LakeColors", "Gradients", {0, 1}, 
             Blend[{RGBColor[0.293416, 0.0574044, 0.529412], 
                    RGBColor[0.563821, 0.527565, 0.909499], 
                    RGBColor[0.762631, 0.846998, 0.914031], 
                    RGBColor[0.941176, 0.906538, 0.834043]}, #1] & ]
   That means it's RGBColor[0.293416, 0.0574044, 0.529412] at 0,
                   RGBColor[0.563821, 0.527565, 0.909499] at 1/3, etc.

Q: How to I do something like sprintf?  E.g.
   I need to construct a filename "file%d" % i
A: "file"<>ToString[i]

Q: How to dump a graphic (that took a long time to compute)
   to a file so I can read it back in quickly?
A: g >> "file"
   g << "file"

Q: When I interactively twirl a 3d graphic,
   it always jumps to a new fit when I lift the mouse at the end.
   Is there a way to make it not do that?
A; It can be improved slightly so that it only does that at the beginning:
       Edit -> Preferences -> Interface
            -> Automatically re-fit 3D graphics after rotation -> off
   But it will still jump at the beginning of the first drag
   of any particular object.
   To make it not jump at all, the following option needs to be used
   on the graphic itself:
       SphericalRegion->True
   As of this writing I don't know how to make it stop flashing
   when the mouse is released after manipulating a graphic.

   Refit, nonspherical: bad repeatedly
   Refit, spherical: good
   Don't refit, nonspherical: bad at beginning then good
   Don't refit, spherical: good

Q: Is there a way to make it so I can put a comma
   at the end of every list entry or function argument,
   so that I don't have to mess with the commas every time
   I comment out a row?
A: Put a Sequence[] at the end, e.g.
   M = {
       "one",
       "two",
       "three",
       Sequence[]
   }

Q: The following works:
    Plot[{x,x^2,x^3},{x,-2,2}]
   But sometimes I have a list of functions that came from previous
   calculations; if I try to plot them as follows, it doesn't work:
    funs = {x,x^2,x^3}
    Plot[funs,{x,-2,2}]
   The problem can be fixed by the following:
    funs = {x,x^2,x^3}
    Plot[Evaluate[funs],{x,-2,2}]
   However, that does the wrong thing in the following case:
    funs = {x,x^2,x^3}
    x = 3 (* this should have no effect *)
    Plot[Evaluate[funs],{x,-2,2}] (* plots the wrong functions *)
    Plot[{x,x^2,x^3},{x,-2,2}] (* but this still works fine *)
   So, I don't really want to evaluate funs all the way;
   I only want to evaluate one step and then pass the result to Plot,
   so that Plot will see precisely {x,x^2,x^3}
   (rather than funs or {3,9,27}).
   How?
A:
   Block[{x},With[{funs=funs},Plot[funs,{x,-2,2}]]]
   See http://library.wolfram.com/conferences/devconf99/villegas/UnevaluatedExpressions
   for techniques on how to build the Block local variable list, if it's
   not known beforehand.
   (Weird though... why does Block even work for this?  I thought it just pushed the definition of the var onto a stack that can be popped later, so that the global x=3 would still interfere... but it seems to do more than that here)


Q: What's the difference between Replace and ReplaceAll?
A: ReplaceAll (/.) tries the substitution(s) at all levels and doesn't take a levelspec.
   Replace only tries to apply the pattern at the given levelspec,
   which is {0} by default (i.e. only the top level).

Q: How to gather coefficients of powers of a particular variable
   in a polynomial expression?
A: Collect[expr,x]

Q: What's the most convenient way to do assertions?
A: Can do this:
       ASSERT[cond_] := If[!cond, Abort[]]
   But that doesn't give the line number or anything.
   I added it to my preprocessor mathematicapp.pl, so that
       ASSERT[1+1==Infinity];
   comes out as something like:
       If[!(1+1==Infinity), Print["Assertion failed on line 6: 1+1==Infinity"]; Abort[]];


Q: How do I print a matrix in matrix form,
   evaluating everything with given precision?
   For example, do it to this:
       Table[{1/3.,1/3}, {2}, {2}]
A:
       Table[{1/3.,1/3}, {2}, {2}] // N[#,30]& // MatrixForm // NumberForm[#,30]&
    Or:
       Table[{1/3.,1/3}, {2}, {2}] // MatrixForm // N[#,30]& // NumberForm[#,30]&
    In general, it seems like any formula (involving a MatrixForm or not)
    can be printed numerically to available precision
    using // N[#,30]& // NumberForm[#,30]&
    (why is that so frickin hard??????)
    Also apparently the order of N and MatrixForm can be reversed,
    however, apparently NumberForm must be outside both N and MatrixForm
    to avoid errors.

Q: Why is Integrate all messed up all the time on definite integrals?
A: I don't know, but this works better:
    DefiniteIntegral[f_,{x_,a_,b_}] := Module[{F = Integrate[f,x]}, (F /. x->b) - (F /. x->a)]

Q: What is the easiest way to convert an expression into C code?
A: CForm[expression]

Q: Can I print out the current line number, from within a script?
   $Line apparently refers to the number of statements
   executed so far in the interaction window, not the current line
   in the script.
A: I don't think so directly, but can use
   a simple preprocessing filter on the script,
   either before reading it in, or like this:
   <<"!perl -p -e 's/__LINE__/$./g;' inputfile.mm"
   Can also use cpp, but then have to use () instead of []
   to surround macro args.
   Note that apparently mathematica can tolerate cpp's line number
   directives (they look like '# 1 "foo.mm"') so you don't even need to
   give cpp the -P option.  Oh wait, the line numbers aren't right
   in that case... so use -P after all.
   I like doing this:
       <<"!cpp -P -D'PRINT(x)=Print[#x,\" = \",x]' inputfile.mm"
   Then in the file, can have:
       PRINT(Sin[1.])
       PRINT(__LINE__)
   Drawbacks:
       - requires () instead of []
       - PRINT(Foo[a,b]) must be written PRINT((Foo[a,b]))
       - // messes up everything since cpp thinks it's a comment
   I wrote something called mathematicapp.pl that's better.


Q: How to get help on the current highlighted text if F1 is intercepted
   by my window manager?
A: ctrl-F1 works.

Q: How to delete/undefine all variables and function definitions
   back to what it was when I started?
   ClearAll["*"]... no, that's not right,
   that removes all builtin definitions too!  This sucks.
   Really, I'd like to do what Kernel -> Stop Kernel does--
   is there a way?
A: To stop the kernel: Quit[];
   but has to be done on a separate line from what comes after it,
   or the rest won't get executed.  So it can't be done at the beginning
   of a script, for example.
   See http://www.nhn.ou.edu/~morrison/Mathematica/TipSheets/GettingStarted.pdf
   for the voodoo answer, which seems to properly remove everything...
        Remove["Global`*"]
   And to list what I have currently defined:
        ?Global`*
   or Names["Global`*"]
   So for hacking around, it's convenient to put Remove["Global`*"]
   at the beginning of the script; I do this:
        dummy = 1 (* to avoid warning if nothing exists yet *)
        Remove["Global`*"]



   Note, there is also a CleanSlate utility that does more than this,
   I'm not sure if it actually works though (it says it's
   supposed to be read at the end of init.m so it knows
   what the initial state was, but then it looks like it doesn't 
   get loaded automatically at all so that probably doesn't work).
        <<Utilities`CleanSlate`
        CleanSlate[]



Q: In Plot and similar functions, what exactly does AspectRatio mean?
   In particular, what do AspectRatio->1 and AspectRatio->Automatic mean?
   The doc says it's the ratio of the height to the width of the final image.
   But what if I give an explicit width and height,
   using ImageSize?  How do these two options interact, exactly?
A: Think of it as an "inner" and "outer" image.
   The inner image is always contained in the outer image,
   and is centered inside it, and at least one of the two dimensions match.
   ImageSize gives the size of the "outer" image.
   AspectRatio controls the shape (height/width) of the "inner" image.
   AspectRatio->Automatic means no distortion, x and y are scaled the same
   (which can produce a non-square image if the bounds are different
   in x and y).
   AspectRatio->1 means the inner image will be square (even if its size
   is different in x and y, in which case square means distorted).
   The default is AspectRatio->1/GoldenRatio, which is rather bizarre.
   I almost always want AspectRatio->Automatic.
   
Q: How do I assign the result of Solve or FindRoot to a variable?
   E,g, Solve[{a == 10, b == 20}, {a, b}]
   produces {{a -> 10, b -> 20}}.
A: Solve[{a == 10, b == 20}, {a, b}][[1]][[1]][[2]] gives 10.
   Or, better:
        a /. Solve[{a == 10, b == 20}, {a, b}][[1]]

Q: What is an example where I would want to use = instead of :=
   for a function definition?
A: I think = would be used if the function body can be simplified
   symbolically and it takes a long time, and we don't want
   to suffer that overhead each time the function is evaluated.
   I've also found a difference when plotting:
   if the function being plotted is defined using :=
   then I think each evaluation gets done numerically
   using the function body as is; but if the plotted function
   is defined using =, the function body will be evaluated
   as much as possible symbolically first (during the evaluation
   of the =, not during the plotting),
   which can make the function evaluations during plotting much faster.
   For example:
        In:
            F[f_,d_] := Module[{x}, Integrate[x f[x] 2 Sqrt[1-(d/x)^2],  {x,d,1},Assumptions->{0<d, d<1}]];
            f3[x_] := 1/2 - (2 x - 1)^3/2;
            Timing[F3[x_] := F[f3,x]][[1]]
            Timing[Plot[{F3[x]},{x,0,1}]][[1]]
        Out:
            0. Second
            18.1952 Second
        In:
            F[f_,d_] := Module[{x}, Integrate[x f[x] 2 Sqrt[1-(d/x)^2],  {x,d,1},Assumptions->{0<d, d<1}]];
            f3[x_] := 1/2 - (2 x - 1)^3/2;
            Timing[F3[x_] = F[f3,x]][[1]]
            Timing[Plot[{F3[x]},{x,0,1}]][[1]]
        Out:
            6.22205 Second
            3.19951 Second
    So the latter is preferable.
    Note, see http://www.verbeia.com/mathematica/tips/HTMLLinks/GraphicsTricks_41.html
    which suggests using Evaluate on the argument to Plot
    actually that's only very slightly better than the really slow way.  Weird.
        In:
            F[f_,d_] := Module[{x}, Integrate[x f[x] 2 Sqrt[1-(d/x)^2],  {x,d,1},Assumptions->{0<d, d<1}]];
            f3[x_] := 1/2 - (2 x - 1)^3/2;
            Timing[F3[x_] := F[f3,x]][[1]]
            Timing[Plot[{Evaluate[F3[x]]},{x,0,1}]][[1]]
        Out:
            0. Second
            16.9544 Second

Q: Is there a list of keyboard shortcuts?
A: Yes, type "keyboard shortcuts" in the master index,
   and follow the link "on X" (or whatever platform you're on).


Q: How to get it to play sounds?  Double-clicking on the graphics
   in the examples like it says doesn't work.
A: http://support.wolfram.com/mathematica/graphics/sound/nosound.html
   Basically, it's sorta not supported, but there's a little module that can
   be downloaded that gets the program "play" to play sounds.
   In the sound demos, I still couldn't get double-clicking on the graphic to do it,
   but evaluating the cells in the Implementation worked.
   Also, there is a call to OpenTemporary[] which cause warnings;
   change it to OpenTemporary[BinaryFormat->True] to suppress the warnings.

Q: I can combine one or more ListPlots along with other stuff by, for example:
        listplot = ListPlot[{{-1,-1},{1,1}}];
        circle = Graphics[Circle[{0,0},1]];
        Show[listplot, circle, AspectRatio->Automatic];
   But this also draws the ListPlot by itself first-- can I suppress that?
A: From http://forums.wolfram.com/mathgroup/archive/2004/Feb/msg00600.html:
   Method #1 (pretty lame):
        listplot = ListPlot[{{-1,-1},{1,1}}, DisplayFunction->Identity];
        circle = Graphics[Circle[{0,0},1]];
        Show[listplot,circle, AspectRatio->Automatic, DisplayFunction->$DisplayFunction];
   Method #2:
        listplot = Block[{$DisplayFunction=Identity}, ListPlot[{{-1,-1},{1,1}}]];
        circle = Graphics[Circle[{0,0},1]];
        Show[listplot,circle, AspectRatio->Automatic];
    Method #3 (best I think):
        ListPlotNoDisplay[args_] := Block[{$DisplayFunction=Identity}, ListPlot[args]]
        listplot = ListPlotNoDisplay[{{-1,-1},{1,1}}];
        circle = Graphics[Circle[{0,0},1]];
        Show[listplot,circle, AspectRatio->Automatic];



Q: How to source a file?  (like "source" in shells, "execfile" in python)
A: <<filename
   If it has funky chars (some big ol' list of chars, try it and find out,
   or see doc for Get to see the list),
   then you'll need to quote the filename:
   <<"filename"
   << is an abbreviation for Get.

Q: How to evaluate a string, like eval in perl?
   or eval (for expressions) or exec (for statements) in python?
A: ToExpression["string"]

Q: How to Print without a newline?
A: If you use a bunch of WriteString["stdout", x,y,z]'s,
   you won't get newlines between them; however
   you'll get a newline before the next Print.
   Probably that's the best you can do... but see the following...

Q: How to Print[x,y,z] with n spaces prepended?
A:
    Spaces[n_] := StringJoin[Table[" ",{n}]]
    PrintIndented[n_,stuff___] := Print[Spaces[n], stuff]

Q: Given list = {x,y}, how to express f[x,y]?
A: Apply[f,list] or f @@ list
   Also Sequence can be used to combine argument lists:
       f[a,Sequence[b,c]] is f[a,b,c].
   So  f[a,Sequence @@ {b,c}] is f[a,b,c]
   (so Sequence@@ is the opposite of List,
   recalling List is the same as curly braces)
   which can also be written without Sequence as:
       f @@ ({a} ~Join~ {b,c})
    And
       f[Sequence @@ {x,y}] is f @@ {x,y} is f[x,y]

Q: How to define a function with a variable number of args?
A: Two underscores match one or more arguments, three underscores
   match zero or more arguments;  the value of the corresponding param
   inside the function body will be a sequence rather than a list;
   if you want a list from it, apply the List function to it (or equivalently,
   surround it in curly braces).
   E.g.
       In: foo[x___] := x; foo[1,2,3]
       Out: Sequence[1,2,3]
       In: foo[x___] := List[x]; foo[1,2,3]
       Out: {1,2,3}
       In: foo[x___] := {x}; foo[1,2,3]
       Out: {1,2,3}
   The reference for this stuff can be found in the following
   sections of The Mathematica Book:
        2.3.8 Functions with Variable Numbers of Arguments
        2.3.9 Optional and Default Arguments
        2.3.10 Setting Up Functions With Optional Arguments
   (start with "Optional Arguments" in the help browser)
   and:
        Mathematica Reference Guide -> Input Syntax -> Operator Input Forms
Q: But what about the following (from http://library.wolfram.com/conferences/devconf99/villegas/UnevaluatedExpressions/index.html)... what do the ellipses mean?
       fL[iterand_, iterSpecs:{_Symbol,__}...] := Module[{},0]
A (partial): Look at the help page for Pattern (:) and Repeated (p..) and RepeatedNull (p...).
  s_ is actually shorthand for s:_ .


Q: Is there a general way to make lambda-functions on the fly
   like in python, perl, haskell, lisp?
   In particular, for passing to functions like map, grep, and sort.
   Example:
        perl -e 'print map({$_+1} (1,2,3))'
        perl -e 'print sort({$b-$a)} (1,2,3))'
        python -c "print map(lambda x:x+1, [1,2,3])"
        python -c "list = [1,2,3]; list.sort(lambda a,b:b-a); print list"
A: See "Pure Functions" in the help page.
   Put & after the expression to make it a pure function,
   (body& is the same as Function[body]).
   and use # or #1 for the first param, #2 for the second,
   etc., ## or ##1 for all args, ##3 for 3rd and subsequent args...
   #0 is the function itself, in case you want to recurse.
   (XXX how to mutually recurse between two lambda functions?)
   (XXX can I nest two pure functions while still using the & form? probably not)
   If you want to name the params instead of using #1,#2,...,
   use Function[x,body] or Function[{x1,x2,...},body];
   Examples:
        Map[Function[x,x+1], {1,2,3}]
        Map[(#+1)&, {1,2,3}] (same thing since & is Function
        Map[#+1&, {1,2,3}]   (same thing since & has low precedence
        #+1& /@ {1,2,3}      (same thing since /@ is Map, and the spaces aren't needed)
        Sort[{1,2,3}, #1>#2&]  (note this takes a boolean like in C++, not int)

Q: What's the difference between Module and Block?
A: From http://www.codecomments.com/archive382-2005-6-514050.html:
    Jens-Peer Kuska
    2005-06-01, 9:10 am
        Hi,

        Block[] create a new variable only if it does not
        exist and all functions
        called from the block can access the variables
        created by Block[].

        Module[] create always new variables and no
        function called from Module[] can
        easy access the local variables from the caling
        Module[].

        Regards
        Jens
   So, here is the key difference in action:
        In:
            foo = 10;
            PrintFoo[] := Print[foo]
            Module[{foo}, foo = 20; PrintFoo[]]
        Out:
            10

        In:
            foo = 10;
            PrintFoo[] := Print[foo]
            Block[{foo}, foo = 20; PrintFoo[]]
        Out:
            20
    It seems like the only reason for ever using Block
    is if we want to temporarily change a (more) global variable
    (such as $MaxExtraPrecision $DisplayFunction);
    otherwise use Module.

Q: how to cancel a too-long-running calculation?
A: Alt-comma  (although after I canceled that once, I couldn't seem to do it
   again; got an assertion failure after some number of these, not sure how).

Q: How to make the default font bigger?  Superscripts and subscripts
   are unreadable.  E.g. x^x, or x^x^x^x^x
A: Can zoom up anything by selecting it ant Alt(=) (down by Alt(-)),
   but the default font is under
   Edit->Preferences-> Notebook Options -> Display Options -> Magnification
   change it from 1 to 1.05556 or higher (empirically).  Some levels
   come out weird though, e.g. 1.25 seems weird but 1.2 seems fine.
   Experiment.

Q: how to make a mathematica launcher for gnome?
A: Right click on a gnome-panel -> add to panel... Custom Application Launcher
    Name: Mathematica 5.2
    Command: /usr/local/Wolfram/Mathematica/5.2/Executables/mathematica
    Icon: /usr/local/Wolfram/Mathematica/5.2/SystemFiles/FrontEnd/SystemResources/X/Mathematica.xpm
    (or some customized version of it-- I used gimp
     to replace the red border with a gray one)
Q: how about in kde?
A: I don't know the right way to make a custom app launcher,
   so I did this:
    Right click on the bottom panel -> add -> application button -> system tools -> terminal
    Right click on the new terminal launcher -> properties
        General tab
            clicked on the icon
                changed it to /usr/local/Wolfram/Mathematica/5.2/SystemFiles/FrontEnd/SystemResources/X/Mathematica.xpm
                or my local customized version of it, which is
                    /home/hatch/share/mathematica/Mathematica_noborder_30x30.xpm
        Application tab
            Changed Name from "Terminal" to "Mathematica 5.2"
            Changed Comment from "Command line" to empty
            Changed Command from "konsole" to "/usr/local/Wolfram/Mathematica/5.2/Executables/mathematica"
  
Q: How to show graphics in mode where I can spin them?
A:
        <<RealTime3D`
    Then all graphics come out rotateable (ctrl-drag to scale,
    hitting control after mouse button down).
    Although, it's not double-buffered, which is really lame.
    To change back:
        <<Default3D`
    A simple test:
        <<RealTime3D`
        Plot3D[Sin[x y], {x, 0, 4}, {y, 0, 4}];

    Tried choosing different visuals using mathematica -visualChooser,
    but it just core dumped if I chose anything
    other than 0x23 which is the default.
    WEIRD though... if I choose 0x23 explicitly (even though I know
    it's the default), or if I run using mathematica -best,
    then the first time I click
    and drag, it's good!!!  But then it reverts to lousy. :-(


    And, there is a library called MathGL3d which does this:
        http://phong.informatik.uni-leipzig.de/~kuska/mview3d.old.html
    Downloaded mlg2_2linux.tar.gz and followed the instructions
    here:
        http://www.biwako.ne.jp/~hidekazu/mathgl3d/mathgl3de.htm
    Apparently also needs you to make the executable executable:
        % cd /usr/local/Wolfram/Mathematica/5.2/AddOns/Applications/MathGL3d/Binaries/Linux
        % chmod +x mathview3d
    But do NOT follow those instructions to run it; instead,
    run mathematica and look in help -> Add-ons & Links -> OpenGL Viewer
        Get["MathGL3d`OpenGLViewer`"]
        MVClose[]
    Hmm, kind sucky :-(  Trackball is not a trackball, and off by default.

    There are links to other mathematica viewers at bottom of here:
     http://wwwvis.informatik.uni-stuttgart.de/~kraus/LiveGraphics3D/links.html

    Yeah!  This one is great... read the section on interfacing
    with jlink.  I have no idea what it means yet,
    but this seems to be the way.
        http://www.vis.uni-stuttgart.de/~kraus/LiveGraphics3D/documentation.html#subsection:%20Install-JLink
    
    

Q: How to express an abbreviation for the result of the previous command?
A: %

Q: How to pick the solution of an equation that has
   a given property?  Solve[{x*x == 4, x > 0}, {x}] doesn't work...
A: FindInstance[{x*x == 4, x > 0}, {x}]  , or
   FindInstance[x*x == 4 && x > 0, {x}]

Q: what is math vs. mathematica?
A: math is the command line interface, mathematica is the full gui.
   I'd use math, but it doesn't have command line history editing :-(

Q: Has someone done a command line history editing interface to math?
A: jmath uses gnu readline, but it doesn't work very well for correction :-(



THINGS THAT SIMPLIFY DOESN'T KNOW ABOUT:
    - Cos[ArcCos[x]/2] // FullSimplfy
      should be Sqrt[(x+1)/2], although the following works:
      Cos[ArcCos[x]/2] - Sqrt[(x+1)/2] // FullSimplify



====================================================================
Examples where mathematica falls down repeatedly:

X = y/Sqrt[x^2 + y^2] // FullSimplify
Y = y/Sqrt[x^2 + y^2 + (1 - Sqrt[1 - (x^2 + y^2)])^2] // FullSimplify
FullSimplify[X Sqrt[1 - Y^2] - Y Sqrt[1 - X^2], x > 0 && y > 0]
Answer should be:
     (-x y + y Sqrt[ 2 - y^2 - 2 Sqrt[1 - x^2 - y^2]])
    /Sqrt[(x^2 + y^2) (2 - 2 Sqrt[1 - x^2 - y^2])]
or something


....
sculpting it to be robust...

or
    (y Sqrt[1 + Sqrt[
      1 - x^2 - y^2]] (-x + Sqrt[
         2 - y^2 - 2 Sqrt[1 - x^2 - y^2]]))
    /(Sqrt[2] (x^2 + y^2))

or
      (y (x^2 + y^2))
    / (Sqrt[2] (1 + Sqrt[1 - x^2 - y^2])^( 3/2) (x + Sqrt[2 - y^2 - 2 Sqrt[1 - x^2 - y^2]]))
by jove, that may be it
