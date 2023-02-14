#include <iostream>
#include <vector>
#include <set>

using namespace std;

void solve() {
    int n;
    cin >> n;

    vector<vector<int>> graph(n);
    vector<int> degree(n, 1);
    vector<int> code(n - 2);
    
    for (int i = 0; i < n - 2; ++i) {
        int val;
        cin >> val;
        --val;

        ++degree[val];
        code[i] = val;
    }

    set<int> leafs;
    
    for (int i = 0; i < n; ++i) {
        if (degree[i] == 1) {
            leafs.insert(i);
        }
    }

    for (int i = 0; i < n - 2; ++i) {
        int leaf = *leafs.begin();
        leafs.erase(leafs.begin());

        int v = code[i];
        
        cout << leaf + 1 << " " << v + 1 << "\n";

        if (--degree[v] == 1)
            leafs.insert(v);
    }
    
    cout << *leafs.begin() + 1 << " " << *(--leafs.end()) + 1 << "\n";
}

int main() {
    solve();
}
