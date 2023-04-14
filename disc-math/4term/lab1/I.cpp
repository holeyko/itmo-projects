#include <iostream>
#include <vector>

using namespace std;

using ll = long long;

ll MODULE = 104857601ll;

ll md(ll val) {
    return val % MODULE;
}

ll pos(ll val) {
    ll res = val;
    while (res < 0) {
        res += MODULE;
    }
    
    return res;
}

int main() {
    int k;
    ll n;
    cin >> k >> n;
    --n;

    vector<ll> A(2 * k, 0ll), Q(k + 1, 0ll), nQ(k + 1, 0ll), T(k + 1, 0ll);
    for (int i = 0; i < k; ++i) {
        cin >> A[i];
    }
    Q[0] = 1;
    for (int i = 1; i < k + 1; ++i) {
        ll a;
        cin >> a;
        Q[i] = md(-a + MODULE);
    }
    
    while (n >= k) {
        for (int i = k; i < A.size(); ++i) {
            A[i] = 0;
            for (int j = 1; j < Q.size(); ++j) {
                A[i] = pos(md(A[i] - Q[j] * A[i - j]));
            }
        }
        
        for (int i = 0; i < Q.size(); ++i) {
            if (i % 2 == 0) 
                nQ[i] = Q[i];
            else
                nQ[i] = md(-Q[i] + MODULE);
        }
        
        for (int i = 0; i < 2 * k + 1; i += 2) {
            ll c = 0;
            for (int j = 0; j <= i; ++j) {
                ll a = j > k ? 0 : Q[j];
                ll b = i - j > k ? 0 : nQ[i - j];
                c = md(c + a * b + MODULE);
            }
            T[i / 2] = c;
        }
        
        Q = T;
        int last = 0;
        for (int i = 0; i < A.size(); ++i) {
            if (i % 2 == n % 2) {
                A[last++] = A[i];
            }
        }
        n /= 2;
    }
    
    cout << A[n] << '\n';
}