#include "expression.h"

std::ostream & operator<<(std::ostream & out, const Expression & expr)
{
    expr.str_to_ostream(out);
    return out;
}

Negate operator-(const Expression & expr)
{
    return Negate(expr);
}

Conjugate operator~(const Expression & expr)
{
    return Conjugate(expr);
}

Add operator+(const Expression & l_expr, const Expression & r_expr)
{
    return Add(l_expr, r_expr);
}

Subtract operator-(const Expression & l_expr, const Expression & r_expr)
{
    return Subtract(l_expr, r_expr);
}

Multiply operator*(const Expression & l_expr, const Expression & r_expr)
{
    return Multiply(l_expr, r_expr);
}

Divide operator/(const Expression & l_expr, const Expression & r_expr)
{
    return Divide(l_expr, r_expr);
}
