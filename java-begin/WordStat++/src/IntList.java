import java.util.Arrays;

public class IntList {
    private int curPos = -1;
    private int maxPos;
    private int[] list;

    public IntList(int capacity) {
        if (capacity < 0) {
            throw new NegativeArraySizeException(Integer.toString(capacity));
        }
        if (capacity > 0) {
            curPos += 1;
        }
        this.list = new int[capacity];
        this.maxPos = capacity;
    }

    public IntList() {
        this(10);
    }

    private void increaseList() {
        list = Arrays.copyOf(list, maxPos * 2);
        maxPos = maxPos * 2 - 1;
    }

    public int length() {
        return Math.max(curPos, 0);
    }

    public int get(int index) {
        if (index > curPos || index < 0) {
            throw new ArrayIndexOutOfBoundsException();
        }
        return list[index];
    }

    public void add(int num) {
        if (curPos == maxPos - 1) {
            increaseList();
        }
        set(num, ++curPos);
    }

    public void set(int num, int index) {
        if (index > curPos || index < 0) {
            throw new ArrayIndexOutOfBoundsException();
        }
        list[index] = num;
    }

    public void increaseNum(int d, int index) {
        if (index > curPos || index < 0) {
            throw new ArrayIndexOutOfBoundsException();
        }
        list[index] += d;
    }

    @Override
    public String toString() {
        if (curPos == -1) {
            return "";
        }
        StringBuilder str = new StringBuilder();
        for (int i = 0; i < curPos; i++) {
            str.append(list[i]);
            str.append(" ");
        }
        str.append(list[curPos]);
        return str.toString();
    }
}
