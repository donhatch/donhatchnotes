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
  See dojo notes in separate file.


QUESTIONS:
==========

Q: given that both object and JSON define objects as non-ordered,
   and there is this bug https://bugs.chromium.org/p/v8/issues/detail?id=164
   that will probably never be fixed,
   is there an alternative to object that keeps things ordered,
   with an alternative to JSON.parse/JSON.stringify
   for serializing/deserializing?
   The grammar for the serialization would be identical to that of JSON
   but with different semantics (namely, objects are ordered).

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
      - promises+generators? "control flow utopia" as forbeslindesay calles it.
                https://www.promisejs.org/generators/
                http://colintoh.com/blog/staying-sane-with-asynchronous-programming-promises-and-generators
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
       - ES7 async?  Hmm it's here already?!  (the "co" library is supposed to be a stepping stone to it, so I probably don't need co.)
         This talks about it:
             https://davidwalsh.name/async-generators
         and says "in the meantime, libraries like asynquence give us these runner utilities to make
         it pretty darn easy to get the most out of our asynchronous generators".
         Hmm here are some articles that seem to say it's not so great:
           https://spion.github.io/posts/es7-async-await-step-in-the-wrong-direction.html
           http://calculist.org/blog/2011/12/14/why-coroutines-wont-work-on-the-web/  conclusion: "generators yes, coroutines no". that was 2011.
         So, would they think asynquence has the same problems, whatever those problems are.
         Oh, OUCH!  I think it's due to the possibility of a thing I thought was transactional no longer being,
         due to something I call unexpectedly awaiting.  See example in second article.
         Hmm, but... don't async functions have to declare that they are async?  So it's not true that "you never know when someone might call yield";
         only functions declared "async" can, right?  Not sure whether that helps.
          


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

Q: how to remove an event listener?
PA: removeEventListener, but it says it has to be a "named external" function.
    However, the following seem like fine solutions that *don't* require
    it to be external:
      http://stackoverflow.com/questions/4878805/force-javascript-eventlistener-to-execute-once#comment-65537773
      http://hastebin.com/ikixonajuk.coffee
      https://www.broken-links.com/2013/05/22/removing-event-listeners-with-anonymous-functions/
      http://stackoverflow.com/questions/4616525/javascript-removing-an-anonymous-event-listener#answer-4616564
      http://stackoverflow.com/questions/4616525/javascript-removing-an-anonymous-event-listener#comment-5076539
