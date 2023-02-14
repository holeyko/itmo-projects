import java.util.*;

public class ManagingDifficulties {
    static int[] makeArrayFromString(String s) {
        int[] retVal = new int[10];
        int startNum = -1;
        int curPos = 0;
        for (int i = 0; i < s.length(); i++) {
            char el = s.charAt(i);
            if (Character.isDigit(el)) {
                if (startNum == -1) {
                    startNum = i;
                }
            } else if (startNum != -1) {
                retVal[curPos++] = Integer.parseInt(s.substring(startNum, i));
                startNum = -1;
            }
            if (curPos == retVal.length) {
                retVal = Arrays.copyOf(retVal, curPos * 2);
            }
        }
        if (startNum != -1) {
            retVal[curPos++] = Integer.parseInt(s.substring(startNum, s.length()));
        }
        return Arrays.copyOfRange(retVal, 0, curPos);
    }

    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);
        int numCases = Integer.parseInt(scan.nextLine());
        for (int curCase = 0; curCase < numCases; curCase++) {
            int ans = 0;
            Map<Integer, Integer> C = new LinkedHashMap<>();
            int n = Integer.parseInt(scan.nextLine());
            int[] a = makeArrayFromString(scan.nextLine());
            for (int j = n - 1; j >= 1; j--) {
                for (int i = 0; i <= j - 1; i++) {
                    int eli = a[i];
                    int elj = a[j];
                    int u = 2 * elj - eli;
                    ans += C.getOrDefault(u, 0);
                }
                int val = C.getOrDefault(a[j], 0);
                C.put(a[j], val + 1);
            }
            System.out.println(ans);
        }
    }
}
