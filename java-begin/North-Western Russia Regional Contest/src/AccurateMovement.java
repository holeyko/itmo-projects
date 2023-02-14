import java.util.Scanner;

public class AccurateMovement {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int a = scan.nextInt();
        int b = scan.nextInt();
        int n = scan.nextInt();
        scan.close();
        int countMoves = 2 * (int) Math.ceil((double) (n - b) / (double) (b - a)) + 1;
        System.out.println(countMoves);
    }
}