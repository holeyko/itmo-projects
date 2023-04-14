#include <iostream>
#include <vector>
#include <cmath>

using namespace std;
using ll = long long;

ll MODULE = 998244353;

ll md(const ll &val)
{
    return val % MODULE;
}

ll positive(const ll& val)
{
    ll res = val;
    while (res < 0)
    {
        res += MODULE;
    }

    return res;
}

struct Polynom
{
    vector<ll> vals;

    Polynom(const vector<ll> &vals)
        : vals(vals)
    {
    }
    
    int size() const {
        return vals.size();
    }

    ll operator[](int index) const
    {
        if (index < 0 || index >= size())
        {
            return 0;
        }

        return vals[index];
    }

    Polynom operator+(const Polynom &other) const
    {
        vector<ll> new_vals(max(size(), other.size()));
        for (int i = 0; i < max(size(), other.size()); ++i)
        {
            new_vals[i] = md((*this)[i] + other[i]);
        }

        return Polynom(new_vals);
    }

    Polynom operator*(const Polynom &other) const
    {
        vector<ll> new_vals(size() + other.size());
        for (int i = 0; i < size() + other.size(); ++i)
        {
            ll val = 0;
            for (int j = 0; j <= i; ++j)
            {
                val = md(val + md((*this)[j] * other[i - j]));
                val = positive(val);
            }

            new_vals[i] = val;
        }

        return Polynom(new_vals);
    }
};

int main()
{
    int k, n;
    cin >> k >> n;

    vector<vector<ll>> coefs(k + 1, vector<ll>(k + 1));
    for (int i = 0; i <= k; ++i)
    {
        coefs[i][0] = 1;
        coefs[i][i] = 1;
        for (int j = 1; j < i; ++j)
        {
            coefs[i][j] = md(coefs[i - 1][j - 1] + coefs[i - 1][j]);
            coefs[i][j] = positive(coefs[i][j]);
        }
    }

    int len_a = ceil((double)(k - 1) / 2);
    int len_b = ceil((double)k / 2);
    vector<ll> vals_a(len_a);
    vector<ll> vals_b(len_b);

    for (int i = 0; i < len_a; ++i)
    {
        int d = i % 2 == 0 ? 1 : -1;
        vals_a[i] = coefs[k - 1 - i - 1][i] * d;
    }
    for (int i = 0; i < len_b; ++i)
    {
        int d = i % 2 == 0 ? 1 : -1;
        vals_b[i] = coefs[k - i - 1][i] * d;
    }

    Polynom A(vals_a);
    Polynom B(vals_b);
    vector<ll> vals_i; 
    vals_i.push_back(1 / B[0]);
    Polynom I(vals_i);

    for (int i = 1; i <= n; ++i)
    {
        ll c = 0;
        for (int j = 1; j <= i; ++j)
        {
            c = md(c + md(B[j] * I[i - j]));
            c = positive(c);
        }

        I.vals.push_back(md(-c / I[0] + MODULE));
        I.vals[I.size() - 1] = positive(I[I.size() - 1]);
    }

    Polynom R = A * I;
    for (int i = 0; i < n; ++i)
    {
        cout << R[i] << '\n';
    }

    return 0;
}
