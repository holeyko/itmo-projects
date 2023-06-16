#include <iostream>
#include <variant>
#include <functional>

class X {};
class Y {};
class Z {};

template<class A, class N>
A negate(N z)
{
    throw ("Value of type N is impossible");
}

template<class A, class B>
A func1(A a)
{
    return [&a](B y){ return a; }(B());
}

template<class A, class B>
std::variant<A, B> func2(std::pair<A, B> pair)
{
    return std::variant<A, B>(pair.first);
}

template<class A, class B, class C>
std::variant<std::pair<A, B>, std::pair<A, C>> func3(std::pair<A, std::variant<B, C>> pair)
{
    if (pair.second.index() == 0) {
        return {{pair.first, std::get<B>(pair.second)}};
    } else {
        return {{pair.first, std::get<C>(pair.second)}};
    }
}

template<class A, class B, class C>
std::pair<std::function<A(B)>, std::function<A(C)>> func5(std::function<A(std::variant<B, C>)> value)
{
    return {
       [&value](){return }
    }
}

int main()
{
    func1<X, Y>(X());
    func2(std::pair<X, Y>(X(), Y()));
    func3({A(), {B()}});

}
