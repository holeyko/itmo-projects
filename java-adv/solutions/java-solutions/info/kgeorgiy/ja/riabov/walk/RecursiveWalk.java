package info.kgeorgiy.ja.riabov.walk;

import java.io.*;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

public class RecursiveWalk {
    public static void main(String[] args) {
        AbstractWalker walker = new RecursiveWalker();
        walker.start(args);
    }
}
