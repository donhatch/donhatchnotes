Useful settings:

# from "help set"
set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error when substituting.
#set -v # Print shell input lines as they are read. (like set verbose in tcsh)
#set -x # Print commands and their arguments as they are executed. (like set echo in tcsh)



==============================================
Questions about bash:

Q: how to make an alias understand commands?
A: you can't; use functions

Q: how to list functions?
A: declare

Q: how to list a function's source?
A: type <functionName>

Q: rehash?
A: hash -r

Q: unsetenv?
A: unset

Q: set time = 0?  (i.e. time every command)
   (in general, bash's timing output seems pretty lame compared to tcsh's.)
   (bleah, seems totally impossible)

Q: arg processing?
A: here's an example, although there are several ways:
      #!/bin/bash

      echo "    0: '$0'"
      echo $# args:
      args=("$@")
      for ((i = 0; i < $#; i++)) {
          echo "    $((i+1)): '${args[$i]}'"
      }

      while test $# -gt 0
      do
          if [ "$1" == "-exec" ]
          then
              shift
              echo "Executing '"$@"' or something..."
              exec "$@"
          fi
          shift
      done

Q: in a wrapper bash script, how do you quote the args so that the exec'ed
   program sees the exact same args?
A: exec otherprogram "$@"

Q: boolean expressions?
A: http://stackoverflow.com/questions/48774/boolean-expressions-in-shell-scripts

Q: canonical function syntax for readability? (I know there are several)
A: I have no idea.  The options are:
       function myFunction { commands; }
       myFunction() { commands; }
   The following seems to work too, so I'll use it:
       function myFunction() { commands; }

Q: for loop on a line?
A:
   for x in *.cc; do echo $x; done
   for x in a b c; do echo $x; done
   for x in `echo a b c`; do echo $x; done

Q: if true?
A: if true; then echo foo; fi

Q: while true?
A: while true; do echo $x; done

Q: repeat 10 date?
A: for i in {1..10}; do echo "i = $i"; done
   for i in {0..10..2}; do echo "i = $i"; done
   for (( c=0; c<5; c++ )); do echo "c = $c"; done

Q: list completions?
A: complete

Q: what is the mechanism by which the completion "complete -F _rcs ci" for "ci"
   only appears when I use it?  (and is un-removable, even though it's buggy!?)
   in fact for *any* command, something like "complete -F _minimal anycommand"
   appears!?
PA: it's something that happens inside
    /usr/share/bash-completion/bash_completion (or /etc/bash_completion)
    which gets sourced by my .bashrc.
    strace says that, at the time it gets auto-created,
    it comes from /usr/share/bash-completion/completions/ci
    (and an attempt at /usr/share/bash-completion/completions/anycommand
    happens for that one).
    Hmm there is something in /usr/share/bash-completion/bash_completion
    referring to "_blacklist_glob" ... should I be using that?
    Not sure it applies...
    OR... maybe I just need to clobber it with the "minimal" thing instead?
    Yeah that works:
        complete -F _minimal ci

=========================================================================
Completion screwups (some local to google, some not):
    - if I have a file called =TEMP, then "anycommand =TE<tab>" gives =\=TEMP
    - if I have a file called OUT, date >| OU<tab>   doesn't work (remove the | and it works)
    - if I have a file called TEMP, somecommand --foo="bar" TEM<tab> doesn't work (but somecommand --foo"=bar" TEM<tab> works)
        (maybe something in _split_longopt() in /usr/share/bash-completion/bash_completion?)
    - if I have a file called TEMP, google-chrome ./TEM<tab> doesn't work
        (I removed completion for google-chrome because of this)
    - if ./javacpp and ./javarenumber both exist but only javarenumber has been previously checked in, then ci -l ./java<tab> only gives ./javarenumber
        (and "complete -r ci" doesn't fix it!?)
        (OH, the completion for ci seems to be some sort of automatic one,
        it doesn't appear til I try it for the first time,
        then it reappears even after removed!?)
