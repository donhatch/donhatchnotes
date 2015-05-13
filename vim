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

        za toggle a fold

        zn  disables folding
        zN  enables folding
        zi toggles between enabled and disabled

    Making it not fucking autowrap even when fucking autowrap is not fucking set:
        se tw=0
        But it reverts when you edit a .txt file;
        I have to do that by hand every time I edit the file :-(

    Making .prejava files get same syntax highlighting as .java files:
        au BufRead,BufNewFile *.prejava set filetype=java 
    Also to make it work for anyone, can put this at top
    (note, /**/-style instead of //-style, so github understands it too):
        /* vim: set filetype=java: */
    But on many os's, that requires something like the following in .exrc:
        set modeline
        set modelines=5

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
PA: hmm, I don't think I'm doing anything special any more but it's not happening? good.

(NOTE, I think I finally got something that works, see my .exrc)
Q: difference among map, map!, and nmap? (and manbe other things like vmap, xmap, smap, imap, lmap, cmap)
A: http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
        map means "normal, visual, select, and operator pending"
        map! means "insert and command-line"
   better alternative is mode-specific:
        nmap means "normal mode map"
        imap means "insert mode map"
        vmap means "visual and select mode map"
        xmap means "visual mode map"
        smap means "select mode map"
        cmap means "command-line mode map"
        omap means "operator pending mode map"

Q: (asked here: http://vi.stackexchange.com/questions/3261/speed-bump-on-esco-insert-to-normal-to-insert-new-line-above-cursor)
   Speed bump on <Esc>O (Insert to Normal to Insert new line above cursor)

   Often when I'm in Insert mode, I'll hit <Esc> to get into Normal mode, and then immediately hit O to begin a new line above the cursor and go into Insert mode there.

   But when I do that, there is a 1-second delay after I hit the O before there is any visible response.  Furthermore if I begin typing the new text during that 1-second delay, if the new text begins with any of a certain set of characters (e.g. j,k,m,n,o), I end up in the middle of some other operation I didn't intend, often making a mess, at which point I have to stop and fumble around with undos and redos until I am reasonably sure I have undone the damage.

   To avoid that unpleasantness, I've gotten in the habit of pausing for one second after every time I type O.  But this slows me down and prevents me from being the vim speed demon I would otherwise be.

   What causes this?  Is there a fix or workaround?

A:  Oh! :help xterm-cursor-keys
    It says I could do the following (though I don't completely understand):
        :set notimeout          " don't timeout on mappings
        :set ttimeout           " do timeout on terminal key codes
        :set timeoutlen=100     " timeout after 100 msec

=============================================================
"Here is my current .exrc  (2015/05/13 at google):

" google-local
se sw=2
"se ts=2 " wtf? no way!
" takes too long! and I don't think I care about anything in it
"source /usr/share/vim/google/google.vim
"----------------------------------------

set ai " autoindent
set sw=4 " shiftwidth
set terse
set et " expand tabs

map g G
map #H :%s/.<C-v><C-h>//g<CR>
map ## :e#<CR>
map #< :se paste<CR>
map #> :se nopaste<CR>
set background=dark

au! BufRead,BufNewFIle *.prejava set filetype=java

"STUPID FUCKING THING
se tw=0

" turn off frickin auto-wrapping in .txt files
"autocmd BufRead *.txt se tw=0
" hmm, mimimicing what is in /usr/share/vim/vim70/vimrc_example.vim
"autocmd FileType text setlocal textwidth=0
" woops! that didn't work!
autocmd BufRead *.txt setlocal textwidth=0

"so I don't get that freaking gx mapping that messes with my g mapping
let g:netrw_nogx = 1

syntax enable

"BUG: this doesn't work for lines 80 through 89 !?! instead of ":80" I get "0"
:map * :exe 'silent !google-chrome-beta "https://cs.corp.google.com/?q=%:'.line(".").'" \| grep -v "Created new window in existing browser session." &'<CR><C-l>

" so modelines will work (disabled by default on most linux os's)
set modeline
set modelines=5

"per :help xterm-cursor-keys, to avoid the <Esc>O problem
set notimeout          " don't timeout on mappings
set ttimeout           " do timeout on terminal key codes
set timeoutlen=100     " timeout after 100 msec
