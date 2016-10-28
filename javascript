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
      - flutures?
      - creed/promises? how does it relate to fantasyland/promises and flutures?
    - cujojs?  what is it and do I want it? he calls it something other
      than "framework", says it's framework-agnostic and in fact facilitates 
      being framework-agnostig
    - https://sanctuary.js.org/

  Things to read when I have time:
    http://blog.briancavalier.com/async-programming-part-1-it-s-messy/
    http://blog.briancavalier.com/async-programming-part-2-promises/
    http://blog.briancavalier.com/async-programming-part-3-finally/

