LINE EDITING:
    I really need to learn the tcsh line editing once and for all.
    To see what is currently defined:
        % bindkey
    and to see a brief description of each editing command:
        % bindkey -l
    also look for bindkey in the tcsh man page.

    Ones to remember:
        ^A beginning-of-line
        ^B backward-char           (can use arrow key instead)
        ^F forward-char            (can use arrow key instead)
        ^E end-of-line
        ^K kill-line
        ^U kill-whole-line
        ^W kill-region
        ^Y "yank" -- puts cut buffer back at current cursor position

    Q: what's the difference betwen ^K (kill-line) and ^U (kill-whole-line)?
    A: kill-line means cut to end of line and save in cut buffer,
       kill-whole-line cuts the entire line and saves in cut buffer.

    Q: what does kill-region mean?
    A: something with marks and cursors; whatever, I don't use it,
       I should bind something else to ^W

    Q: don't I want ^W to kill a word instead?
    A: there's a backward-delete-word command

    Q: can I bind something that will let me traverse forward and backward a word at a time?
    A: there's the following, maybe bind some of them to ^B and ^W
       (since the current bindings for ^B and ^W aren't that useful).

           backward-word (move to beginning of current word)
           forward-word (move forward to end of current word)
           vi-beginning-of-next-word
           vi-endword  (end of current word, space delimited)  E in vi
           vi-eword    (end of current word)                   e in vi
           vi-word-back (vi move to the previous word)         b in vi
           vi-word-fwd (vi move to the next word)              w in vi

    Okay I think the mods I want are the following:
        bindkey "^W" backward-delete-word
        bindkey "^B" backward-word
        bindkey "^F" forward-word

    And of course:
        bindkey -c ^Z bg # so hitting ^Z twice kicks it into background

MISC:
    Q: backticks within backticks?
    A: yes! just double them up. from http://www.grymoire.com/Unix/CshTop10.txt
            % echo foo
                foo
            % echo `echo foo`
                echo foo
            % echo `echo ``echo foo`` `
                foo



COMPLETION:

