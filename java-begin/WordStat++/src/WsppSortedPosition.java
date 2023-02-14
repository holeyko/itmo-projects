import java.io.*;
import java.util.*;

public class WsppSortedPosition {
    static List<String> getWords(String s) {
        List<String> words = new ArrayList<>();
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
            Map<String, IntList> sortWordsStat = new TreeMap<>();
            File in = new File(args[0]);
            MyScanner scan = new MyScanner(in, "utf-8");
            int curLinePos = 1;
            int curLine = 1;
            while (scan.hasNext()) {
                String s = scan.next().toLowerCase();
                List<String> words = getWords(s);
                if (curLine < scan.getCurNumLine()) {
                    curLinePos = 1;
                    curLine = scan.getCurNumLine();
                }
                for (String word : words) {
                    if (!Objects.equals(word, "")) {
                        IntList stat = sortWordsStat.getOrDefault(word, new IntList());
                        stat.add(curLine);
                        stat.add(curLinePos);
                        stat.increaseNum(1, 0);
                        sortWordsStat.put(word, stat);
                        curLinePos++;
                    }
                }
            }
            scan.close();
            try {
                BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(args[1]), "utf-8"));
                try {
                    for (Map.Entry<String, IntList> pair : sortWordsStat.entrySet()) {
                        out.write(pair.getKey() + " ");
                        String[] params = pair.getValue().toString().split(" ");
                        for (int i = 0; i < params.length; i++) {
                            out.write(params[i]);
                            if (i >= 1 && i % 2 != 0) {
                                out.write(":");
                            } else {
                                if (i != params.length - 1) {
                                    out.write(" ");
                                }
                            }
                        }
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