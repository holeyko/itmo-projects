import java.util.Scanner;

public class IdealPyramid {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int n = Integer.parseInt(scan.nextLine());
        int xL = Integer.MAX_VALUE;
        int xR = (int) -Math.pow(10, 9);
        int yL = Integer.MAX_VALUE;
        int yR = (int) -Math.pow(10, 9);
        for (int i = 0; i < n; i++) {
            Scanner line = new Scanner(scan.nextLine());
            int xI = line.nextInt();
            int yI = line.nextInt();
            int hI = line.nextInt();
            xL = Math.min(xL, xI - hI);
            xR = Math.max(xR, xI + hI);
            yL = Math.min(yL, yI - hI);
            yR = Math.max(yR, yI + hI);
        }
        scan.close();
        int h = (int) Math.ceil((double) Math.max(xR - xL, yR - yL) / 2.0);
        int x = (xL + xR) / 2;
        int y = (yL + yR) / 2;
        System.out.println(x + " " + y + " " + h);
    }
}
