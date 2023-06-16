package info.kgeorgiy.ja.riabov.bank.util;

public class StringUtils {
    public static long countOccurrencesChar(String s, char ch) {
        return s.chars().filter(sCh -> sCh == ch).count();
    }
}
