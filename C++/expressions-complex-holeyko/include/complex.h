#pragma once

#include <iosfwd>

struct Complex
{
    Complex(double real = 0, double imag = 0);

    double real() const;
    double imag() const;

    double abs() const;

    std::string str() const;

    friend Complex operator+(const Complex & l_complex, const Complex & r_complex);
    friend Complex & operator+=(Complex & l_complex, const Complex & r_complex);

    friend Complex operator-(const Complex & l_complex, const Complex & r_complex);
    friend Complex & operator-=(Complex & l_complex, const Complex & r_complex);

    friend Complex operator*(const Complex & l_complex, const Complex & r_complex);
    friend Complex & operator*=(Complex & l_complex, const Complex & r_complex);

    friend Complex operator/(const Complex & l_complex, const Complex & r_complex);
    friend Complex & operator/=(Complex & l_complex, const Complex & r_complex);

    friend Complex operator-(const Complex & complex);
    friend Complex operator~(const Complex & complex);

    friend bool operator==(const Complex & l_complex, const Complex & r_complex);
    friend bool operator!=(const Complex & l_complex, const Complex & r_complex);

    friend std::ostream & operator<<(std::ostream &, const Complex &);

private:
    double m_real;
    double m_imag;
};
