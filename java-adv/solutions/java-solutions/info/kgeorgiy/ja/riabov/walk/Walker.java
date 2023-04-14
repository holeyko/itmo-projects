package info.kgeorgiy.ja.riabov.walk;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Walker extends AbstractWalker {
    public Walker() { super(); }

    @Override
    protected void walkImpl(String filePath, Writer writer) throws IOException {
        try {
            Path file = Path.of(filePath);
            writeFileSHA256(writer, bytesToHex(calculateSHA256(file)), filePath);
        } catch (IOException | InvalidPathException e) {
            writeFaultSHA256(writer, filePath);
        }
    }
}
