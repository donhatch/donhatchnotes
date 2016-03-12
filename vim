Original notes from home:
-------------------------
    vimdiff related stuff:
        ^W^W switch focus to other side
        [c  prev change
        ]c  next change
        dp (diff out) put change to other side
        do (diff obtain) get change from other side
        :diffupdate  correct diff highlighting after change, if wrong


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

=============================================================================
SPLITS
======
  Read :help windows.
  Excerpt:
      A buffer is the in-memory text of a file.
      A window is a viewport on a buffer.
      A tab page is a collection of windows.

  - You create more windows with :sp[lit] or :vs[plit].

  https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
    nice pictures, although according to the comment thread he's
    using the terminology weirdly though.



  Q: I see I can increase or decrease the size of a window horizontally,
     by saying ctrl-w [N][+-].
     How to do that vertically?
  PA: :se winwidth=10000  (but then can't decrease it!? can go to different window and decrease though)
     Apparently winwidth doesn't have quite the semantics I thought; it's a *minimum* value.
     so if I set it to most of the terminal window size and then switch among the vertical windows,
     the newly-current one expands to size winwidth. I only sort of follow what it's thinking.

  Q: Suppose I want to roughly equalize the areas of the immediate subwindows of a window.
     (They may be unequal because I closed a window, or resized the terminal window.)
     How?
  A: ctrl-w '=' normalizes all split sizes.
     Excellent!
  Q: Can I make it continuously equalize while I'm resizing the terminal window,
     and automatically after closing a window?
     (not that I'd necessarily want to; just checking whether it's possible)


  (maybe for stackoverflow)
  Q: How do I close all but the help window in vim?

     Say I just want to browse the help from inside vim.
     If I start vim with no file and say :help, the window splits into two window
     s, with the read-only help buffer in the top window.
     I don't really want the bottom window; it's just taking up valuable space.
     But if I switch to the bottom window (ctrl-w ctrl-w) and close it, vim exits!
     Can I get rid of that bottom window without exiting vim?

     I can find various workarounds like making the help window crowd out the other one: ctrl-w _
     (found in http://stackoverflow.com/questions/24477083/in-vim-how-can-i-automatically-maximize-the-help-window).
     But I think I'd rather just close the other window.
  A: switch to the other window and close it using ctrl-w c instead of :q ! yay!


=============================================================================
FOLDS
=====
  https://www.linux.com/learn/tutorials/442438-vim-tips-folding-fun
    - six folding methods:
        manual
        indent
        expr
          - "which fold method to use" manual section says this is simple... I guess I should learn it?
        syntax
          - manual section says it's not easy... maybe more heavyweight than expr unless
            I'm already doing syntax for other reasons?
        diff
        marker
  http://learnvimscriptthehardway.stevelosh.com/chapters/48.html
    - it says read :help usr_28 and come back to it
      (or, maybe easier: http://vimdoc.sourceforge.net/htmldoc/usr_28.html)
  http://vimcasts.org/episodes/how-to-fold/ (video)
    - suggests the most useful foldmethod by far is expr
  http://vimcasts.org/episodes/writing-a-custom-fold-expression/ (video)
  http://usevim.com/2012/08/31/vim101-folding/
    - ooh! :set foldcolumn=2  (or more, probably)
  http://jeromyanglim.blogspot.com/2011/04/using-vim-and-vimoutliner-as.html
    supposedly a good presentation on vim and markdown here, but it locks up
    a chrome tab so don't go there:
      http://net.tutsplus.com/tutorials/other/vim-essential-plugin-markdown-to-html/

  cheat sheet:
        zo  open a fold
        zr  open all folds, 1 level deep    ('r'educes number of folds, i.e. increases foldlevel)
        zR  open all folds, all levels      ('R'educes number of folds, i.e. :set foldlevel=<max>)

        zc  close current fold (or parent if already closed)
        zm  close all folds, 1 level deep   ('m'ore folds, i.e. decreases foldlevel)
        zM  close all folds, all levels     ('M'ore folds, i.e. :set foldlevel=0)

        za toggle current fold open/closed

        zn  disables folding
        zN  enables folding
        zi toggles between folding enabled and disabled
        zv  expand folds to reveal cursor  (hmm, I must have it set to auto-expand, somehow)
        ... more, see the how-to-fold video page

  Q: good workflow for drilling into / out of information in a text file,
     a program trace dump that I output in whatever format best
     facilitates this?
  PA:
     current method: outputting a trace like this
     (and the braces have added advantage that % can go to matching ones without folding/unfolding)
          in main {{{
              in foo {{{
                hey, blah blah from foo
                calling bar
                  in bar {{{
                    hey, blah blah from bar
                  out bar }}}
                returned from bar
              out foo }}}
          out main }}}
     and setting the following:
       :set foldcolumn=12
       :set foldmethod=marker

  Q: I'd prefer the fold to exclude the marker lines,
     i.e. only include what's between the marker lines.
     I.e. I want this:
         in main {{{
         +---413 lines:
         out main }}}
     Instead of what the "marker" method gives, which is this:
         415 lines: in main
     Do I need to go the more heavyweight "expr" method instead?
     The manual section sounds optimistic:
       "Folding with expressions can make folds in almost any structured text.  It is
        quite simple to specify, especially if the start and end of a fold can easily
        be recognized."
  PA:
    Experimenting, in ~/.vimrc.myfolding
    XXX put result back here

  Q: fold behavior like foldmethod=marker but make the fold exclude both marker lines?
     Asked here: http://stackoverflow.com/questions/31321413/vim-fold-behavior-like-foldmethod-marker-but-make-the-fold-exclude-its-marker-li
     ===============================================
      I would like to define a fold expression in vim that behaves like
      foldmethod=marker except that I would like each fold to exclude
      its delimiting marker lines, instead of including them.
      For example, given the file:
      a
      {{{
          b
          {{{
              c
          }}}
          d
          {{{
          }}}
          e
      }}}
      f
      The fold levels produced by foldmethod=marker are:
      0 a
      1 {{{
      1     b
      2     {{{
      2         c
      2     }}}
      1     d
      2     {{{
      2     }}}
      1     e
      1 }}}
      0 f
      But I would like them to be this instead:
      0 a
      0 {{{
      1     b
      1     {{{
      2         c
      1     }}}
      1     d
      1     {{{
      1     }}}
      1     e
      0 }}}
      0 f
      Is there a way?
    ==============================================
    (Main obstacle seems to be inability to make a single-line fold
    when using foldmethod=expr !?)
    (Bleah! Should I make a syntax definition??!)

  Q: I've got two kinds of folds: function bodies
     and INFO log messages.
     Generally I want the latter closed and the former more easily open.
     How?
  PA: hacking it by multiplying the INFO folds by 5

  Q: there's some sort of automagic mentioned in http://vimcasts.org/episodes/writing-a-custom-fold-expression/
     whereby if I put code in ~/.vim/after/ftplugin/markdown/folding.vim,
     it gets sourced automatically when I load a markdown file... do I want to use this?
     Well I tried putting it in ~/.vim/after/ftplugin/trace/folding.vim,
     and also the following in ~/.exrc: au! BufRead,BufNewFIle *.trace set filetype=trace
     That set the filetype correctly, but it didn't read folding.vim :-(


  Q: why the hell is the maximum foldcolumn value 12???
     shouldn't I be able to make it as big as I want??


=========================================================================


General Questions
=================
Q: show a variable?
A: :set foo?
   More generally:
        :set - shows vars different from defaults
        :set all - shows all values
        :set foo? - shows the value of foo
        :set foo+=opt
        :set foo-=opt
        :set foo& - reset foo to default value
        :setlocal foo - only in the current buffer

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
    Also :help timeout (and following options) suggests
    the following alternative:
        :set timeout timeoutlen=3000 ttimeoutlen=100
        " (time out on mapping after three seconds, time out on key codes after a tenth of a second)
    The default is apparently:
        :set timeout timeoutlen=1000 ttimeoutlen=-1

Q: how to control filename completion?
   I'd like it to:
        - ignore .class files
        - in order of preference, if all three exist:
                .prejava
                .java
                .java.lines
          and actually, go on to Arrays.prejava before Arrows.java.
          Hmm. :-(
PA: I don't think I can do exactly that,
    but see "help wildignore", "help wildmenu", "help wildmode"
    I think I like what it suggests better than the default
    which too often sends me down a rathole that I have to think too hard
    to get out of:
      set wildmenu
        (XXX don't really know what this means yet)
      set wildmode=longest,list
        means:
          first Tab: expand to longest common prefix of all expansions
          second Tab: show list of all possible expansions

Q: how do I get it to ignore the frickin mouse wheel?
   when I accidentally scroll and paste, NO I don't want it to paste
   at whatever place the cursor scrollwheeled to.
     http://superuser.com/questions/610937/how-to-disable-scroll-wheel-in-vim
   does not work for me on Linux! (because on X11, scroll wheel actually
   generates key events!?)
PA: might be unique to gnome-terminal, see:
http://unix.stackexchange.com/questions/44513/disabling-mouse-support-in-vim-in-a-gnome-terminal-environment
   yeah, problem doesn't happen in xterm.
   more info:
     https://bugs.kde.org/show_bug.cgi?id=170582



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

" To avoid the <Esc>O problem...
" http://vi.stackexchange.com/questions/3261/speed-bump-on-esco-insert-to-normal-to-insert-new-line-above-cursor
" default is timeout,timeoutlen=1000,ttimeoutlen=-1  (-1 meaning 1000)
" Recommended in :help timeout  (I don't like this much)
":set timeout timeoutlen=1000 ttimeoutlen=100
" Recommended in :help xterm-cursor-keys  (I like this better)
set notimeout          " don't timeout on mappings
set ttimeout           " do timeout on terminal key codes
set timeoutlen=100     " timeout after 100 msec

