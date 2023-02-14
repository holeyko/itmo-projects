import java.io.*;
import java.util.*;
import java.util.stream.IntStream;

public class B {
    static final String inFile = "destroy.in";
    static final String outFile = "destroy.out";

    static Edge[] edges;
    static int[] parent;
    static int[] size;

    static int findParent(int value) {
        if (parent[value] == value) {
            return value;
        }

        parent[value] = findParent(parent[value]);
        return parent[value];
    }

    static void solve() {
        try (
                BufferedReader in = new BufferedReader(new FileReader(inFile));
                BufferedWriter out = new BufferedWriter(new FileWriter(outFile))
        ) {
            String[] params = in.readLine().split(" ");
            int n = Integer.parseInt(params[0]);
            int m = Integer.parseInt(params[1]);
            long s = Long.parseLong(params[2]);

            parent = IntStream.range(0, n + 1).toArray();
            size = new int[n + 1];
            Arrays.fill(size, 1);
            edges = new Edge[m];
            for (int i = 0; i < m; ++i) {
                String[] edgeParams = in.readLine().split(" ");
                int from = Integer.parseInt(edgeParams[0]) - 1;
                int to = Integer.parseInt(edgeParams[1]) - 1;
                long value = Long.parseLong(edgeParams[2]);

                edges[i] = new Edge(
                        i + 1,
                        value,
                        new Node(from + 1),
                        new Node(to + 1)
                );
            }

            Arrays.sort(edges, (a, b) -> Long.compare(b.value, a.value));
            List<Edge> unused = new ArrayList<>();
            for (int i = 0; i < m; ++i) {
                Edge edge = edges[i];
                int firstParent = findParent(parent[edge.first.getNumber()]);
                int secondParent = findParent(parent[edge.second.getNumber()]);

                if (firstParent != secondParent) {
                    if (size[firstParent] < size[secondParent]) {
                        int tmp = firstParent;
                        firstParent = secondParent;
                        secondParent = tmp;
                    }
                    parent[secondParent] = firstParent;
                    size[firstParent] += size[secondParent];
                } else {
                    unused.add(edge);
                }
            }

            long sum = 0;
            int count = 0;
            List<Edge> deletedEdges = new ArrayList<>();
            for (int i = unused.size() - 1; i >= 0; --i) {
                if (sum + unused.get(i).getValue() <= s) {
                    sum += unused.get(i).getValue();
                    ++count;
                    deletedEdges.add(unused.get(i));
                } else {
                    break;
                }
            }

            deletedEdges.sort((a, b) -> Integer.compare(a.number, b.number));
            StringBuilder ans = new StringBuilder();
            ans.append(count).append('\n');
            for (Edge edge : deletedEdges) {
                ans.append(edge.getNumber()).append(" ");
            }

            out.write(ans.toString());
        } catch (IOException ignored) {
            // NO
        }
    }

    static class Edge {
        private final int number;
        private final long value;
        private Node first;
        private Node second;

        public Edge(int number, long value, Node first, Node second) {
            this.number = number;
            this.value = value;
            this.first = first;
            this.second = second;
        }

        public int getNumber() {
            return number;
        }

        public long getValue() {
            return value;
        }

        public Node getFirst() {
            return first;
        }

        public Node getSecond() {
            return second;
        }
    }

    static class Node {
        private final int number;

        public Node(int number) {
            this.number = number;
        }

        public int getNumber() {
            return number;
        }
    }

    public static void main(String[] args) {
        solve();
    }
}