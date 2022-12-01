def solve():
    n, m = map(int, input().split())
    graph = [set() for i in range(n)];

    for i in range(m):
        fr, to = map(int, input().split())
        fr -= 1
        to -= 1

        graph[fr].add(to)
        graph[to].add(fr)

    degres = []
    for i in range(n):
        degres.append((i, len(graph[i])))
    
    degres = sorted(degres, key=lambda x: x[1], reverse=True)
    colors = [-1 for i in range(n)]

    k = 0
    countUncolored = n
    while countUncolored != 0:
        k += 1

        used = [False] * n
        for i in range(n):
            if not used[i] and colors[i] == -1:
                colors[i] = k
                countUncolored -= 1

                for u in graph[i]:
                    used[u] = True

    if (k % 2 == 0):
        k += 1

    print(k)
    for i in range(n):
        print(colors[i])


solve()
