#!/bin/bash

# http://stackoverflow.com/questions/2342826/how-to-pipe-stderr-and-not-stdout#answer-2381643

# Testing hypothesis that:
#       command $a>&$b $c>&d $e>&$f
# means same as:
#       ((command $e>&$f) $c>&d) $a>&$b
# for all possible values of $a,$b,$c,$d,$e,$f.
#
# Actually we'll just do two redirections,
# i.e. test that
#       command $a>&$b $c>&d
# means same as:
#       (command $c>&d) $a>&$b
# for all $a,$b,$c,$d.
# To test all meaningful different combinations,
# we have to use up to 4 different file descriptors.

function echo_and_eval() { echo "$@" ; eval "$@" ; }

# A command that emits recognizable output
# to each of file descriptors 6,7,8,9.
function command() {
  echo "Hello to my fd 6" 1>&6
  echo "Hello to my fd 7" 1>&7
  echo "Hello to my fd 8" 1>&8
  echo "Hello to my fd 9" 1>&9
}

function analyze_and_remove_outputs() {
  echo -n "          is same as: command "
  echo $(grep . OUT[6789] | sed 's/^OUT\(.\):Hello to my fd \(.\)$/\2>OUT\1/')
  rm OUT[6789]
}


# XXX TODO: use tput
function darkred() { printf "\x1b[31m$@\x1b[0m\n" ; }
function darkgreen() { printf "\x1b[32m$@\x1b[0m\n" ; }
function brightred() { printf "\x1b[31;1m$@\x1b[0m\n" ; }
function brightgreen() { printf "\x1b[32;1m$@\x1b[0m\n" ; }

# Using global variables $a,$b,$c,$d,
# compare behavior of the following 3 commands:
#       command $a>&$b $c>&$d
#       (command $a>&$b) $c>&$d
#       (command $c>&$d) $a>&$d
function test_abcd() {
  echo "    Testing a=$a b=$b c=$c d=$d"

  echo_and_eval "          { command $a>&$b   $c>&$d; } 6>OUT6 7>OUT7 8>OUT8 9>OUT9"
  unparenthesized_behavior=`analyze_and_remove_outputs`
  darkgreen "$unparenthesized_behavior"

  echo_and_eval "        { { command $a>&$b;} $c>&$d;} 6>OUT6 7>OUT7 8>OUT8 9>OUT9"
  left_to_right_behavior=`analyze_and_remove_outputs`
  if [ "$left_to_right_behavior" = "$unparenthesized_behavior" ]; then
    darkgreen "$left_to_right_behavior"
  else
    brightred "$left_to_right_behavior"
  fi

  echo_and_eval "        { { command $c>&$d;} $a>&$b;} 6>OUT6 7>OUT7 8>OUT8 9>OUT9"
  right_to_right_behavior=`analyze_and_remove_outputs`
  if [ "$right_to_right_behavior" = "$unparenthesized_behavior" ]; then
    darkgreen "$right_to_right_behavior"
  else
    brightred "$right_to_right_behavior"
  fi
}

function max() { if (("$1" >= "$2")); then echo $1; else echo $2; fi; }


# Without loss of generality:
#     $a is 6
#     $b is 6 or 7
#     $c is one of 6,...,$b+1
#     $d is one of 6,...,max($b,$c)+1
a=6
for b in 6 7; do
  for c in $(seq 6 $(($b+1)) ); do # 6 through $b+1
    for d in $(seq 6 $(( $(max $b $c) + 1 )) ); do # 6 through max($b,$c)+1
      test_abcd
    done
  done
done

