#include "complex.h"

#include <cmath>
#include <sstream>

Complex::Complex(double real, double imag)
    : m_real(real)
    , m_imag(imag)
{
}

double Complex::real() const
{
    return m_real;
}

double Complex::imag() const
{
    return m_imag;
}

double Complex::abs() const
{
    return std::hypot(m_real, m_imag);
}

std::string Complex::str() const
{
    std::ostringstream ss;
    ss << *this;
    return ss.str();
}

Complex operator-(const Complex & complex)
{
    return {-complex.m_real, -complex.m_imag};
}

Complex operator~(const Complex & complex)
{
    return {complex.m_real, -complex.m_imag};
}

Complex operator+(const Complex & l_complex, const Complex & r_complex)
{
    return {l_complex.m_real + r_complex.m_real, l_complex.m_imag + r_complex.m_imag};
}

Complex & operator+=(Complex & l_complex, const Complex & r_complex)
{
    return (l_complex = l_complex + r_complex);
}

Complex operator-(const Complex & l_complex, const Complex & r_complex)
{
    return {l_complex.m_real - r_complex.m_real, l_complex.m_imag - r_complex.m_imag};
}

Complex & operator-=(Complex & l_complex, const Complex & r_complex)
{
    return (l_complex = l_complex - r_complex);
}

Complex operator*(const Complex & l_complex, const Complex & r_complex)
{
    return {l_complex.m_real * r_complex.m_real - l_complex.m_imag * r_complex.m_imag, l_complex.m_real * r_complex.m_imag + l_complex.m_imag * r_complex.m_real};
}

Complex & operator*=(Complex & l_complex, const Complex & r_complex)
{
    return (l_complex = l_complex * r_complex);
}

Complex operator/(const Complex & l_complex, const Complex & r_complex)
{
    if (r_complex == 0) {
        return {l_complex.m_real / r_complex.m_real, l_complex.m_imag / r_complex.m_imag};
    }
    double denominator = r_complex.m_real * r_complex.m_real + r_complex.m_imag * r_complex.m_imag;
    Complex tmp = l_complex * ~r_complex;
    return {tmp.m_real / denominator, tmp.m_imag / denominator};
}

Complex & operator/=(Complex & l_complex, const Complex & r_complex)
{
    l_complex = l_complex / r_complex;
    return l_complex;
}

bool operator==(const Complex & l_complex, const Complex & r_complex)
{
    return l_complex.m_real == r_complex.m_real && l_complex.m_imag == r_complex.m_imag;
}

bool operator!=(const Complex & l_complex, const Complex & r_complex)
{
    return !(l_complex == r_complex);
}

std::ostream & operator<<(std::ostream & output, const Complex & complex)
{
    output << "(" << complex.m_real << "," << complex.m_imag << ")";
    return output;
}
