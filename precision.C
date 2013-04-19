/*
How many digits of precision are needed to print
an IEEE floating-point number "exactly"?  I.e. such that
when it is read back in, it is guaranteed to give back
the original number?

Well let's see, the IEEE representation has:
    - s=1 bit for sign
    - e bits for exponent
    - m bits for magnitude (i.e. significand, i.e. mantissa excluding the leading 1)
On my computer,
    float: s1e8m23
    double: s1e11m52
    long double on my compiler: (sizeof = 12 on IA32 and 16 on AMD64!? weird)
        s1e32m63 on IA32
        s1e64m63 on AMD64

We want the smallest integer precision p
such that for all floats x, when x is printed to p decimal digits
of precision, the closest float to that decimal representation is x.

The spacing between two neighboring floats x-,x
is at least x * (1 - 1-)  (since the smallest relative spacing
is when x is a power of 2, such as 1)
which is 2^-(m+1).
(E.g. if m = 3 then it's 1 - .1111 binary = 1 - 15/16 = 1/16 = 2^-4.)

The spacing between two neighboring decimals x,x+ at precision p decimal digits
is at most x * (1+ - 1)
(since the largest relative spacing is when x is a power of 10, such as 1),
which is 10^-(p-1) where p is the precision.
(E.g. if p=4 then it's 1.001 - 1 = 10^-3.)

We need the spacing between neighboring decimals at precision p
to be < the spacing between neighboring floats.
Looking at the worst case, this means we need (the smallest) p
such that for all x,
        x * 10^-(p-1) < x * 2^-(m+1)
we can guarantee that by making
        10^-(p-1) < 2^-(m+1)
and we want the smallest p for which that's true.
Inverting both sides and reversing the direction of the inequality:
         10^(p-1) > 2^(m+1)
         p-1 > log10(2^(m+1))
             = log10(2)*(m+1)
         p > log10(2)*(m+1) + 1
We want the smallest integer p for which that's true,
which is:
         p = ceil(log10(2)*(m+1)) + 1
           = floor(log10(2)*(m+1)) + 2  since log10(2) is irrational
           = ((int)((M_LN2/M_LN10)*((m)+1)) + 2)

For float, m=23:
        perl -e 'print log(2)/log(10)*(23+1)+2,"\n"'
        9.22471989593555
floor of that is 9, so %.9g is right for floats.

For double, m=52:
        perl -e 'print log(2)/log(10)*(52+1)+2,"\n"'
        17.954589770191
floor of that is 17, so %.17g is right for doubles.

For long double, m=63:
        perl -e 'print log(2)/log(10)*(63+1)+2,"\n"'
        21.2659197224948
floor of that is 21, so %.21Lg is right for long doubles.

Note that std::numeric_limits<T>::digits == m+1,
so the precision for any type T is exactly:
       = (int)((M_LN2/M_LN10)*std::numeric_limits<T>::digits) + 2
i.e. 9 for float, 17 for double, 21 for long double.

=========================================================================
Geoffrey Irving throws a wrench into it:

    One question about this: is it better to use 9 digits for floats for
    repr, or always use 17?  The problem with 9 is that I'm not sure that
        float -> string -> double -> float
    is always exact.  Don?
    Geoffrey

Oh man, I thought I had this all figured out a long time ago, but that
throws a wrench into it.
All right let's see.

I'm assuming the string->double conversion is bug-free,
i.e. it always returns a double that is as close as possible
to the decimal number of 9 significant digits
(if it doesn't, that's a bug in atof, which I've never seen).

So you are asking whether there exists a decimal number
of 9 significant 
is there any decimal number of 9 significant digits d
such that 
    closestFloat(closestDouble(d))
 != closestFloat(d)
where, in the case of a tie, either of the two options is allowed.






*/

#include <stdio.h>
#include <limits>
#include <math.h>

#define PRINT(x) printf("%s = %.21Lg\n", #x, (long double)(x))

// Note, this only gives sensible answers
// for float, double, long double; the answers are 9, 17, 21 respectively.
// For integer types it will give nonsense.
template<typename T>
static inline int fpprecision()
{
    return (int)((M_LN2/M_LN10)*std::numeric_limits<T>::digits) + 2;
}

template<typename T>
static inline void dump()
{
    PRINT(sizeof(T));
    PRINT(std::numeric_limits<T>::radix);
    PRINT(std::numeric_limits<T>::digits);
    PRINT((int)((M_LN2/M_LN10)*std::numeric_limits<T>::digits) + 2);
    PRINT(fpprecision<T>());
}

static float left(float x)
{
    int i = *(int *)&x - 1;
    return *(float *)&i;
}
static float right(float x)
{
    int i = *(int *)&x + 1;
    return *(float *)&i;
}
static double left(double x)
{
    long long i = *(long long *)&x - 1;
    return *(double *)&i;
}
static double right(double x)
{
    long long i = *(long long *)&x + 1;
    return *(double *)&i;
}

int main()
{
    dump<float>();
    dump<double>();
    dump<long double>();
    dump<long long double>();
    dump<int>();

    PRINT(sizeof(long long));
    PRINT(sizeof(long double)); // huh? size is 12 on IA32 and 16 on AMD64??
    PRINT(sizeof(long long double)); // huh? size is 8???

    float minusthree = -3;
    float minustwo = -2;
    float minusone = -1;
    float zero = 0;
    float one = 1;
    float two = 2;
    float three = 3;
    PRINT(*(int *)&minusthree);
    PRINT(*(int *)&minustwo);
    PRINT(*(int *)&minusone);
    PRINT(*(int *)&zero);
    PRINT(*(int *)&one);
    PRINT(*(int *)&two);
    PRINT(*(int *)&three);
    PRINT(left(1.f));
    PRINT(right(1.f));
    PRINT(1.f - left(1.f));
    PRINT(right(1.f) - 1.f);
    PRINT(left(1.));
    PRINT(right(1.));
    PRINT(1. - left(1.));
    PRINT(right(1.) - 1.);

    return 0;
} // main
