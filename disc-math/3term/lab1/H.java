import java.util.*;

class Graph {
    private List<Set<Integer>> vertexes;
    private int size;
    private int countEdges;

    public Graph(List<Set<Integer>> vertexes) {
        this.vertexes = vertexes;
        this.size = vertexes.size();

        for (Set<Integer> edges : vertexes) {
            countEdges += edges.size();
        }
    }

    public Graph join(int u, int v) {
        int min = Math.min(u, v);
        int max = Math.max(u, v);

        List<Set<Integer>> newVertexes = new ArrayList<>();

        for (int i = 0; i < size; ++i) {
            if (i == min) {
                HashSet<Integer> filtred = new HashSet<>();
                for (int el : vertexes.get(min)) {
                    if (el != max) {
                        filtred.add(el);
                    }
                }
                newVertexes.add(filtred);
            } else if (i == max) {
                HashSet<Integer> filtred = new HashSet<>();
                for (int el : vertexes.get(max)) {
                    if (el != min) {
                        filtred.add(el);
                    }
                }
                newVertexes.get(min).addAll(filtred);
            } else {
                HashSet<Integer> filtred = new HashSet<>();
                for (int el : vertexes.get(i)) {
                    if (el == max) {
                        filtred.add(min);
                    } else {
                        filtred.add(el);
                    }
                }
                newVertexes.add(filtred);
            }
        }

        return new Graph(newVertexes);
    }

    public Graph split(int u, int v) {
        List<Set<Integer>> newVertexes = new ArrayList<>();
        for (int i = 0; i < size; ++i) {
            if (i == u || i == v) {
                HashSet<Integer> filtred = new HashSet<>();
                for (int el : vertexes.get(i)) {
                    if (el != u && el != v) {
                        filtred.add(el);
                    }
                }
                newVertexes.add(filtred);
            } else {
                newVertexes.add(vertexes.get(i));
            }
        }

        return new Graph(newVertexes);
    }

    public List<Set<Integer>> getVertexes() {
        return vertexes;
    }

    public int getSize() {
        return size;
    }

    public int getCountEdges() {
        return countEdges;
    }
}

class Polinom {
    private List<Monom> items;
    private int size;

    public Polinom(List<Monom> items) {
        this.items = items;
        this.size = items.size();
    }

    public Polinom(Monom monom) {
        List<Monom> res = new ArrayList<>();
        for (int i = 0; i < monom.getDegree(); ++i) {
            res.add(new Monom(i, 0));
        }
        res.add(monom);

        this.items = res;
        this.size = res.size();
    }

    public Polinom() {
        this(new ArrayList<>());
    }

    public Polinom add(Monom monom) {
        return add(new Polinom(monom));
    }

    public Polinom add(Polinom other) {
        int newSize = Math.max(size, other.getSize());
        List<Monom> newItems = new ArrayList<>();

        for (int i = 0; i < newSize; ++i) {
            newItems.add(new Monom(i, 0));
        }

        for (int i = 0; i < newSize; ++i) {
            if (i < size) {
                newItems.set(i, newItems.get(i).add(items.get(i)));
            }
            if (i < other.getSize()) {
                newItems.set(i, newItems.get(i).add(other.getItems().get(i)));
            }
        }

        return new Polinom(newItems);
    }

    public void multiplyOnConst(int c) {
        for (Monom monom : items) {
            monom.setC(monom.getC() * c);
        }
    }

    public int eval(int value) {
        int res = 0;

        for (Monom monom : items) {
            res += monom.eval(value);
        }

        return res;
    }

    public List<Monom> getItems() {
        return items;
    }

    public void setItems(List<Monom> items) {
        this.items = items;
    }

    public int getSize() {
        return size;
    }

    @Override
    public String toString() {
        StringBuilder res = new StringBuilder();
        for (int i = items.size() - 1; i >= 0; --i) {
            res.append(items.get(i).toString());
        }

        return res.toString();
    }
}

class Monom {
    private int degree;
    private int c;

    public Monom(int degree) {
        this(degree, 1);
    }

    public Monom(int degree, int c) {
        this.degree = degree;
        this.c = c;
    }

    public Monom add(Monom other) {
        if (degree != other.getDegree()) {
            return null;
        }

        return new Monom(degree, c + other.c);
    }

    public int eval(int value) {
        return c * ((int) Math.pow(value, degree));
    }
    
    public int getDegree() {
        return degree;
    }

    public void setDegree(int degree) {
        this.degree = degree;
    }

    public int getC() {
        return c;
    }

    public void setC(int c) {
        this.c = c;
    }

    @Override
    public String toString() {
        String constStr = c >= 0 ? "+" + c : Integer.toString(c);
        return constStr + "*t^" + degree;
    }
}

public class H {
    public static void main(String[] args) {
        new H().solve();
    }

    void solve() {
        Scanner in = new Scanner(System.in);

        int n = in.nextInt();
        int m = in.nextInt();

        List<Set<Integer>> vertexes = new ArrayList<>();
        for (int i = 0; i < n; ++i) {
            vertexes.add(new HashSet<>());
        }

        for (int i = 0; i < m; ++i) {
            int from = in.nextInt() - 1;
            int to = in.nextInt() - 1;

            vertexes.get(from).add(to);
            vertexes.get(to).add(from);
        }

        in.close();

        Graph graph = new Graph(vertexes);
        Polinom res = recur(graph);

        System.out.println(res.getItems().size() - 1);

        List<Monom> resPolinom = res.getItems();
        for (int i = resPolinom.size() - 1; i >= 0; --i) {
            System.out.print(resPolinom.get(i).getC());
            System.out.print(" ");
        }
    }

    Polinom recur(Graph graph) {
        if (graph.getCountEdges() == 0) {
            return new Polinom(new Monom(graph.getSize()));
        } else {
            int u = 0, v = 0;
            for (int i = graph.getSize() - 1; i >= 0; --i) {
                if (!graph.getVertexes().get(i).isEmpty()) {
                    u = i;
                    v = (int) graph.getVertexes().get(i).toArray()[graph.getVertexes().get(i).size() - 1];

                    break;
                }
            }

            Polinom resSplittedGraph = recur(graph.split(u, v));
            Polinom resJoinedGraph = recur(graph.join(u, v));
            resJoinedGraph.multiplyOnConst(-1);

            return resSplittedGraph.add(resJoinedGraph);
        }
    }
}
