MODULE = 998_244_353

class Polynom:
    def __init__(self, values):
        self.values = values;
    
    def power(self):
        return self.size() - 1
    
    def size(self):
        return len(self.values)
    
    def __add__(self, other):
        tmp = []
        for i in range(max(self.size(), other.size())):
            firstVal = self.values[i] if i < self.size() else 0
            secondVal = other.values[i] if i < other.size() else 0

            tmp.append((firstVal + secondVal) % MODULE)

        return Polynom(tmp) 

    def __mul__(self, other):
        tmp = []
        for i in range(self.power() + other.power() + 1):
            val = 0
            for j in range(i + 1):
                firstVal = self.values[j] if j < self.size() else 0
                secondVal = other.values[i - j] if i - j < other.size() else 0
                val = (val + (firstVal * secondVal) % MODULE) % MODULE
            tmp.append(val)
        
        return Polynom(tmp)
    
    def __truediv__(self, other):
        tmp = []
        for i in range(1000):
            d = self.values[i] if i < self.size() else 0
            val = 0
            for j in range(i):
                b = other.values[i - j] if i - j < other.size() else 0
                val = (val + (-tmp[j] * b) % MODULE) % MODULE
            val = (val + d) % MODULE
            tmp.append(val)
        
        return Polynom(tmp)
    
    def __str__(self):
        return ' '.join([str(el) for el in self.values])


def main():
    n, k = map(int, input().split())
    p = Polynom(list(map(int, input().split())))
    q = Polynom(list(map(int, input().split())))
    
    plus = p + q
    multy = p * q
    divide = p / q
    
    print(plus.power())
    print(plus)
    print(multy.power())
    print(multy)
    print(divide)


main()
