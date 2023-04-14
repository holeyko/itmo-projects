MODULE = 998_244_353

def md(val):
    return val % MODULE


class Polynom:
    def __init__(self, vals = []):
        self.vals = vals
    
    def size(self):
        return len(self.vals)

    def __getitem__(self, i):
        if i < 0 or i >= self.size():
            return 0
        else:
            return self.vals[i]
    
    def __add__(self, other):
        new_vals = []
        for i in range(max(self.size(), other.size())):
            new_vals.append(md(self[i] + other[i]))

        return Polynom(new_vals)

    def __mul__(self, other):
        new_vals = []
        for i in range(self.size() + other.size() - 1):
            val = 0
            for j in range(i):
                val = md(val + self[j] * other[i - j])
            new_vals.append(val)
        
        return Polynom(new_vals)


n, m = map(int, input().split())
p = list(map(int, input().split()))

