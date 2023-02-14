package elf;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FileSourse implements ByteSourse{
    private byte[] data;
    private int curPos = 0;
    private final int BYTE_SYZE = 8;


    public FileSourse(String inFileName) throws IOException {
        this.data = Files.readAllBytes(Paths.get(inFileName));
    }

    public int read() throws IOException {
        return data[curPos++] & 0xFF;
    }

    public int read(int n) throws IOException{
        int res = 0;
        for (int i = 0; i < n; i++) {
            res += read() << i * BYTE_SYZE;
        }

        return res;
    }

    public void setCursor(int pos) {
        curPos = pos;
    }

    public int getCurPos() {
        return curPos;
    }
}
