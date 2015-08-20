Great doc about mouse events and what happens in different
browsers: "Javascript Madness"
    http://unixpapa.com/js/mouse.html



Clearest description of automatic semicolon insertion, maybe:

http://lucumr.pocoo.org/2011/2/6/automatic-semicolon-insertion/
http://cjihrig.com/blog/the-dangers-of-javascripts-automatic-semicolon-insertion/


http://inimino.org/~inimino/blog/javascript_semicolons
http://blog.izs.me/post/2353458699/an-open-letter-to-javascript-leaders-regarding

Q: still don't have a good mnemonic for what I have to remember :-(

Q: how to test whether something is a string?
A: typeof x == "string"
   note that this doesn't work: x instanceof String
   because typeof(new String) is "object".
   inexact: x instanceof String

Q: stringify/EXACT function?
