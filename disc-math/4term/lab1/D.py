from fractions import Fraction
from math import factorial as fact

def mem(f):
    a = dict()
    def mem_f(*val):
        if val in a:
            return a[val]
        else:
            res = f(*val)
            a[val] = res
            return res
    
    return mem_f

@mem
def comb(n, k):
    if k == 0 or n == k:
        return 1
    return comb(n - 1, k - 1) + comb(n - 1, k)


class Polynom:
    def __init__(self, vals = []):
        self.vals = vals
        self.glob_c = Fraction(1)
    
    def size(self):
        return len(self.vals)

    def mulcoef(self, c):
        self.glob_c *= c
    
    def __getitem__(self, i):
        if i < 0 or i >= self.size():
            return Fraction(0)
        return self.glob_c * self.vals[i]

    def __add__(self, other):
        new_vals = []
        for i in range(max(self.size(), other.size())):
            new_vals.append(self[i] + other[i])

        return Polynom(new_vals)

    def __mul__(self, other):
        new_vals = []
        for i in range(self.size() + other.size()):
            val = Fraction(0) 
            for j in range(i + 1):
                val += self[j] * other[i - j]
            new_vals.append(val)
        
        return Polynom(new_vals)
    


r, k = map(int, input().split())
p = list(map(int, input().split()))

coefs = [0 for i in range(k + 1)]
for i in range(k, -1, -1):
    val = Fraction(0)
    for j in range(i + 1, k + 1):
        val += comb(j, i) * coefs[j]
    coefs[i] = Fraction(p[i], (-r) ** i) - val


R = Polynom()
pol = [Polynom([Fraction(1)])]
for i in range(1, k + 1):
    pol.append(pol[i - 1] * Polynom([Fraction(i), Fraction(1)]))

for i in range(k + 1):
    pol[i].mulcoef(Fraction(coefs[k - i], fact(i)))
    R += pol[i]

print(' '.join([str(R[i].numerator) + '/' + str(R[i].denominator) for i in range(k + 1)]))