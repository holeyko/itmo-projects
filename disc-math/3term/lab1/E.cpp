#include <iostream>
#include <vector>
#include <set>

using namespace std;

void solve() {
    int n;
    cin >> n;

    vector<vector<int>> graph(n);

    for (int i = 0; i < n - 1; ++i) {
        int from, to;
        cin >> from >> to;
        --from;
        --to;

        graph[from].push_back(to);
        graph[to].push_back(from);
    }

    vector<bool> used(n);
    vector<int> degree(n);
    set<int> leafs;

    for (int i = 0; i < n; ++i) {
        used[i] = false;
        degree[i] = graph[i].size();

        if (degree[i] == 1) {
            leafs.insert(i);
        }
    }

    for (int j = 0; j < n - 2; ++j) {
        int leaf = *leafs.begin();
        leafs.erase(leafs.begin());
        used[leaf] = true;

        for (int i = 0; i < graph[leaf].size(); ++i) {
            int v = graph[leaf][i];
            if (!used[v]) {
                cout << v + 1 << " ";
                
                --degree[v];
                if (degree[v] == 1) {
                    leafs.insert(v);
                }
            }
        }
    }
}

int main() {
    solve();
}
