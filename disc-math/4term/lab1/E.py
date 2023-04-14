
class Polynom:
    def __init__(self, vals = []):
        self.vals = vals
        self.glob_c = 1
    
    def size(self):
        return len(self.vals)

    def mulcoef(self, c):
        self.glob_c *= c
    
    def __getitem__(self, i):
        if i < 0 or i >= self.size():
            return 0
        return self.glob_c * self.vals[i]

    def __add__(self, other):
        new_vals = []
        for i in range(max(self.size(), other.size())):
            new_vals.append(self[i] + other[i])

        return Polynom(new_vals)

    def __mul__(self, other):
        new_vals = []
        for i in range(self.size() + other.size()):
            val = 0 
            for j in range(i + 1):
                val += self[j] * other[i - j]
            new_vals.append(val)
        
        return Polynom(new_vals)
    
    def calc(self, val):
        res = 0
        pow = 1
        for i in range(self.size()):
            res += pow * self[i]
            pow *= val
        
        return res
    

r = int(input())
d = int(input())
f = Polynom(list(map(int, input().split())))

q = Polynom([1])
mul = Polynom([1, -r])
for i in range(d + 1):
    q *= mul

a = Polynom([f.calc(i) * (r ** i) for i in range(d + 1)])
p = a * q

print(d)
print(' '.join([str(p[i]) for i in range(d + 1)]))
print(d + 1)
print(' '.join([str(q[i]) for i in range(d + 2)]))