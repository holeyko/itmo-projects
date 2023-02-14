import java.awt.*;
import java.util.*;
import java.io.*;
import java.util.List;

class Node {
    private final int num;
    private Node left = null;
    private Node right = null;

    public Node(int num) {
        this.num = num;
    }

    public boolean isRight() {
        return right == null;
    }

    public int getNum() {
        return num;
    }

    public Node getLeft() {
        return left;
    }

    public void setLeft(Node left) {
        this.left = left;
    }

    public Node getRight() {
        return right;
    }

    public void setRight(Node right) {
        this.right = right;
    }
}


public class D {
    public static void main(String[] args) {
        new D().solve();
//        while (true) {
//            String graph = FullGraphGenerator.generateFullGraphInputData(1, 7);
//            System.out.println("Graph:");
//            System.out.println(graph);
//            System.out.println("Answer:");
//            new B().solve(new ByteArrayInputStream(graph.getBytes()));
//            System.out.println();
//        }
    }

    void solve() {
        Scanner in = new Scanner(System.in);

        int n = in.nextInt();
        if (n == 1){
            System.out.println(1);
            in.close();
            return;
        }

        in.nextLine();

        List<Set<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; ++i) {
            graph.add(new HashSet<>());
        }

        Node[] vertexes = new Node[n];
        for (int i = 0; i < n; ++i) {
            vertexes[i] = new Node(i);

            String line = in.nextLine();
            for (int j = 0; j < line.length(); ++j) {
                if (line.charAt(j) == '0') {
                    graph.get(j).add(i);
                } else {
                    graph.get(i).add(j);
                }
            }
        }

        in.close();

        Node begin = vertexes[0];
        for (int i = 1; i < n; ++i) {
            Node insertNode = vertexes[i];

            if (!exists_edge(graph, begin.getNum(), i)) {
                begin.setLeft(insertNode);
                insertNode.setRight(begin);
                begin = insertNode;
            } else {
                Node lastNiceNode = begin;

                while (exists_edge(graph, lastNiceNode.getNum(), i)) {
                    if (lastNiceNode.isRight()) {
                        break;
                    } else {
                        if (!exists_edge(graph, lastNiceNode.getRight().getNum(), i)) {
                            break;
                        } else {
                            lastNiceNode = lastNiceNode.getRight();
                        }
                    }
                }

                Node rightLnn = lastNiceNode.getRight();
                lastNiceNode.setRight(insertNode);
                insertNode.setLeft(lastNiceNode);
                insertNode.setRight(rightLnn);

                if (rightLnn != null) {
                    rightLnn.setLeft(insertNode);
                }
            }
        }

        Node circle = begin;
        {
            Node curNode = begin;

            while (curNode != null) {
                if (exists_edge(graph, curNode.getNum(), begin.getNum())) {
                    circle = curNode;
                }

                curNode = curNode.getRight();
            }
        }

        Node rightPath = circle.getRight();
        circle.setRight(begin);

        if (rightPath != null) {
            rightPath.setLeft(null);
        }

        while (rightPath != null) {
            Node left = rightPath;
            Node right = rightPath;
            boolean exists = false;

            while (!exists) {
                Node curNode = begin;
                boolean isFirst = true;
                exists = true;

                while (true) {
                    if (!exists_edge(graph, right.getNum(), curNode.getNum()))  {
                        if (curNode == begin) {
                            if (isFirst) {
                                isFirst = false;
                            } else {
                                exists = false;
                                break;
                            }
                        }

                        curNode = curNode.getRight();
                    } else if (curNode == begin) {
                        if (exists_edge(graph, begin.getLeft().getNum(), right.getNum())) {
                            break;
                        } else {
                            curNode = curNode.getRight();
                        }
                    } else {
                        break;
                    }
                }

                if (!exists) {
                    right = right.getRight();
                } else {
                    Node leftCurNode = curNode.getLeft();
                    rightPath = right.getRight();

                    curNode.setLeft(right);
                    right.setRight(curNode);

                    if (leftCurNode != null) {
                        leftCurNode.setRight(left);
                        left.setLeft(leftCurNode);
                    }

                    if (rightPath != null) {
                        rightPath.setLeft(null);
                    }
                }
            }
        }

        StringBuilder res = new StringBuilder();
        res.append(begin.getNum() + 1).append(" ");

        Node curNode = begin.getRight();
        while (curNode != null && curNode != begin) {
            res.append(curNode.getNum() + 1).append(" ");
            curNode = curNode.getRight();
        }

        System.out.println(res);
    }

    boolean exists_edge(List<Set<Integer>> graph, int from, int to) {
        for (int num : graph.get(from)) {
            if (num == to) {
                return true;
            }
        }

        return false;
    }

//    private class FullGraphGenerator {
//        public static String generateFullGraphInputData(int from, int to) {
//            while (true) {
//                int n = generateRandomInt(from, to);
//                List<Set<Integer>> graph = new ArrayList<>();
//                for (int i = 0; i < n; ++i) {
//                    graph.add(new HashSet<>());
//                }
//
//                for (int i = 0; i < n; ++i) {
//                    for (int j = i + 1; j < n; ++j) {
//                        if (Math.random() < 0.5) {
//                            graph.get(i).add(j);
//                        } else {
//                            graph.get(j).add(i);
//                        }
//                    }
//                }
//
//                boolean flag = false;
//                for (int i = 0; i < n; ++i) {
//                    if (dfsCount(graph, i) != n) {
//                        flag = true;
//                        break;
//                    }
//                }
//
//                if (flag) {
//                    continue;
//                }
//
//                StringBuilder res = new StringBuilder();
//                res.append(n);
//                for (int i = 0; i < n; ++i) {
//                    res.append("\n");
//
//                    for (int j = 0; j < i; ++j) {
//                        if (graph.get(i).contains(j)) {
//                            res.append('1');
//                        } else {
//                            res.append('0');
//                        }
//                    }
//                }
//
//                return res.toString();
//            }
//        }
//
//        private static int generateRandomInt(int from, int to) {
//            return (int) (Math.random() * to + from);
//        }
//
//        private static int dfsCount(List<Set<Integer>> graph, int v) {
//            List<Boolean> used = new ArrayList<>();
//            for (int i = 0; i < graph.size(); ++i) {
//                used.add(false);
//            }
//            int countUsed = 0;
//
//            dfs(graph, v, used);
//
//            for (boolean u : used) {
//                if (u) {
//                    ++countUsed;
//                }
//            }
//
//            return countUsed;
//        }
//
//        private static void dfs(List<Set<Integer>> graph, int v, List<Boolean> used) {
//            used.set(v, true);
//            for (int u : graph.get(v)) {
//                if (!used.get(u)) {
//                    dfs(graph, u, used);
//                }
//            }
//        }
//    }
}
