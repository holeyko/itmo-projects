import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class A2 {
    static int n;
    static int m;
    static Map<Integer, Set<Integer>> graph = new HashMap<>();
    static Map<Integer, Set<Integer>> reversedGraph = new HashMap<>();

    static boolean[] used;
    static int[] components;
    static int numberComponents = 0;
    
    static List<Integer> vertexOrder = new ArrayList<>();

    static void solve() throws IOException {
        var input = new BufferedReader(new InputStreamReader(System.in));

        n = Integer.parseInt(input.readLine());
        m = Integer.parseInt(input.readLine());
        for (int i = 0; i < n; ++i) {
            graph.put(i, new HashSet<>());
            reversedGraph.put(i, new HashSet<>());
        }
        used = new boolean[n];
        components = new int[n];
        Arrays.fill(components, -1);

        input.lines()
                .limit(m)
                .map(line -> line.split(" "))
                .forEach(splitedLine -> {
                    var from = Integer.parseInt(splitedLine[0]) - 1;
                    var to = Integer.parseInt(splitedLine[1]) - 1;

                    graph.get(from).add(to);
                    reversedGraph.get(to).add(from);
                });
        
        for (int v = 0; v < n; ++v) {
            if (!used[v]) {
                findOrderDfs(v);
            }
        }
        Collections.reverse(vertexOrder);
    
        List<Integer> componentsExamples = new ArrayList<>();
        for (var v : vertexOrder) {
            if (components[v] == -1) {
                findComponentDfs(v);
                componentsExamples.add(v);
                ++numberComponents;
            }
        }
        
        boolean[] necessary = new boolean[numberComponents];
        Arrays.fill(necessary, true);
        for (int v = 0; v < n; ++v) {
            for (var u : graph.get(v)) {
                int fromComponent = components[v];
                int toComponent = components[u];
                
                if (fromComponent != toComponent) {
                    necessary[fromComponent] = false;
                }
            }
        }
        
        List<Integer> result = new ArrayList<>();
        for (int i = 0; i < numberComponents; ++i) {
            if (necessary[i]) {
                result.add(componentsExamples.get(i) + 1);
            }
        }
        
        StringBuilder sb = new StringBuilder();
        sb.append(result.size()).append("\n");
        result.forEach(e -> sb.append(e).append(" "));
        
        System.out.println(sb);
    }
    
    static void findOrderDfs(int v) {
        used[v] = true;

        for (var u : reversedGraph.get(v)) {
            if (!used[u]) {
                findOrderDfs(u);
            }
        }
        
        vertexOrder.add(v);
    }
    
    static void findComponentDfs(int v) {
        components[v] = numberComponents;
        
        for (var u : graph.get(v)) {
            if (components[u] == -1) {
                findComponentDfs(u);
            }
        }
    }

    public static void main(String[] args) throws IOException {
        solve();
    }
}