Subject: combinatorial proof of coin problem answer

Here is an equivalent problem, which leads
to the answer by a simple combinatorial argument.

A neutral assistant picks n+2 independent values
from a uniform distribution on [0..1],
without telling us any of the values (although we are told n):
    b              (interpreted as "the bias")
    x_1 .. x_(n+1) (x_i < b is interpreted as "the i'th toss came up heads")

Note that the probabilities associated with this scenario exactly
agree with the probabilities associated with the interpretation
as a coin problem-- that is, once b is chosen,
then for each i, the probability that x_i < b
is precisely b, which is the same as the probability that the i'th toss
of a coin with bias b comes up heads.

The assistant then reveals to us k = how many of x_1 .. x_n are < b
(i.e., k is how many of the first n tosses came up heads).

That is, we are told that b is the k+1'st smallest value
among {b,x_1,...,x_n}.

So in other words, we are being asked the probability that
x_(n+1) is among the smallest k+1 values
in the set of all n+2 values {b,x_1,...,x_(n+1)}.
Since there are n+2 possible rankings of x_(n+1) in this set,
each of them equally likely (since all n+2 values were
chosen independently), the probability of this being the case
is precisely (k+1)/(n+2).
So that's the answer!

Don

p.s. this is Laplace's Rule Of Succession: http://en.wikipedia.org/wiki/Rule_of_succession
