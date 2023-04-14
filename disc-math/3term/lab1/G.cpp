#include <iostream>
#include <vector>
#include <unordered_set>
#include <queue>

using namespace std;

void bfs(int v) {
}

void solve() {
    int n, m;
    cin >> n >> m;

    int k;
    vector<unordered_set<int>> graph(n);
    vector<int> colors(n, -1);
    queue<int> q;

    
    for (int i = 0; i < m; ++i) {
        int from, to;
        cin >> from >> to;
        --from;
        --to;

        graph[from].insert(to);
        graph[to].insert(from);
    }


    int max_d = 0;
    for (int i = 0; i < n; ++i) {
        if (max_d < graph[i].size()) {
            max_d = graph[i].size();
        }
    }
    
    k = max_d;

    if (k % 2 == 0) {
        k += 1;
    }

    q.push(0);
    while (!q.empty()) {
        int v = q.front();
        q.pop();

        vector<bool> v_colors(k);
        for (int u : graph[v]) {
            if (colors[u] != -1) {
                v_colors[colors[u]] = true;
            }
        }

        int i;
        for (i = 0; i < graph.size(); ++i) {
            if (!v_colors[i]) {
                break;
            }
        }

        colors[v] = i;

        for (int u : graph[v]) {
            if (colors[u] == -1) {
                q.push(u);
            }
        }
    }

    cout << k << "\n";
    for (int i = 0; i < n; ++i) {
        cout << colors[i] + 1 << "\n";
    }
}

int main() {
    solve();
}
