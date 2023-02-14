import java.io.File;
import java.io.IOException;

public class Test {
    public static void main(String[] args) {
        try {
            MyScanner scan = new MyScanner(new File("./src/in.txt"));
            while (scan.hasNext()) {
                System.out.println(scan.next());
                System.out.println(scan.nextLine());
                System.out.println(scan.getCurNumLine());
            }
        } catch (IOException e) {
            System.out.println("Something went wrong " + e.getMessage());
        }
    }
}
