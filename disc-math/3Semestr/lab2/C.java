import java.util.*;
import java.io.*;


public class C {
    private final static String INPUT_FILE = "matching.in";
    private final static String OUTPUT_FILE = "matching.out";
    
    private static List<List<Integer>> graph;
    private static int[] parent;
    private static int[] necessary;
    private static boolean[] visited;
    
    static boolean dfs(int v) {
        if (visited[v]) return false;

        visited[v] = true;
        for (int u : graph.get(v)) {
            if (parent[u] == -1 || dfs(parent[u])) {
                parent[u] = v;
                necessary[v] = u + 1;
                return true;
            }
        }

        return false;
    }

    static void solve() {
        try (
            BufferedReader input = new BufferedReader(new FileReader(INPUT_FILE));
            BufferedWriter output = new BufferedWriter(new FileWriter(OUTPUT_FILE))
        ) {
            int n = Integer.parseInt(input.readLine());
            graph = new ArrayList<>();

            parent = new int[n];
            Arrays.fill(parent, -1);

            necessary = new int[n];
            
            List<Pair<Integer, Integer>> weights = new ArrayList<>();
            String[] parsedWeights = input.readLine().split(" ");
            for (int i = 0; i < n; ++i) {
                int w = Integer.parseInt(parsedWeights[i]);
                weights.add(new Pair<>(w, i));
            }
            weights.sort((a, b) -> b.first - a.first);
            
            for (int i = 0; i < n; ++i) {
                String[] parsedLine = input.readLine().split(" ");
                int k = Integer.parseInt(parsedLine[0]);
                
                List<Integer> vertexes = new ArrayList<>();
                for (int j = 1; j <= k; ++j) {
                    vertexes.add(Integer.parseInt(parsedLine[j]) - 1);
                }
                
                graph.add(vertexes);
            }
            
            for (int i = 0; i < n; ++i) {
                visited = new boolean[n];
                dfs(weights.get(i).getSecond());
            }
            
            StringBuilder ans = new StringBuilder();
            for (int v : necessary) {
                ans.append(v).append(" ");
            }
            output.write(ans.toString());
        } catch (IOException ignored) {
            // NO Operation
        }
    }
    
    static class Pair<F, S> {
        private F first;
        private S second;
        
        public Pair(F first, S second) {
            this.first = first;
            this.second = second;
        }
        
        public F getFirst() {
            return first;
        }

        public S getSecond() {
            return second;
        }
    }

    public static void main(String[] args) {
        solve();
    }
}
