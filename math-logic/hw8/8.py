from types import FunctionType


# Base functions

def Z(_=0):
    return 0


def U(k):
    return lambda x: x[k - 1]


def N(x):
    return U(1)(x) + 1


def S(g, funcs):
    return lambda x: g([f(x) for f in funcs])


def R(f, g):
    def recur(x, y):
        res = f(x)
        for i in range(y):
            res = g([x, i, res])

        return res

    return recur

# ~Base functions


# Custom functions

def sum(x):
    f = R(
        U(1),
        S(N, [U(3)])
    )
    return f([U(1)(x)], U(2)(x))


def mul(x):
    f = R(Z, S(
        sum,
        [lambda x: U(1)(U(1)(x)), U(3)]
    ))
    return f([U(1)(x)], U(2)(x))


def norm_mul(x):
    return x[0] * x[1]


def dec(x):
    f = R(Z, U(2))
    return f(x, U(1)(x))


def lim_subt(x):
    f = R(U(1), S(dec, [U(3)]))
    return f([U(1)(x)], U(2)(x))


def fact(x):
    f = R(
        lambda _: N([Z()]),
        S(norm_mul, [lambda x: N([U(2)(x)]), U(3)])
    )
    return f(x, U(1)(x))


# ~Custom functions


# Tests

def sum_test():
    print('Start sum tests...')

    assert (sum([1, 2]) == 3)
    assert (sum([2, 1]) == 3)
    assert (sum([5, 8]) == 13)
    assert (sum([100, 9]) == 109)
    assert (sum([0, 9]) == 9)

    print('Test passed!')
    print()


def multiply_test():
    print('Start multiply tests...')

    assert (mul([1, 2]) == 2)
    assert (mul([2, 1]) == 2)
    assert (mul([5, 8]) == 40)
    assert (mul([9, 2]) == 18)
    assert (mul([9, 0]) == 0)

    print('Test passed!')
    print()


def limited_subtract_test():
    print('Start limited subtract tests...')

    assert (lim_subt([0, 9]) == 0)
    assert (lim_subt([9, 0]) == 9)
    assert (lim_subt([8, 8]) == 0)
    assert (lim_subt([3, 2]) == 1)

    print('Test passed!')
    print()


def fact_test():
    print('Start fact tests...')

    assert (fact([4]) == 24)
    assert (fact([0]) == 1)
    assert (fact([1]) == 1)
    assert (fact([4]) == 24)
    assert (fact([10]) == 3_628_800)
    assert (fact([20]) == 2_432_902_008_176_640_000)

    print('Test passed!')
    print()

# ~Tests


def main():
    sum_test()
    multiply_test()
    limited_subtract_test()
    fact_test()


main()
