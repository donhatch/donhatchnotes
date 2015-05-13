===========================================================================
I posted this on http://en.wikipedia.org/wiki/Talk:Rules_of_go
Subject/headline: description of scoring rests on unclear definition of "dead"

I am not very experienced at Go, so things that may be obvious
to most people reading this page may not be obvious to me.
I hoped that this page would provide a clear and well-founded (non-circular)
statement of the rules of play and scoring, without requiring prior knowledge.
I have found that it succeeds in describing the *rules of play*
in a self-contained way that I believe I understand,
but it fails to describe the *scoring* in a way that I understand.
I'm happy to restrict attention to "area scoring" for now
(since I understand that "territory scoring" complicates
the definition of end-of-game).

Please understand that I am in no way nitpicking or trying to be difficult--
I honestly do not understand the scoring of Go
and I have not found a well-founded description of it, here or anywhere else.

I'll point out one key section of this page that I think would need to be
cleared up in order for me to understand the scoring: it is the definition of
"Dead" (upon which rests the definitions of Territory, then Area, then Score):

Definition. [23] ("Dead") In the final position, stones are said to be dead if the players agree they would inevitably be removed if the game continued.

The phrase "if the game continued" isn't clear-- continued from what point?
Continued for how long?  Continued with what additional restrictions on
passing, if any?  Continued with what frames of mind and goals
of the two players?
Possible interpretations of "if the game continued" that I can think of:
 1) if the player who passed second had played instead
    (so one of the possible continuation games consists of the game
    ending with two passes immediately afterwards)
 2) if the player who passed first had played instead
    (so one of the possible continuation games consists of the game
    ending with two passes immediately afterwards)
 3) if the player who passed second had played instead,
    and the game continued with neither player allowed to pass
    unless they have no legal play, until there are two consecutive passes
 4) if the player who passed first had played instead,
    and the game continued with neither player allowed to pass
    unless they have no legal play, until there are two consecutive passes

The phrase "would inevitably be removed" is similarly unclear.
Possible interpretations of "would inevitably be removed" that I can think of:
  A) gets removed in every possible legal game proceeding from this point
     (where "this point" depends on which of 1,2,3,4 is chosen above,
     and "legal game" means normal rules plus possible restrictions on passing,
     again depending on which of 1,2,3,4 is chosen)
  B) gets removed in every possible legal game proceeding from this point
     in which each of my moves is the move I would/might actually make
     if I were trying to win but the other player isn't
  C) gets removed in every possible game proceeding from this point
     in which each move is a move an experienced player might actually make
     if they were trying to win
  D) gets removed in the game or games consisting of moves both players
     would actually make if they were both trying to win
  E) gets removed in every possible game proceeding from this point
     in which each move is a move an I would/might actually make
     if my sole goal were to preserve the single stone in question
     (if it's my stone) or to capture it (if it's the other player's stone)
However, note that any occurrance of "win" in the above possibilities
is problematic, since winning hasn't been defined yet, and can't be:
the definition of winning will depend on scoring, which depends on
the definition of "Dead" which is what we're in the process of defining here,
so depending on the definition of winning here would be circular.
So it seems this rules out interpretations B,C,D.
===========================================================================
Great threads here:
------
Natural Rules Of Go https://groups.google.com/forum/#!topic/rec.games.go/AaLvnO-F1Is

   Key points: in his initial post, he gives an example where
        "The matter was referred to the Nihon Ki-In, who decided that "Black had won the
game by either 1 or 2 points". So much for complete rules. :-/"

-------
Very Novice Question When is Dead really Dead? https://groups.google.com/forum/#!topic/rec.games.go/yDHNZrjluYM

Jeff Nowakowski says something I believe is true:
    With territory scoring, you count prisoners
    plus the surrounded empty points.  However, territory scoring
    requires you to assume that stones are dead, because if you actually
    play to kill them, it costs you points.

The OP, Paul, does a great job (later in the thread) of summarizing my dissatisfaction
(perhaps only with the japanese scoring rules) and my skepticism, at this point,
that anyone who refers to "alive" or "dead" has really thought it through.
Erik Van Der Werf has thought it through in his Migos Rules, but I don't think it agrees
with anyone's usual definition.  Not sure why he picked rules that are so complicated and weird!?

Will Twentyman says: Think of "dead" as meaning "cannot be saved if the opponent wishes to kill them and plays appropriately".  "Alive" would mean "cannot be killed no matter what the opponent wishes as long as defended appropriately".  It's just a real hassle to write all that.

And similarly Nathan Sinclair said:
  > a group is dead defn.= no matter what sequence of moves is made in the
  > attempt to save that group of stones there is some sequence of responses the
  > defender can make which leaves the group with no liberties (i.e. captured
  > explicitly).
And Douglas Ridgway replied with this:
   | X X X . . . . . .
   | O O X X . . . . .
   | X O O X . . . . .
   | X X O X . . . . .
   | . O O X . . . . .
   | O O X X X X X X .
   | . O X O O O O X .
   | X X O O X X O X .
   | . X . O X . O X .
    ------------------
    Each the White (O) groups are dead, under your definition. But 
    Black can't capture them both -- if he tries, he loses 
    everything. So each of them is dead individually, but they 
    aren't both dead together.


Chris says: "Don't get too
wound up by the apparent lack of precision in defining things since Go
is very much a game of feeling and balance and you will come to feel
what is going on as you get better at it over the coming weeks."

Simon Goss says: I think Paul is right, but there is a simple answer: use rules which
allow both players to continue playing until they are no longer in
doubt, without losing points by doing so. Area rules (New Zealand,
Chinese, etc) all allow this. So do those territory rules in which a
player who passes must hand over a prisoner, such as French and AGA
rules.

