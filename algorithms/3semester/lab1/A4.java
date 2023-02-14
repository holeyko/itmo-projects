import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.IntStream;

public class A4 {
    static int n;
    static Set<Point> pointsSet = new HashSet<>();
    static List<Point> points;
    static int[] setsSize;
    static int[] sets;
    static List<Edge> edges = new ArrayList<>();

    public static void main(String[] args) throws IOException {
        solve();
    }

    static void solve() throws IOException {
        BufferedReader input = new BufferedReader(
                new InputStreamReader(System.in));

        n = Integer.parseInt(input.readLine());

        for (int i = 0; i < n; ++i) {
            int[] params = Arrays.stream(input.readLine().split(" ")).mapToInt(Integer::parseInt).toArray();
            Point point = new Point(params[0], params[1]);
            pointsSet.add(point);
        }
        
        points = new ArrayList<>(pointsSet);
        sets = IntStream.range(0, points.size()).toArray();
        setsSize = new int[points.size()];
        Arrays.fill(setsSize, 1);
        
        for (int i = 0; i < points.size(); ++i) {
            points.get(i).setNumber(i);
            for (int j = 0; j < i; ++j) {
                edges.add(new Edge(points.get(i), points.get(j)));
            }
        }
        edges.sort((a, b) -> Double.compare(a.getDistance(), b.getDistance()));
        
        double result = 0.0;
        for (Edge edge : edges) {
            Point first = edge.getFirst();
            Point second = edge.getSecond();
            int firstSet = sets[first.getNumber()];
            int secondSet = sets[second.getNumber()];
            
            if (firstSet != secondSet) {
                if (setsSize[firstSet] < setsSize[secondSet]) {
                    Point tmp = first;
                    first = second;
                    second = tmp;
                }
                
                sets[secondSet] = sets[firstSet];
                setsSize[firstSet] += setsSize[secondSet];
                
                result += edge.getDistance();
            }
        }
        
        System.out.println(result);
    }

    static double findDistance(Point from, Point to) {
        if (from == to) {
            return Double.MAX_VALUE;
        }

        return Math.sqrt(
                Math.pow(from.getX() - to.getX(), 2) +
                        Math.pow(from.getY() - to.getY(), 2));
    }

    static class Point {
        private final int x;
        private final int y;
        private int number;

        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public int getX() {
            return x;
        }

        public int getY() {
            return y;
        }

        public int getNumber() {
            return number;
        }

        public void setNumber(int number) {
            this.number = number;
        }
    }

    static class Edge {
        private final Point first;
        private final Point second;
        private final double distance;

        public Edge(A4.Point first, A4.Point second) {
            this.first = first;
            this.second = second;
            this.distance = findDistance(first, second);
        }

        public Point getFirst() {
            return first;
        }

        public Point getSecond() {
            return second;
        }

        public double getDistance() {
            return distance;
        }
    }
}
