Original notes from home:
-------------------------
    vimdiff related stuff:
        ^W^W switch focus to other side
        [c  prev change
        ]c  next change
        dp (diff out) put change to other side
        do (diff obtain) get change from other side
        :diffupdate  correct diff highlighting after change, if wrong

    folding related stuff:
        zo  open a fold
        zr  open all folds, 1 level deep
        zR  open all folds, all levels      (Reduces number of folds)

        zc  close a fold
        zm  close all folds, 1 level deep
        zM  close all folds, all levels     (More folds)

        zn  disables folding
        zN  enables folding
        zi toggles between enabled and disabled

    Making it not fucking autowrap even when fucking autowrap is not fucking set:
        se tw=0
        But it reverts when you edit a .txt file;
        I have to do that by hand every time I edit the file :-(

    Making .prejava files get same syntax highlighting as .java files:
        au BufRead,BufNewFile *.prejava set filetype=java 



Some more notes from work:
--------------------------
    Q: how to turn off the "helpful" comment continuation behavior?
    A: well if it's just for pasting...
       :set paste
       ... do the thing ...
       :set nopaste

       In general:
           set formatoptions-=coqrl
    Q: how to get that in my .exrc always?
       Neither of the following work:
           set formatoptions-=coqrl
           autocmd BufRead * set formatoptions-=croql

(NOTE, I think I finally got something that works, see my .exrc)
