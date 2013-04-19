#include <boost/lambda/lambda.hpp>
#include <boost/lambda/bind.hpp>
using namespace boost::lambda; // so don't have to say boost::lambda::_1 etc.

class Moose
{
};

/*
template<class T>
int operator[](T* array, Moose moose)
{
    return 0;
}
*/

int main(int,char**)
{
    std::vector<double> D;
    D.push_back(2.);
    D.push_back(1.);
    D.push_back(3.);
    double indices[3] = {3,2,1};
    std::sort(indices,
              indices+3,
              _1 > _2);
    std::sort(indices,
              indices+3,
              bind(&std::vector<double>::operator[], &D, _1) > bind(&std::vector<double>::operator[], &D, _2));
    printf("indices = {%d %d %d}\n", indices[0],indices[1],indices[2]);
    return 0;
}
