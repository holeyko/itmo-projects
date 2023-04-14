package info.kgeorgiy.ja.riabov.walk;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Walk {
    public static void main(String[] args) throws IOException {
        AbstractWalker walker = new Walker();
        walker.start(args);
    }
}
