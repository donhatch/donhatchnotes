Looks like great resource:
    http://www.ibm.com/developerworks/aix/library/au-gdb.html
    "GNU Project Debugger: More fun with GDB
    Customizing the debugger"

Another:
    http://cat.pdx.edu/documents/advgdb.html
    "A Tutorial on the Intermediate Use of GDB"





From cary:
Date: 2007-05-02 16:54
Subject: Re: totalview/zeno

If you use emacs, I'm quite fond of gud-mode, which is an integration of gdb into emacs. It has a 70's era quality to it, but late 70's...

% zeno -exec emacs

Then emacs starts, say ^M gdb, and then

Run gdb (like this): zeno -debug gdb

Then gdb starts in a buffer, and just type run. It loads the source files into emacs buffers, you can step, etc. Ahh, freak out.


And if you are new to gdb at ILM, with zeno, put this in your ~/.gdbinit file:

set auto-solib-add off

Then, when you run the program and want to examine examine the stack trace, etc, type "shared" at the gdb prompt. This delays loading the symbol tables until you need them, which makes it way faster to start up.

- Cary

Ronald Mallet wrote:

> Hi
> anyone has a quick tutorial on how to debug zeno using totalview
> what's the setup, how to launch it etc...
> my printfs can't help any longer
> Thanks





=========================================================================
This is supposedly much better than the one in /usr/bin:
/dept/rnd/vendor/gdb-6.7/bin/gdb




=========================================
Commands I always forget:
    finish - continues until return
    info b - show breakpoints
    info r - show registers
        on my amd64 machine:
                $rdi = first param
                $rsi = second param
                $rdx = third param
                $rcx = fourth param
                $r8 = fifth param
                $r9 = sixth param
                $rax = return value

    stepi
    nexti
    disassemble $pc $pc+1
    or:
        x/i <addr>
    or:
        disas

    to print the first num elements of array, starting with startindex:
        p array[startindex]@num
    or:
        p *(array+startindex)@num


QUESTIONS:


PARTIALLY ANSWERED QUESTIONS:

Q: how to run a shell that doesn't honor the SHELL variable?
   (SHELL is set to /bin/tcsh which is too slow!)
PA: unsetenv SHELL (or set it to /bin/sh) before running gdb.
    can't seem to find a way to change it once gdb has started
    ("set environment" sets it for the invoked process, but not for gdb stuff)


Q: how to make it NOT say "The program is running. Exit anyway? (y or n)"
   on quit or ctrl-d?
PA: well here's how to make q not do it:
    define q
        detach
        quit
    end
    document q
        detach and quit (defined in my .gdbinit)
    end
   The problem is, quit still does it, and ctrl-d executes quit.
   Maybe can redefine quit, and use some sort of "shell kill parent of $$" thing?
   Hmm, "set confirm off" is supposed to do it, but I think it 
   has other undesired side effects


Q: how does the "shared" trick go?
A: http://visualgdb.com/gdbreference/commands/sharedlibrary
   put the following in ~/.gdbinit:
    # by default gdb loads symbols from every shared library when it starts,
    # which takes forever.
    # we disable that here, so that on startup, it doesn't load any.
    # at runtime, you can say "shared" to load them all,
    # or "shared <substring>" to load symbols from all DSOs 
    # containing the given substring.
    set auto-solib-add off
    # the following gives nice verbosity during .so loading,
    # but it also gives some other undesired behavior :-(
    set verbose on

Q: how to make it "shared" just enough to get a good stack trace?
   (assuming "set auto-solib-add off")
A: see what I put in my .gdbinit   XXXTODO: copy to here!

Q: how to make it stop when loading just one library,
   so that I can shared that library and set a breakpoint in it?
PA:
    set stop-on-solib-events 1


Q: how to recover if I type "wh" by mistake?
PA: not sure, but you can prevent that from happening by:
    define wh
        echo wh is NOT defined, to prevent you from shooting yourself in the foot.\n
    end


Q: how to make it NOT repeat the previous command when I hit Enter?
PA: I don't think there's a way (short of using a front-end program),
    see http://sourceware.org/gdb/onlinedocs/gdb/Command-Syntax.html
   but usually the reason I want this is just so I can have
   some blank lines between sections of what I've done.
   This can be accomplished by typing one space on my blank line;
   then I can hit enter as many times as I want and get
   the desired behavior.


Q: show first arg, etc.?
PA: info registers, and then something like:
        print (char *)$rax
        print (char *)$rbx
        print (char *)$rcx
        print (char *)$rdx
        print (char *)$rsi
    until it shows something interesting.
        $rdi seems to be first arg
        $rsi seems to be second arg
        $rdx seems to be third arg
        
Q: show what dso an address is in?
PA: info files



ANSWERED QUESTIONS:

Q: how to go to a particular numbered stack frame (not using "up" or "down"
   which are relative?)
A: frame <n>

Q: how to make "w" an alias for "where"?
A: put this in .gdbinit:
    define w
        if $argc == 0
            where
        end
        if $argc == 1
            where $arg0
        end
        if $argc == 2
            where $arg0 $arg1
        end
    end
    document w
        "w" is a (user-defined) abbreviation for "where"
    end

Q: how to stop on an exception being thrown?
A:
     b __cxa_throw
   or
     catch throw
   (both of them require libstdc++.so to be loaded)
   or maybe __raise_exception (see http://www.delorie.com/gnu/docs/gdb/gdb_31.html)

Q: how to stop on terminal output?
A: b write if $rdi==1||$rdi==2

Q: how to tell the source file it's looking at?
   (strace gdb's pid and see what it's opening, is one way,
   but what's the real way?)
A: info source

Q: how to tell it where a given source file is, when I know?
A: "dir <dirname>" adds <dirname> to front of search path

Q: how to set the window size, so it doesn't page in such
   small increments (actually it would be nice if it didn't page at all)
A:
       show width
       show height
       set width 10000
       set height 10000
   (I put that in my .gdbinit)

Q: how to I print something every time a given line is hit?
A: commands <breakpoint number>
   For more info, type "help commands"

