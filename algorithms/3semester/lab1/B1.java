import java.util.*;
import java.io.*;

public class B1 {
    static int n, m, s, t;
    static Map<Integer, Set<ToEdge>> graph;
    static boolean[] used;
    static List<Integer> sortedVertex;

    static void solve() throws IOException {
        BufferedReader input = new BufferedReader(
                new InputStreamReader(System.in));

        int[] params = parseIntArray(input.readLine(), " ");
        n = params[0];
        m = params[1];
        s = params[2] - 1;
        t = params[3] - 1;

        graph = new HashMap<>();
        for (int i = 0; i < m; ++i) {
            int from, to, value;
            int[] edge = parseIntArray(input.readLine(), " ");
            from = edge[0] - 1;
            to = edge[1] - 1;
            value = edge[2];

            Set<ToEdge> nb = graph.getOrDefault(from, new HashSet<>());
            nb.add(new ToEdge(to, value));
            graph.put(from, nb);
        }

        sortedVertex = topSortGraph();

        int[] dist = new int[n];
        Arrays.fill(dist, Integer.MAX_VALUE);
        dist[s] = 0;

        Map<Integer, Integer> fromIndexToNumber = new HashMap<>();
        Map<Integer, Integer> fromNumberToIndex = new HashMap<>();
        for (int i = 0; i < n; ++i) {
            fromIndexToNumber.put(i, sortedVertex.get(i));
            fromNumberToIndex.put(sortedVertex.get(i), i);
        }

        for (int i = fromNumberToIndex.get(s); i < n; ++i) {
            int v = fromIndexToNumber.get(i);
            if (dist[v] == Integer.MAX_VALUE) {
                continue;
            }

            for (var edge : graph.getOrDefault(v, new HashSet<>())) {
                int u = edge.getTo();
                dist[u] = Math.min(dist[u], dist[v] + edge.getValue());
            }
        }
        
        if (dist[t] == Integer.MAX_VALUE) {
            System.out.println("Unreachable");
        } else {
            System.out.println(dist[t]);
        }
    }

    static int[] parseIntArray(String str, String separator) {
        return Arrays.stream(str.split(separator)).mapToInt(Integer::parseInt).toArray();
    }

    static List<Integer> topSortGraph() {
        used = new boolean[n];
        List<Integer> topSort = new ArrayList<>();

        for (int v = 0; v < n; ++v) {
            if (!used[v]) {
                dfs(v, topSort);
            }
        }

        Collections.reverse(topSort);
        return topSort;
    }

    static void dfs(int v, List<Integer> topSort) {
        used[v] = true;

        for (var edge : graph.getOrDefault(v, new HashSet<>())) {
            int u = edge.getTo();
            if (!used[u]) {
                dfs(u, topSort);
            }
        }

        topSort.add(v);
    }

    public static void main(String[] args) throws IOException {
        solve();
    }

    static class ToEdge {
        private final int to;
        private final int value;

        public ToEdge(int to, int value) {
            this.to = to;
            this.value = value;
        }

        public int getTo() {
            return to;
        }

        public int getValue() {
            return value;
        }
    }
}