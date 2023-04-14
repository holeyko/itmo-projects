#include <algorithm>
#include <fstream>
#include <iostream>
#include <set>
#include <vector>
 
using namespace std;
 
bool comparetasks(pair<long long, long long> &l, pair<long long, long long> &r) {
  return l.second > r.second;
}
 
void solve() {
  ifstream input("schedule.in");
  long long n;
  input >> n;
 
  long long sum_w = 0;
  set<long long> times;
 
  vector<pair<long long, long long>> tasks(n);
  for (long long i = 0; i < n; ++i) {
    long long d, w;
    input >> d >> w;
    tasks[i] = {d, w};
 
    times.insert(i + 1);
  }
  input.close();
 
  sort(tasks.begin(), tasks.end(), comparetasks);
 
  for (long long i = 0; i < n; ++i) {
    pair<long long, long long> &task = tasks[i];
    long long d = task.first;
    long long w = task.second;
 
    auto bound = times.upper_bound(d);
    if (bound == times.begin()) {
      sum_w += w;
    } else {
      times.erase(--bound);
    }
  }
 
  ofstream out("schedule.out");
  out << sum_w;
  out.close();
}
 
int main() {
  solve();
}
