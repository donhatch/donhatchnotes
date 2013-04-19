//I can never remember how to do a custom sort in C++.
//It's this...

#include <vector>
#include <algorithm> // for sort
#include <functional> // for binary_negate

template<class T>
static bool myLessThan(const T &a, const T &b) // the &'s aren't necessary, but may help prevent some creation and destruction of temporaries in the case that T is a large or complicated type
{
    return a < b;
}

template<class T>
struct myLessThanFunctor
{
    typedef T first_argument_type;
    typedef T second_argument_type;
    bool operator()(const T &a, const T &b) const
    {
        return a < b;
    }
};

#if 0
// XXX hmm, how to make this work?
template<class T, class Compare>
struct Not
{
    Not(Compare &compare) : compare(compare) {}
    bool operator(const T &a, const T &b)
    {
        return !compare(a, b);
    }
    Compare& compare;
}
#endif

static void foo()
{
    int A[3] = {1,3,2};
    std::sort(A,
              A+3,
              myLessThan<int>);
    printf("A = {%d %d %d}\n", A[0],A[1],A[2]);
    std::vector<int> B(A,A+3);
    std::sort(B.begin(),
              B.end(),
              myLessThan<int>);
    printf("B = {%d %d %d}\n", B[0],B[1],B[2]);
    int C[3] = {1,3,2};
    std::sort(C,
              C+3,
              //std::not2(myLessThan<int>));
              std::not2(myLessThanFunctor<int>())); // XXX WOOPS! not2 is not appropriate-- it gives a non-strict order, not a strict one!
    printf("C = {%d %d %d}\n", C[0],C[1],C[2]);
}

/*
    By the way, in boost/lambda there's something that lets you do:
    int B[3] = {1,2,3};
    std::sort(B, B+3, _1 > _2);
*/

#include <boost/lambda/lambda.hpp>
using namespace boost::lambda; // so don't have to say boost::lambda::_1 etc.
void bar()
{
    int D[3] = {1,2,3};
    std::sort(D,
              D+3,
              _1 > _2);
    printf("D = {%d %d %d}\n", D[0],D[1],D[2]);
}

int main(int,char**)
{
    foo();
    bar();
}
