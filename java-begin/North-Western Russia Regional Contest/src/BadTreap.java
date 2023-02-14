import java.util.Scanner;

public class BadTreap {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int n = scan.nextInt();
        int suitableNum = 710;
        int curNum = -suitableNum * 25000;
        for (int i = 0; i < n; i++) {
            System.out.println(curNum);
            curNum += suitableNum;
        }
        scan.close();
    }
}
