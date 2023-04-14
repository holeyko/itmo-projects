k = int(input())
a = list(map(int, input().split()))
c = [1] + list(map(lambda x: -int(x), input().split()))

p = [a[0]]
for i in range(1, k):
    val = 0
    for j in range(1, k + 1):
        a_j = a[i - j] if 0 <= i - j else 0
        val += -c[j] * a_j
    p.append(a[i] - val)

while p[-1] == 0:
    p.pop()

print(len(p) - 1)
print(' '.join([str(el) for el in p]))
print(len(c) - 1)
print(' '.join([str(el) for el in c]))