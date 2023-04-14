MODULE = 10 ** 9 + 7

def md(val):
    return val % MODULE


class Polynom:
    def __init__(self, vals = []):
        self.size = len(vals)
        self.vals = vals
    
    def deg(self):
        return self.size - 1

    def __getitem__(self, i):
        if i < 0 or i >= self.size:
            return 0
        else:
            return self.vals[i]
    
    def __add__(self, other):
        new_vals = []
        for i in range(max(self.deg(), other.deg()) + 1):
            new_vals.append(self[i], other[i])

        return Polynom(new_vals)

    def __mul__(self, other):
        new_vals = []
        for i in range(self.deg() + other.deg() + 1):
            val = 0
            for j in range(i):
                val += self[j] * other[i - j]            
            new_vals.append(val)
        
        return Polynom(new_vals)


k, m = map(int, input().split())
used = [False for i in range(m + 1)]
bitree = Polynom([0 for i in range(m + 1)])

for index in map(int, input().split()):
    used[index] = True

bitree.vals[0] = 1
prefix = [0 for i in range(m + 1)]
prefix[0] = 1

result = []
for i in range(1, m + 1):
    val = 0
    for j in range(1, i + 1):
        if (used[j]): 
            val = md(val + prefix[i - j])
    
    bitree.vals[i] = md(val)
    
    for j in range(i + 1):
        prefix[i] = md(prefix[i] + md(bitree[j] * bitree[i - j]))
    
    result.append(bitree[i])

print(' '.join([str(el) for el in result]))