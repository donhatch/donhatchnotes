Great book: "Javascript: The Good Parts" by Douglas Crockford

Nice tool, should be very useful for, e.g., mitigating variable scoping surprises:
  http://jshint.com/

Great doc about mouse events and what happens in different
browsers: "Javascript Madness"
    http://unixpapa.com/js/mouse.html

Clearest description of automatic semicolon insertion, maybe:

  http://lucumr.pocoo.org/2011/2/6/automatic-semicolon-insertion/
  http://cjihrig.com/blog/the-dangers-of-javascripts-automatic-semicolon-insertion/

  http://inimino.org/~inimino/blog/javascript_semicolons
  http://blog.izs.me/post/2353458699/an-open-letter-to-javascript-leaders-regarding

Good debugging tips: (TODO: read it thoroughly)
  http://alistapart.com/article/advanced-debugging-with-javascript

Javascript frameworks:
    https://en.wikipedia.org/wiki/Comparison_of_JavaScript_frameworks
  I'm not really attracted to frameworks in general, except Dojo is appealing
  because it has a really excellent-looking ui toolkit called Dijit, with a nice demo page:
    http://archive.dojotoolkit.org/nightly/dojotoolkit/dijit/themes/themeTester.html
  Haven't explored it much though.


QUESTIONS:
==========

Q: still don't have a good mnemonic for what I have to remember :-(

Q: how to test whether something is a string?
A: typeof x == "string"
   note that this doesn't work: x instanceof String
   because typeof(new String) is "object".
   inexact: x instanceof String

Q: stringify/EXACT function?
PA: JSON.stringify

More Gotchas:
 - NEVER use "for i in array" to iterate over an array! Lots of explanations on the web,
   but the jist of it is that it will work but i will be a string, not an int--
   lots of unnecessary conversion back and forth!


GIANT WTF:
// http://stackoverflow.com/questions/1063007/how-to-sort-an-array-of-integers-correctly
someone gives a function that only returns bools, when it should return ints... but it seems to work regardless!? wtf!?


Q: My main overall question is:
  What's a good set of libraries (framework? don't know what to call it)
  with which to do javascript work?
  My impressions so far are:
    - dojo has nicest looking ui toolkit dijit
    - stay away from Promises/A+ as much as possible, they are a bloody mess.
      But what to use instead?
      - fantasyland/promises?
         pro: thenables are not treated specially
         pro: very small implementation
         pro: author seemms to care about clean semantics
         con: lack of SetTimeout stuff makes me think it's prone
              to stack overflow?
         con (dealbreaker): doc is too minimal and cryptic to be useful
              (but illuminated at least somewhat by reading https://sanctuary.js.org/, maybe)
              (hmm, is this an introduction to fantasyland? https://james-forbes.com/?/posts/the-perfect-api)
      - flutures?
          https://github.com/Avaq/Fluture
          https://github.com/Avaq/Fluture/wiki/Comparison-to-Promises
          https://github.com/Avaq/Fluture/wiki/Comparison-of-Future-Implementations
         I think this just a concrete example of fantasyland?
         pro: just like promises but without the thenable crap? sounds perfect!
         pro: good doc!
         con (maybe): stateless, doesn't remember result?
                I'm confused and not sure how this could possibly work.
                But, they say Future.cache() can deal with that?
      - creed/promises? how does it relate to fantasyland/promises and flutures?
        pro: seems to support both Promises/A+ (a "then" method) and fantasyland (other methods)?
        con: documentation isn't readable enough to figure out whether it meets my needs
        Hey WAIT a minute!  I thought it claims to be fantasyland-compliant...
        but aren't the following doing that crappy automagic that makes
        it do something different based on whether something is a thenable or not??
          http://blog.briancavalier.com/creed/#api-make-promises-future-resolve-resolve-e-a-promise-promise-e-a
          http://blog.briancavalier.com/creed/#api-make-promises-resolve-athenable-e-a-promise-e-a
        PA: well, resolve does... but don't use it!  Use fulfill instead; that doesn't do the automagic.
            But, future() does the automagic I think... do I need future()?
            I'd kinda like to program in a way that never does that automagic.
        PA: Maybe that's to support Promises/A+ then?  Yeah I think so-- this promises implementation
            actually supports both.
        PA: but does this do the automagic too??
            http://blog.briancavalier.com/creed/#api-control-time-delay-int-apromise-e-a-promise-e-a
            In which case, how do I do a delay without automagic??
            I can't figure out whether he likes the automagic or not.
            Seems like if he doesn't, he has to stay away from anything
            that has "|Promise" in its type signature:
              runPromise
              future
              resolve
              then
              catch
              delay
            Note that eir wrapper for XMLHttpRequest uses runPromise which does the automagic (I think).
            So, how would I wrap it in a way that doesn't use runPromise?
        PA: starting to think maybe I want fluture instead?  Maybe ask on creed's chat room?
            Actually fluture's doc is *way* more accessible language. maybe just use it.
      - promises+generators?
         pro: very clean expression of coroutines
         con: farther and farther from comprehensibility by a newbie
         con: still "then"-diseased... I think?
      - asynquences?
         Seems to be promises+generators and something more?
         pro: seems like a lot of thought was put into making this as clean and usable as possible.
         pro: very accessible doc
         con: some of the important supporting articles are on blog.getify.com (Kyle Simpson's website)
              which no longer exists, or lead to broken links
         Q: is it still "then"-diseased, or not?? there's something called "then" but I'm not sure it's
            the diseased Promises/A+ "then".
         A: No!  read https://github.com/getify/asynquence#promisesa-compliance: 
            "Trying to do so will likely cause unexpected behavior, because Promises/A+ insists on problematic (read: "dangerous") duck-typing for objects that have a then() method, as asynquence instances do."
            So ey's on board!  And there are utilities for interoperating.
            This is looking really good so far!
          


    - cujojs?  what is it and do I want it? he calls it something other
      than "framework", says it's framework-agnostic and in fact facilitates 
      being framework-agnostic
    - https://sanctuary.js.org/ : "refuge from unsafe javascript" ?

  Things to read when I have time:
    http://blog.briancavalier.com/async-programming-part-1-it-s-messy/
    http://blog.briancavalier.com/async-programming-part-2-promises/
    http://blog.briancavalier.com/async-programming-part-3-finally/
  oh wait, I think this is better:
    http://know.cujojs.com/tutorials/async/async-programming-is-messy.html.md
    http://know.cujojs.com/tutorials/async/simplifying-async-with-promises
    http://know.cujojs.com/tutorials/async/mastering-async-error-handling-with-promises

