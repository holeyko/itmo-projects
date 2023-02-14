#include <iostream>
#include <vector>
#include <fstream>
#include <set>
#include <unordered_map>
#include <algorithm>

using namespace std;

int n, m;
unordered_map<int, int> sets;
bool contains_empty = false;

bool firstAxiom() {
    return contains_empty;
}

bool secondAxiom() {
    vector<bool> check(1 << n, true);
    for (int set = 0; set < 1 << n; ++set) {
        bool isExist = sets.find(set) != sets.end();
        check[set] = isExist;
        for (int j = 0; j < n; ++j) {
            int bit = 1 << j;
            check[set] = check[set & ~bit] & check[set];
        }
        
        if (isExist && !check[set]) {
            return false;
        }
    }
    
    return true;
}

bool thirdAxiom() {
    for (auto B = sets.begin(); B != sets.end(); ++B) {
        for (auto A = sets.begin(); A != sets.end(); ++A) {
            if (B->second > A->second) {
                bool flag = false;
                int Aset = A->first;
                int Bset = B->first;
                for (int i = 0; i < n; ++i) {
                    int bit = 1 << i;
                    if ((Bset & bit) && !(Aset & bit) && sets.find(Aset | bit) != sets.end()) {
                        flag = true;
                        break;
                    }
                }
                
                if (!flag) {
                    return false;
                }
            }           
        }
    }
    
    return true;
}

void solve() {
    ifstream input("check.in");
    ofstream output("check.out");

    input >> n >> m;
    for (int i = 0; i < m; ++i) {
        int count;
        input >> count;

        if (count == 0) {
            contains_empty = true;
        }

        int bitset = 0;
        for (int j = 0; j < count; ++j) {
            int el;
            input >> el;

            bitset |= (1 << (el - 1));
        }

        sets.insert({bitset, count});
    }
    input.close();
    
    if (firstAxiom() && secondAxiom() && thirdAxiom()) {
        output << "YES";
    } else {
        output << "NO";
    }
    output.close();
}

int main() {
    solve();
}
