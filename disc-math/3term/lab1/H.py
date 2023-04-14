class Graph:
    def __init__(self, vertexes):
        self.vertexes = vertexes
        self.size = len(vertexes)

        self.countEdges = 0
        for edges in vertexes:
            self.countEdges += len(edges)
        self.countEdges = int(self.countEdges / 2)
    
    def join(self, u, v):
        min_v = min(u, v)
        max_v = max(u, v)

        new_vertexes = []
        for i in range(self.size):
            if i == min_v:
                new_vertexes.append(set([el for el in self.vertexes[min_v] if el != max_v]))
            elif i == max_v:
                new_vertexes[min_v].update(set([el for el in self.vertexes[max_v] if el != min_v]))
            else:
                insert = set()
                for el in self.vertexes[i]:
                    if el == max_v:
                        insert.add(min_v)
                    else:
                        insert.add(el)
                new_vertexes.append(insert)

        return Graph(new_vertexes)

    def split(self, u, v):
        new_vertexes = [set() for i in range(self.size)]

        for i in range(self.size):
            if i == u or i == v:
                new_vertexes[i] = set([el for el in self.vertexes[i] if el != u and el != v])
            else:
                new_vertexes[i] = self.vertexes[i]

        return Graph(new_vertexes)


class Polinom:
    def __init__(self, items):
        self.items = items
        self.degree = len(items) - 1

    def add(self, other):
        new_size = max(self.degree, other.degree) + 1
        new_items = [0 for i in range(new_size)]

        for i in range(new_size):
            if i <= self.degree:
                new_items[i] += self.items[i]
            if i <= other.degree:
                new_items[i] += other.items[i]

        return Polinom(new_items)

    def multiply_on_const(self, const):
        self.items = list(map(lambda el: el * const, self.items))

    def __str__(self):
        res = ''
        for i in range(len(self.items) - 1, -1, -1):
            res += str(self.items[i]) + ' '

        return res


def solve():
    n, m = map(int, input().split())
    vertexes = [set() for i in range(n)]

    for i in range(m):
        fr, to = map(int, input().split())
        fr -= 1
        to -= 1

        vertexes[fr].add(to)
        vertexes[to].add(fr)

    graph = Graph(vertexes)
    res = recur(graph)

    print(res.degree)
    print(res)

def recur(graph):
    if graph.countEdges == 0:
        args = [0 for i in range(graph.size)]
        args.append(1)

        return Polinom(args)
    else:
        u, v = 0, 0
        for i in range(len(graph.vertexes) - 1, -1, -1):
            if len(graph.vertexes[i]) != 0:
                u = i
                v = max(graph.vertexes[i])
                
                break

        res_splitted_graph = recur(graph.split(u, v))
        res_joined_graph = recur(graph.join(u, v))
        res_joined_graph.multiply_on_const(-1)

        return res_splitted_graph.add(res_joined_graph)


solve()
