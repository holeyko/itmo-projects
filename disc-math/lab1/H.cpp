#include <iostream>
#include <vector>
#include <set>

using namespace std;

using graph_type = vector<set<int>>;

struct Graph {
    graph_type vertexes;
    int size;
    int count_edges;

    Graph(const graph_type &vertexes) {
        this->vertexes = vertexes;
        this->size = vertexes.size();

        this->count_edges = 0;
        for (auto edges: vertexes) {
            this->count_edges += edges.size();
        }
        this->count_edges /= 2;
    }

    Graph join(int u, int v) {
        int min_v = min(u, v);
        int max_v = max(u, v);

        vector<bool> used(size, false);
        graph_type new_vertexes(size - 1);

        for (auto el: vertexes[max_v]) {
            int index = el > max_v ? el - 1 : el;

            new_vertexes[index] = vertexes[el];
            new_vertexes[index].erase(max_v);
            if (el != min_v) {
                new_vertexes[index].insert(min_v);
                used[el] = true;
            }
        }

        used[min_v] = true;
        used[max_v] = true;

        for (int i = 0; i < size; ++i) {
            if (!used[i]) {
                int index = i > max_v ? i - 1 : i;
                new_vertexes[index] = vertexes[i];
            }
        }

        return Graph(new_vertexes);
    }

    Graph split(int u, int v) {
        graph_type new_vertexes = this->vertexes;
        new_vertexes[u].erase(v);
        new_vertexes[v].erase(u);

        return Graph(new_vertexes);
    }
};

struct Polinom {
    vector<int> items;
    int degree;

    Polinom(const vector<int> &items) {
        this->items = items;
        this->degree = items.size() - 1;
    }

    Polinom add(const Polinom &other) {
        int new_size = max(degree, other.degree) + 1;
        vector<int> new_items(new_size, 0);

        for (int i = 0; i < new_size; ++i) {
            if (i <= degree) {
                new_items[i] += items[i];
            }
            if (i <= other.degree) {
                new_items[i] += other.items[i];
            }
        }

        return Polinom(new_items);
    }

    void multiply_on_const(int c) {
        for (int i = 0; i < items.size(); ++i) {
            items[i] *= c;
        }
    }
};

Polinom recur(Graph graph) {
    if (graph.count_edges == 0) {
        vector<int> args(graph.size, 0);
        args.push_back(1);

        return Polinom(args);
    } else {
        int u = 0;
        int v = 0;

        for (int i = graph.size - 1; i >= 0; --i) {
            if (!graph.vertexes[i].empty()) {
                u = i;
                v = *(--graph.vertexes[i].end());

                break;
            }
        }

        Polinom res_spl_graph = recur(graph.split(u, v));
        Polinom res_join_graph = recur(graph.join(u, v));

        res_join_graph.multiply_on_const(-1);

        return res_spl_graph.add(res_join_graph);
    }
}

void solve() {
    int n, m;
    cin >> n >> m;
    graph_type vertexes(n);

    for (int i = 0; i < m; ++i) {
        int from, to;
        cin >> from >> to;
        --from;
        --to;

        vertexes[from].insert(to);
        vertexes[to].insert(from);
    }

    Graph graph(vertexes);
    Polinom res = recur(graph);

    cout << res.degree << "\n";
    for (int i = res.items.size() - 1; i >= 0; --i) {
        cout << res.items[i] << " ";
    }
}

int main() {
    solve();
}
