import java.io.*;
import java.util.*;

public class Wspp {
    static ArrayList<String> getWords(String s) {
        ArrayList<String> words = new ArrayList<>();
        StringBuilder word = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            if (Character.isLetter(ch) || ch == '\'' || Character.DASH_PUNCTUATION == Character.getType(ch)) {
                word.append(ch);
            } else {
                words.add(word.toString());
                word = new StringBuilder();
            }
        }
        words.add(word.toString());
        return words;
    }

    public static void main(String[] args) {
        try {
            Map<String, IntList> wordsStat = new LinkedHashMap<>();
            File in = new File(args[0]);
            MyScanner scan = new MyScanner(in, "utf-8");
            int curPos = 1;
            while (scan.hasNext()) {
                String s = scan.next().toLowerCase();
                List<String> words = getWords(s);
                for (String word : words) {
                    if (word != "") {
                        IntList stat = wordsStat.getOrDefault(word, new IntList());
                        stat.increaseNum(1, 0);
                        stat.add(curPos);
                        wordsStat.put(word, stat);
                        curPos++;
                    }
                }
            }
            scan.close();
            try {
                BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(args[1]), "utf-8"));
                try {
                    for (Map.Entry<String, IntList> pair : wordsStat.entrySet()) {
                        out.write(pair.getKey() + " " + pair.getValue().toString());
                        out.newLine();
                    }
                } finally {
                    out.close();
                }
            } catch (FileNotFoundException e) {
                System.err.println("File not found " + e.getMessage());
            } catch (IOException e) {
                System.err.println("Something went wrong " + e.getMessage());
            }
        } catch (FileNotFoundException e) {
            System.err.println("File not found " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Something went wrong " + e.getMessage());
        }
    }
}