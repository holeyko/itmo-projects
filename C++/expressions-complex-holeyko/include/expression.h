#pragma once

#include "complex.h"

#include <functional>
#include <map>
#include <memory>

namespace {
using expr_values_type = std::map<std::string, Complex> const &;

struct VariableCalc
{
    Complex operator()(const std::string & name, expr_values_type values) const { return values.at(name); }
};

struct ConstCalc
{
    Complex operator()(const Complex & complex, [[maybe_unused]] expr_values_type values) const { return complex; }
};
} // namespace

struct Expression
{
    virtual ~Expression() = default;

    virtual Complex eval(expr_values_type values = {}) const = 0;

    virtual Expression * clone() const = 0;

    friend std::ostream & operator<<(std::ostream & out, const Expression & expression);

private:
    virtual void str_to_ostream(std::ostream & out) const = 0;
};

template <class Value, class Calc, class ValueArg = Value>
class Primitive : public Expression
{
    Calc calculate{};
    Value m_value;

    void str_to_ostream(std::ostream & out) const override
    {
        out << m_value;
    }

public:
    Primitive(const ValueArg & value_arg)
        : m_value(value_arg)
    {
    }

    Expression * clone() const override
    {
        return new Primitive(m_value);
    }

    Complex eval(expr_values_type values = {}) const override
    {
        return calculate(m_value, values);
    };
};

template <char sign, class Calc>
class UnaryOperation : public Expression
{
    Calc calculate{};
    const std::shared_ptr<Expression> m_elem;

    void str_to_ostream(std::ostream & out) const override
    {
        out << "(" << sign << *m_elem << ")";
    }

    UnaryOperation(const std::shared_ptr<Expression> & elem)
        : m_elem(elem)
    {
    }

public:
    UnaryOperation(const Expression & elem)
        : m_elem(elem.clone())
    {
    }

    Expression * clone() const override
    {
        return new UnaryOperation(m_elem);
    }

    Complex eval(expr_values_type values = {}) const override
    {
        return calculate(m_elem->eval(values));
    }
};

template <char sign, class Calc>
class BinaryOperation : public Expression
{
    Calc calculate{};
    const std::shared_ptr<Expression> m_left;
    const std::shared_ptr<Expression> m_right;

    void str_to_ostream(std::ostream & out) const override
    {
        out << "(" << *m_left << " " << sign << " " << *m_right << ")";
    }

    BinaryOperation(const std::shared_ptr<Expression> & left, const std::shared_ptr<Expression> & right)
        : m_left(left)
        , m_right(right)
    {
    }

public:
    BinaryOperation(const Expression & left, const Expression & right)
        : m_left(left.clone())
        , m_right(right.clone())
    {
    }

    Expression * clone() const override
    {
        return new BinaryOperation(m_left, m_right);
    }

    Complex eval(expr_values_type values = {}) const override
    {
        return calculate(m_left->eval(values), m_right->eval(values));
    }
};

using Variable = Primitive<std::string, VariableCalc, std::string_view>;
using Const = Primitive<Complex, ConstCalc>;

using Negate = UnaryOperation<'-', std::negate<Complex>>;
using Conjugate = UnaryOperation<'~', std::bit_not<Complex>>;

using Add = BinaryOperation<'+', std::plus<Complex>>;
using Subtract = BinaryOperation<'-', std::minus<Complex>>;
using Multiply = BinaryOperation<'*', std::multiplies<Complex>>;
using Divide = BinaryOperation<'/', std::divides<Complex>>;

Negate operator-(const Expression & expr);
Conjugate operator~(const Expression & expr);

Add operator+(const Expression & l_obj, const Expression & r_obj);
Subtract operator-(const Expression & l_obj, const Expression & r_obj);
Multiply operator*(const Expression & l_obj, const Expression & r_obj);
Divide operator/(const Expression & l_obj, const Expression & r_obj);
