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
set -o pipefail # Fail if any command in pipeline fails.
#set -v # Print shell input lines as they are read. (like set verbose in tcsh)
#set -x # Print commands and their arguments as they are executed. (like set echo in tcsh)


==============================================
Questions about bash:

Q: what's a nice way to make a barrier, that will let a bunch of processes
   proceed at the same time?
A: 
     everybody waits:
       inotifywait somefile
     someone releases everybody:
       touch somefile

Q: start without sourcing my startup files?
A: bash --noprofile --norc
   (still inherits environment and limits though)

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

Q: What if I want to know how long a command took, after the fact?
   Is there a way, using history?  I'm sure the answer is no...
   but how about the walltime between two consecutive command executions?
   I know I can see the timestamps via:
     HISTTIMEFORMAT="%F %T" history
PA:
   See whether this does it:
     https://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
   See whether this (or any of the other answers there) does it:
     https://stackoverflow.com/questions/1176386/automatically-timing-every-executed-command-and-show-in-bash-prompt#answer-1177511



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

Q: In a script, how do you print out the current command-line (i.e. script
   name and args), suitably escaped so a user can copy-paste it into a bash
   shell in order to re-execute the exact same command?
   E.g.
     ./myscript.bash a b 'c d' "e f" "single quote: '" 'double quote: "' 'dollar sign: $' 'backslash: \' "single: ' "'and double: "'
   could produce output:
     ./myscript.bash a b 'c d' 'e f' "single quote: '" 'double quote: "' 'dollar sign: $' 'backslash: \' 'single: '"'"' and double: "'
A: Here's one way, though not pretty:
      #!/bin/bash
      echo -n 'invoked as:'; for arg in "$0" "$@"; do printf " %q" "$arg"; done; echo
   Here's another way, prettier but not entirely robust (non-printing chars are handled better by printf):
      #!/bin/bash
      quote_arg_if_necessary() {
	if [[ "$1" =~ ^[-=_-:/.@%+a-zA-Z0-9]+$ ]]; then
	  # The arg consists of only known-to-be-safe chars,
	  # so it doesn't need to be quoted at all.
	  echo "$1"
	  # Note: we use [\'] instead of \' in the following only because
	  # \' by itself derails vim's syntax highlighting.
	elif [[ "$1" =~ [\'] && ! "$1" =~ [\"\!\$\`\\] ]]; then
	  # The arg contains at least one single quote,
	  # and no double quote nor any other char that might be special inside double quotes;
	  # therefore double quotes would be more concise than single quotes, so use them.
	  echo '"'"$1"'"'
	else
	  # General robust strategy: surround by single quotes,
	  # and turn each embedded single quote ' into 5 chars: '"'"'
	  # (that is: close single, open double, single, close double, open single).
	  echo "'${1/\'/\'\"\'\"\'}'"
	fi
      }
      echo -n 'invoked as:'; for arg in "$0" "$@"; do echo -n " "$(quote_arg_if_necessary "$arg"); done; echo


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

Q: is there a nice way of commenting out something in the middle of a line?
   E.g. if I want to comment out the b from either of the following:
        echo a b c
        echo a \
             b \
             c \
   and I want to comment out the b?
A:
        echo a $(: b )
        echo a \
             $(: b ) \
             c \

Q: is there a nice way to get multiple processes to start simultaneously?
A:
   manager:
     touch /tmp/foo
   each worker:
     inotifywait /tmp/foo
   manager:
     touch /tmp/foo

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

          # Also, `vi ~/save/PRIN<tab>` (and vim, view) is broken if there's a file called '!'
          # in the *current* directory!

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

More command completion screw-ups not listed above:
  echo a='b' <tab>
  dpkg -s /usr/share/doc/texlive-doc/texlive/index.htm<tab>

Q: what about that redirect question?
  https://stackoverflow.com/questions/363223/how-do-i-get-both-stdout-and-stderr-to-go-to-the-terminal-and-a-log-file/53051506?noredirect=1#answer-53051506
  is this valuable?
  https://unix.stackexchange.com/questions/3514/how-to-grep-standard-error-stream-stderr/3540#answer-3540

  Maybe, leveraging this: https://unix.stackexchange.com/questions/3514/how-to-grep-standard-error-stream-stderr/3540#answer-3540

    This works!
      { ( echo "to stdout"; echo "to stderr" >&2 ) 2>&1 1>&3 | (sleep 2; cat -n | cat -n | tee stderr.txt) 1>&2; } 3>&1 | (sleep 1; cat -n | tee stdout.txt)
    This works!
      { my_cmd 2>&1 1>&3 | { sleep 2; cat -n | cat -n | tee stderr.txt; } 1>&2; } 3>&1 | { sleep 1; cat -n | tee stdout.txt; }

    This works!
      alias my_cmd='{ echo "to stdout"; echo "to stderr" >&2;}'
      alias stdout_filter='{ sleep 1; cat -n | tee stdout.txt; }'
      alias stderr_filter='{ sleep 2; cat -n | cat -n | tee stderr.txt; }'

    And then either of these:
      { my_cmd 2>&1 1>&3 | stderr_filter 1>&2; } 3>&1 | stdout_filter
      { { my_cmd | stdout_filter } 2>&1 1>&3 | stderr_filter 1>&2; } 3>&1

    What about swapping?  As suggested in https://unix.stackexchange.com/questions/3514/how-to-grep-standard-error-stream-stderr/3540#answer-341014
    This one's cute.
      { { my_cmd | stdout_filter; } 3>&2 2>&1 1>&3- | stderr_filter; } 3>&2 2>&1 1>&3-
      { my_cmd 3>&2 2>&1 1>&3- | stderr_filter; } 3>&2 2>&1 1>&3- | stdout_filter

      or (using other order)

      { my_cmd 3>&1 1>&2 2>&3- | stderr_filter; } 3>&1 1>&2 2>&3- | stdout_filter

      I think that's the best!

    Q: what's with the '-' ? should I be using it for the others?


  My initial answer to https://stackoverflow.com/questions/363223/how-do-i-get-both-stdout-and-stderr-to-go-to-the-terminal-and-a-log-file/53051506
  =================================

    I've been wanting an answer that preserves the distinction between stdout and stderr.
    Unfortunately all of the answers given so far that preserve that distinction
    are race-prone: they risk programs seeing incomplete input, as I pointed out in comments.

    I think I finally found an answer that preserves the distinction,
    is not race prone, and isn't terribly fiddly either.

    First building block: to swap stdout and stderr:

        my_command 3>&1 1>&2 2>&3-

    Second building block: if we wanted to filter (e.g. tee) only stderr,
    we could accomplish that by swapping stdout&stderr, filtering, and then swapping back:

        { my_command 3>&1 1>&2 2>&3- | stderr_filter;} 3>&1 1>&2 2>&3-

    Now the rest is easy: we can add a stdout filter, either at the beginning:

        { { my_command | stdout_filter;} 3>&1 1>&2 2>&3- | stderr_filter;} 3>&1 1>&2 2>&3-

    or at the end:

        { my_command 3>&1 1>&2 2>&3- | stderr_filter;} 3>&1 1>&2 2>&3- | stdout_filter

    To convince myself that both of the above commands work, I used the following:

        alias my_command='{ echo "to stdout"; echo "to stderr" >&2;}'
        alias stdout_filter='{ sleep 1; sed -u "s/^/teed stdout: /" | tee stdout.txt;}'
        alias stderr_filter='{ sleep 2; sed -u "s/^/teed stderr: /" | tee stderr.txt;}'

    Output is:

        ...(1 second pause)...
        teed stdout: to stdout
        ...(another 1 second pause)...
        teed stderr: to stderr

    and my prompt comes back immediately after the "`teed stderr: to stderr`", as expected.




