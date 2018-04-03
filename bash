Advanced Bash-Scripting Guide: http://www.tldp.org/LDP/abs/html/
Internal Bash functions, useful when writing loadable builtins: https://gist.github.com/sshaw/8017032
The Ultimate Bash Array Tutorial with 15 Examples: http://www.thegeekstuff.com/2010/06/bash-array-tutorial/
Handling positional parameters: http://wiki.bash-hackers.org/scripting/posparams
Bash Pitfalls: http://mywiki.wooledge.org/BashPitfalls
Fantastic series of articles: http://www.catonmat.net/series/bash-one-liners-explained
With cheat sheets.

Grouping cheat sheet: http://stackoverflow.com/questions/2188199/how-to-use-double-or-single-bracket-parentheses-curly-braces#answer-8552128
Redirections cheat sheet: http://www.catonmat.net/download/bash-redirections-cheat-sheet.pdf
History cheat sheet: http://www.catonmat.net/download/bash-history-cheat-sheet.pdf
Command line editing cheat sheet: http://www.catonmat.net/blog/bash-emacs-editing-mode-cheat-sheet/
==============================================
Useful settings:

# from "help set"
set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error when substituting.
set -o pipefail # Fail if any command in pipeline fails
#set -v # Print shell input lines as they are read. (like set verbose in tcsh)
#set -x # Print commands and their arguments as they are executed. (like set echo in tcsh)


==============================================
Questions about bash:

Q: express newline embedded in a command arg?
A: echo $'hello\nworld'

Q: unshift?
A: set -- foo "$@"

Q: set a variable to something that acts exactly like positional parameters?
   e.g. so that the following will work.
       set -- a "b c" d
       echo '${#@} is now' ${#@}
       # $@ is now: a "b c" d, same as if given that way on command line
       otherprogram "$@" # this works
       args="$@"  # WRONG
       # $args is now: a b c d
       echo '${#args} is now' ${#args}
       [[ ${#@} -eq ${#args} ]] || (echo WRONG; exit)
       otherprogram "${args}" # this does not!
PA: maybe impossible. wrapper script example here:
    http://wiki.bash-hackers.org/scripting/posparams
    it requires the final usage to be: "${options[@]}"

Q: nested backticks?
A: use $(command) instead of `command`, then you can nest.


Q: how to make an alias understand commands?
A: you can't; use functions

Q: how to list functions?
A: declare

Q: how to list a function's source?
A: type <functionName>

Q: how to undefine a function?
A: unset -f my_function

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
   according to the "Special Shell Variables" section in the advanced scripting
   guide:
        "$@" is All the positional parameters (as separate strings)
        "$*" is All the positional parameters (as a single word) (must be quoted, otherwise it defaults to $@) (which means args with embedded spaces get spilled out into parts, I guess)

Q: boolean expressions?
A: http://stackoverflow.com/questions/48774/boolean-expressions-in-shell-scripts

Q: arithmetic?
A: echo $((1+2))

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
   for x in `seq 1 10`; do echo $x; done
   (and see the following too)

Q: repeat 10 date?
A:
   for i in {1..10}; do echo "i = $i"; done
   for i in {0..10..2}; do echo "i = $i"; done
   for (( c=0; c<5; c++ )); do echo "c = $c"; done

Q: if true?
A: if true; then echo foo; fi

Q: while true?
A: while true; do echo $x; done

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

Q: why the hell do commands that begin with a space get excluded from being
   stored in history???
A: actually this may have just been a google-specific setting:
   my HISTCONTROL was set to ignoreboth, which includes ignorespace.
   Need to set it to ignoredups or nothing.

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
        (see the explanation and workaround above)
    - alias pppp ~/<tab>  doesn't work.  (not that it really makes sense, but I might do that when composing the line and then backfix it afterwards)
        (this is another automatic one, see workaround above)
    - blaze run myprogram <tab>  doesn't complete to files
    - g4 changes -lt -u donhatch >| ~/tmp/changes.donhatc<tab>
    - npm link ../most-gestures-fixe<tab>


Posted: http://stackoverflow.com/questions/38843719/emergency-override-of-broken-command-completions-in-bash
    ==============================================================
    Q: emergency override of broken command completions in bash?

    One of my biggest aggravations with working in bash is the chronically broken command completions.
    There are hundreds of programmed command completions, more being written each day, some by the distro (I'm currently using ubuntu linux) or upstream,
    and some by people at my company.  It's inevitable that at any given time, dozens of them are broken.  I accept that.

    What I don't accept is when broken command completions prevent me from being able to do filename completion.
    Filename completion is essential to my work efficiency; when I can't access it, it's extremely distressing and disruptive to my workflow.

    For a while, I simply disabled all command completions, since I judged
    that reliable filename completion is more important to me than the value
    of all the other command completions combined.

    But... then I decided to give them another try, so instead of disabling
    them all, I'm blacklisting the ones I know to be broken, one by one, in my .bashrc:

        #
        # Blacklist for known broken command completions
        #

          # Command completions prevent vim'ing .jpg files!? Not ok.
          complete -r vi
          complete -r vim
          complete -r view

          complete -r google-chrome # google-chrome ./myFil<tab>

          # The rest of these are gratuitous strong evil magic
          # that can't be killed by "complete -r",
          # so stronger good magic "complete -F _minimal" is necessary instead.
          complete -F _minimal ci    # ci -l ./java<tab> when ./javacpp and ./javarenumber both exist but only javarenumber has been previously checked in
          complete -F _minimal alias # alias pppp ~/<tab>

    The blacklist works for me, for the most part,
    *except* at that awful moment when I first discover another command completion
    is broken, when I'm in the middle of trying to complete a filename quickly.
    At that moment I need some kind of "in case of emergency break glass" emergency override.

    What I'm asking for is one of the following:
    (a) a way to bind a key/keys to filename completion only, bypassing programmable command completion
    (b) a way to bind a key/keys to temporarily disable programmable command completion for the current command that I have partially typed
    (c) some other clever non-intrusive way to get at filename completion at the moment I discover it's being hidden by a broken programmable command completion.
    ==============================================================
    A: Alt-/ (complete-filename)
