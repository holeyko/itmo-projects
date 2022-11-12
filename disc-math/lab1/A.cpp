#include <iostream>
#include <unordered_set>
#include <vector>

using namespace std;

void print_int_vector(const vector<int> & vector) {
    for (int el : vector) {
        cout << el + 1 << " ";
    }
}

bool exist_edge(const vector<unordered_set<int>> & graph, int i, int j) {
    if (i > j) {
        return graph[i].find(j) != graph[i].end();
    } else {
        return graph[j].find(i) != graph[j].end();
    }
}

void solve() {
    int n;
    cin >> n;
    vector<unordered_set<int>> graph(n);
    vector<int> queue(n);

    for (int i = 0; i < n; ++i) {
        queue[i] = i;

        if (i == 0) {
            continue;
        }

        string vertexes;
        cin >> vertexes;
        for (int j = 0; j < vertexes.size(); ++j) {
            if (vertexes[j] == '1') {
                graph[i].insert(j);
            }
        }
    }

    for (int k = 0; k < n * (n - 1); ++k) {
        if (!exist_edge(graph, queue[0], queue[1])) {
            int i = 2;
            while (!exist_edge(graph, queue[0], queue[i]) || !exist_edge(graph, queue[1], queue[i + 1])) {
                ++i;
            }

            for (int j = 0; j < i / 2; ++j) {
                int tmp = queue[1 + j];
                queue[1 + j] = queue[i - j];
                queue[i - j] = tmp;
            }
        }

        queue.push_back(queue[0]);
        queue.erase(queue.begin());
    }

    print_int_vector(queue);
}

int main() {
    solve();
}