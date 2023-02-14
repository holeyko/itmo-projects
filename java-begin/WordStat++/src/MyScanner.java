import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.Reader;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Arrays;
import java.util.InputMismatchException;
import java.io.UnsupportedEncodingException;
import java.io.FileInputStream;
import java.io.ByteArrayInputStream;

public class MyScanner {

    private final Reader in;
    private int countCache = 2;
    private final int BUFFER_SIZE = 1;
    private char[] buf = new char[BUFFER_SIZE];
    private boolean readEnd = false;
    private int curPos = 0;
    private int maxPos = 0;
    private int[] prevPos = new int[countCache];
    private int lenLinePattern = 0;
    private final char[] defaultLinePatterns = new char[]{'\r', '\n', '\u2028', '\u2029', '\u0085'};
    private final char[] systemLinePatterns = System.lineSeparator().toCharArray();
    private String linePattern = "";
    private String[] cache = new String[countCache];
    private int curNumLine = 1;
    private int[] cacheDeltLineArr = new int[]{0, 0};
    private boolean isSkip = false;

    public MyScanner(InputStream in, String encoding) throws UnsupportedEncodingException {
        this.in = new InputStreamReader(in, encoding);
    }

    public MyScanner(File in, String encoding) throws FileNotFoundException, UnsupportedEncodingException {
        this.in = new InputStreamReader(new FileInputStream(in), encoding);
    }

    public MyScanner(String in, String encoding) throws UnsupportedEncodingException {
        this.in = new InputStreamReader(new ByteArrayInputStream(Objects.requireNonNull(in).getBytes()), encoding);
    }

    public MyScanner(InputStream in) throws UnsupportedEncodingException {
        this(in, "utf-8");
    }

    public MyScanner(File in) throws FileNotFoundException, UnsupportedEncodingException {
        this(in, "utf-8");
    }

    public MyScanner(String in) throws UnsupportedEncodingException {
        this(in, "utf-8");
    }

    private void increaseBuf() {
        if (buf.length - curPos <= 0.2 * buf.length) {
            buf = Arrays.copyOf(buf, Math.max(buf.length * 2, BUFFER_SIZE));
        }
    }

    private void fill(int from) throws IOException {
        int read = in.read(buf, from, buf.length - from);
        if (read == -1) {
            readEnd = true;
        } else {
            maxPos += read;
        }
    }

    private void refreshBuf(int from) throws IOException {
        if (!readEnd) {
            increaseBuf();
            fill(Math.min(from, maxPos));
        }
    }

    private void clearBuf() {
        if (maxPos - curPos <= 0.2 * buf.length && maxPos > curPos) {
            buf = Arrays.copyOfRange(buf, curPos, maxPos);
            curPos = 0;
            maxPos = buf.length;
        }
    }

    private boolean isBufEnd() throws IOException {
        if (maxPos <= curPos) {
            refreshBuf(curPos);
        }
        return (maxPos <= curPos) && readEnd;
    }

    private void clearCache(int pos) {
        changeCurPos(pos);
        isSkip = false;
        for (int i = 0; i < countCache; i++) {
            cache[i] = "";
            prevPos[i] = 0;
        }
    }

    private void changeCurPos(int pos) {
        int tmp = curPos;
        curPos = prevPos[pos];
        prevPos[pos] = tmp;
    }

    private void clearCacheNumLine() {
        for (int i = 0; i < countCache; i++) {
            cacheDeltLineArr[i] = 0;
        }
    }

    public boolean hasNext() throws IOException {
        int indexFirstLetter = -1;
        if (!Objects.equals(cache[0], "") && cache[0] != null) {
            return true;
        }
        curNumLine += cacheDeltLineArr[0];
        clearCacheNumLine();
        prevPos[0] = curPos;
        while (true) {
            if (isBufEnd()) {
                if (indexFirstLetter != -1) {
                    cache[0] = String.valueOf(buf, indexFirstLetter, curPos - indexFirstLetter);
                    changeCurPos(0);
                    return true;
                }
                changeCurPos(0);
                return false;
            }
            for (; curPos < maxPos; curPos++) {
                char el = buf[curPos];
                if (Character.isWhitespace(el)) {
                    int d = 1;
                    if ((lenLinePattern != 0 && el == linePattern.charAt(0)) || isSymbolOfLinePattern(el)) {
                        if (lenLinePattern == 0) {
                            lenLinePattern = getLengthLinePattern();
                        }
                        if (el == linePattern.charAt(0)) {
                            if (indexFirstLetter == -1) {
                                isSkip = true;
                            } else {
                                cacheDeltLineArr[0]++;
                                d = lenLinePattern;
                            }
                        }
                    }
                    if (indexFirstLetter != -1) {
                        cache[0] = String.valueOf(buf, indexFirstLetter, curPos - indexFirstLetter);
                        curPos += d;
                        changeCurPos(0);
                        return true;
                    }
                } else {
                    if (indexFirstLetter == -1) {
                        indexFirstLetter = curPos;
                    }
                }
            }
        }
    }

    public String next() throws IOException {
        if (hasNext()) {
            if (isSkip) {
                curNumLine++;
            }
            String ret = cache[0];
            clearCache(0);
            clearBuf();
            return ret;
        }
        throw new InputMismatchException();
    }

    public boolean hasNextInt() throws IOException {
        if (!hasNext()) {
            return false;
        }
        try {
            Integer.parseInt(cache[0]);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public int nextInt() throws IOException {
        if (hasNextInt()) {
            int ret = Integer.parseInt(cache[0]);
            clearCache(0);
            clearBuf();
            return ret;
        }
        throw new InputMismatchException();
    }

    private int getLengthLinePattern() throws IOException {
        int curLenLinePat = 0;
        char firstCh = 0;
        StringBuilder curLinePattern = new StringBuilder();
        while (isSymbolOfLinePattern(buf[curPos])) {
            if (firstCh == 0) {
                firstCh = buf[curPos];
            } else if (buf[curPos] == firstCh) {
                break;
            }
            curLinePattern.append(buf[curPos]);
            curLenLinePat++;
            curPos++;
            if (curPos == buf.length) {
                increaseBuf();
            }
            if (curPos == maxPos) {
                if (!in.ready()) {
                    break;
                }
                buf[curPos] = (char) in.read();
                maxPos = curPos + 1;
            }
        }
        curPos -= curLenLinePat;
        linePattern = curLinePattern.toString();
        return curLenLinePat;
    }

    private boolean isSymbolOfLinePattern(char ch) {
        for (char el : defaultLinePatterns) {
            if (el == ch) {
                return true;
            }
        }
        for (char el : systemLinePatterns) {
            if (el == ch) {
                return true;
            }
        }
        return false;
    }


    public String nextLine() throws IOException {
        curNumLine += cacheDeltLineArr[1];
        clearCacheNumLine();
        if (hasNextLine()) {
            String ret = cache[1];
            clearCache(1);
            clearBuf();
            return ret;
        }
        throw new NoSuchElementException("No line found");
    }

    public boolean hasNextLine() throws IOException {
        if (!Objects.equals(cache[1], "") && cache[1] != null) {
            return true;
        }
        curNumLine += cacheDeltLineArr[1];
        clearCacheNumLine();
        prevPos[1] = curPos;
        while (true) {
            if (isBufEnd()) {
                if (prevPos[1] < curPos) {
                    cache[1] = String.valueOf(buf, prevPos[1], curPos - prevPos[1]);
                    changeCurPos(1);
                    return true;
                }
                changeCurPos(1);
                return false;
            }
            for (; curPos < maxPos; curPos++) {
                if (lenLinePattern == 0) {
                    lenLinePattern = getLengthLinePattern();
                }
                if (lenLinePattern != 0 && buf[curPos] == linePattern.charAt(0)) {
                    cache[1] = String.valueOf(buf, prevPos[1], curPos - prevPos[1]);
                    curPos += lenLinePattern;
                    cacheDeltLineArr[1]++;
                    changeCurPos(1);
                    return true;
                }
            }
        }
    }

    public int getCurNumLine() {
        return curNumLine;
    }

    public void close() throws IOException {
        in.close();
    }
}
