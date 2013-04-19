http://www.gnu.org/software/make/manual/



From ewimmer, to debug Makefiles:

    FOO:=$(warning pkg config path is $(PKG_CONFIG_PATH))

Q: how the hell do dynamic includes work?
A: see the following sections:
    3.3 Including Other Makefiles
    3.5 How Makefiles Are Remade
    4.14 Generating Prerequisites Automatically

Q: what does it mean when a line begins with @,-,+ in a Makefile?
A: section 5 Writing Recipes in Rules.
    @ - suppress echoing of the recipe line
    - - ignore errors in the recipe line
    + - override '-n', '-t', '-q'

Q: how to check if a variable is equal to one of two values using the if-or-and-fun?
A: http://stackoverflow.com/questions/7324204/how-to-check-if-a-variable-is-equal-to-one-of-two-values-using-the-if-or-and-fun
