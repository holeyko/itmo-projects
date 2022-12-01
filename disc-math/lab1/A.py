def exist_edge(graph, i, j):
    if i > j:
        return j in graph[i]
    else:
        return i in graph[j]

def solve():
    n = int(input())
    graph = [set() for i in range(n)]
    queue = [i for i in range(n)]

    for i in range(n):
        vertex = input()
        for k in range(len(vertex)):
            if vertex[k] == '1':
                graph[i].add(k)

    for k in range(4 * n):
        if not exist_edge(graph, queue[0], queue[1]):
            i = 2
            while not exist_edge(graph, queue[0], queue[i]) or not exist_edge(graph, queue[1], queue[i + 1]):
                i += 1
            queue[1:i + 1] = queue[1: i + 1][::-1]
        queue.append(queue.pop(0))

    print(' '.join([str(i + 1) for i in queue]))

solve()
