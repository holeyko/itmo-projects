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

def accerman(n, m):
    return R(N, )([m], n)