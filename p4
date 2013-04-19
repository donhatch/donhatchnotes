QUESTIONS:


Q: how to p4 integ a deleted file but reject the deletion?
    I want to p4 integ a bunch of files from branch A to branch B,
    but reject the changes... I normally do this by:
       p4 integ //A/... //B/...
       p4 resolve -ay
    That does what I want,
    *except* for files that have been deleted in //A ...
    those get deleted (prematurely, it seems to me) by the p4 integ step.
    I can't seem to figure out how to integ-and-resolve
    without the corresponding file in //B being deleted.


Q: how to tell what files in a directory are not from perforce?
A: (maybe not the best)
   p4 opened
       (make sure nothing checked out)
   p4 add *
   p4 opened
   p4 revert ...

Q: After doing an integ and resolve,
   if I decide I want to further edit what I already edited
   during the resolve (say I need to tweak it because it didn't
   quite compile), what do I do?
A: I think maybe I can do "p4 edit" (or "p4 add" if it's a new file),
   which will make it writable...?
   Weird that this will be recorded differently
   from if I did the edits during the resolve.
   NOTE: this is BAD, it is known as "tampering"
   and perforce just stops trying to get certain things right after that

Q: how to get a list of files, suitable for grepping?
A: In sandbox:
    p4 files ...
   or:
    p4 files //gfx/main/{bin,etc,lib,scripts}/...




ANSWERED QUESTIONS:

Q: how to browse dirs?
A: p4 dirs
   although you'll hit the limit in unexpected places...
   E.g. in my current installation, "p4 dirs //gfx/*" seems to work
   even though "p4 dirs //gfx/*dhatch*" doesn't,
   so you can use the former and trawl around by hand

Q: how to integ just one change out of a range?
A: http://kb.perforce.com/article/567/cherry-picking-integrations
        p4 integ foo#2,#2 bar
   and you can do an 'ay' for a nominal bookkeeping integration.

Q: how to migrate checked out files
   from one branch to another
   without checking them in first?
A: p4 move -f", as described in http://www.perforce.com/newsletters/2010/summer/techno_move.html 
    specifically the "reparenting work in progress" section.


Q: how to check what's happening?
A: p4 monitor show

Q: how to see what I've synced to in my sandbox?
A: (if I'm lucky):
    p4 changes -m1 "#have"

Q: how to be notified of checkins?
A: p4 user, and add to the "Reviews" section something like this: //gfx/zeno3/...

Q: how to revert a change?
A: This way maintains per-line ancestry (for tools like p4annotate):
   % p4 integ foo#1 foo.backout462858           (p4 copy seems to work as well, but maybe p4 integ is more portable)
   % p4 submit
       description: "temp copy of foo for backing out change 462858 without confusing p4annotate"
   % p4 integ -f foo.backout462858 foo          (p4 copy seems to work as well, but maybe p4 integ is more portable.  p4 move does NOT work for this at all, even though it seems like it should)
                                                (oh wait-- p4 copy fails in the case of backing out an edit with no actual change.  DAMN!)
   % p4 delete foo.backout462858
   % p4 resolve -at foo                         (not needed if using p4 copy)
   % p4 submit
       description: "back out change 462858"

   This is the way recommended in the book: http://kb.perforce.com/?article=014
   Doesn't sound very good to me,
   since it loses per-line ancestry
   (on lines that get deleted by the change and restored by the rollback).
       % p4 sync foo#1
       % p4 edit foo
       % p4 sync
       % p4 resolve -ay foo
       % p4 submit
