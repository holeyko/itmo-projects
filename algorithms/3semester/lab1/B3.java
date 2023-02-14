import java.util.ArrayList;
import java.util.Scanner;

public class B3 {

    static ArrayList<Integer>[] g;

    static int used[], up[], d[], ArtPoints[];

    static int time;

    static void dfs(int v, int p)

    {

        used[v] = 1;

        d[v] = up[v] = time++;

        int children = 0;

        for (int i = 0; i < g[v].size(); i++)

        {

            int to = g[v].get(i);

            if (to == p)
                continue;

            if (used[to] == 1)

                up[v] = Math.min(up[v], d[to]);

            else

            {

                dfs(to, v);

                up[v] = Math.min(up[v], up[to]);

                if ((up[to] >= d[v]) && (p != -1))
                    ArtPoints[v] = 1;

                children++;

            }

        }

        if ((p == -1) && (children > 1))
            ArtPoints[v] = 1;

    }

    @SuppressWarnings("unchecked")

    public static void main(String[] args)

    {

        Scanner con = new Scanner(System.in);

        int n = con.nextInt();

        int m = con.nextInt();

        g = new ArrayList[n + m + 1]; // unchecked

        used = new int[n + m + 1];

        up = new int[n + m + 1];

        d = new int[n + m + 1];

        ArtPoints = new int[n + m + 1];

        for (int i = 0; i <= n + m; i++)

            g[i] = new ArrayList<Integer>();

        for (int i = 1; i <= m; i++)

        {

            int v1 = con.nextInt();

            int v2 = con.nextInt();

            int v3 = con.nextInt();

            g[n + i].add(v1);
            g[v1].add(n + i);

            g[n + i].add(v2);
            g[v2].add(n + i);

            g[n + i].add(v3);
            g[v3].add(n + i);

        }

        time = 1;

        for (int i = 1; i <= n + m; i++)

            if (used[i] == 0)
                dfs(i, -1);

        int cntArtPoints = 0;

        for (int i = n + 1; i <= n + m; i++)

            if (ArtPoints[i] == 1)
                cntArtPoints++;

        System.out.println(cntArtPoints);

        if (cntArtPoints > 0)

        {

            for (int i = n + 1; i <= n + m; i++)

                if (ArtPoints[i] == 1)
                    System.out.print(i - n + " ");

            System.out.println();

        }

        con.close();

    }
}
