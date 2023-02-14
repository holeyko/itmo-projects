#include "expression.h"

#include <iostream>

int main()
{
    Add sum(Const(0), Variable("x"));
    std::cout << sum.eval({{"x", 10}});
}
