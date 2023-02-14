import java.util.*;

public class A1 {
    static int m, n;
    static int[][] graph;
    static boolean[][] used;

    static void dfs(int i, int j) {
        used[i][j] = true;
        
        List<Integer> validI = new ArrayList<>();
        List<Integer> validJ = new ArrayList<>();
        if (i == 0 ) {
            validI.add(i + 1);
        } else if (i == m - 1) {
            validI.add(i - 1);
        } else {
            validI.add(i - 1);
            validI.add(i + 1);
        }

        if (j == 0 ) {
            validJ.add(j + 1);
        } else if (j == n - 1) {
            validJ.add(j - 1);
        } else {
            validJ.add(j - 1);
            validJ.add(j + 1);
        }

        for (int newI : validI) {
            if (graph[newI][j] == 1 && !used[newI][j]) {
                dfs(newI, j);
            }
        }

        for (int newJ : validJ) {
            if (graph[i][newJ] == 1 && !used[i][newJ]) {
                dfs(i, newJ);
            }
        }
    }

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        m = in.nextInt();
        n = in.nextInt();
        in.nextLine();
        graph = new int[m][n];
        used = new boolean[m][n];
        
        for (int i = 0; i < m; ++i) {
            String line = in.nextLine();
            for (int j = 0; j < n; ++j) {
                graph[i][j] = line.charAt(j) == 'O' ? 1 : 0; 
            }
        }

        int count = 0;
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (graph[i][j] == 1 && !used[i][j]) {
                    dfs(i, j);
                    ++count;
                }
            }
        }

        System.out.println(count);
    }
}
