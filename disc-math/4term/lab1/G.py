from math import gcd


def comb(n, k):
    res = 1
    for i in range(n - k + 1, n + 1):
        res *= i
    for j in range(2, k + 1):
        res //= j
    
    return res


def solution():
    global s, p, ln
    res = [0 for i in range(ln)]
    l, r = [], []
    
    if s[p] == 'L':
        p += 2
        l = solution()

        p += 1
        res[0] = 1
        
        for i in range(1, ln):
            val = 0
            for j in range(1, i + 1):
                val += l[j] * res[i - j]
            
            res[i] = val
    elif s[p] == 'C':
        p += 2
        l = solution()

        p += 1
        coefs = [[0 for i in range(ln)] for j in range(ln)]
        for i in range(ln):
            coefs[i][0] = 0
            coefs[0][i] = 0
            coefs[i][1] = l[i]

        for i in range(1, ln):
            for j in range(2, ln):
                val = 0
                for y in range(1, i):
                    val += l[y] * coefs[i - y][j - 1]        
                coefs[i][j] = val
        
        res[0] = 0
        for i in range(1, ln):
            val = 0
            for j in range(1, i + 1):
                push = 0
                for y in range(0, j):
                    g = gcd(j, y)
                    push += coefs[(i * g) // j][g] if (i % (j // g)) == 0 else 0
                val += push // j

            res[i] = val
    elif s[p] == 'P':
        p += 2
        l = solution()

        p += 1
        r = solution()
        
        p += 1
        for i in range(ln):
            val = 0
            for j in range(i + 1):
                val += l[j] * r[i - j]
            
            res[i] = val
    elif s[p] == 'B':
        for i in range(len(res)):
            res[i] = 1 if i == 1 else 0
        
        p += 1
    elif s[p] == 'S':
        p += 2
        l = solution()

        p += 1
        mat = [[0 for j in range(ln)] for i in range(ln)]
        mat[0][0] = 1
        for i in range(1, ln):
            mat[i][0] = 0
            mat[0][i] = 1
        
        res[0] = 1
        for i in range(1, ln):
            for j in range(1, ln):
                val = 0
                for y in range((i // j) + 1):
                    val += comb(max(l[j] + y - 1, 0), y) * mat[i - y * j][j - 1]

                mat[i][j] = val
            
            res[i] = mat[i][i]

    return res


ln = 7
s = input()
p = 0
print(' '.join([str(el) for el in solution()]))