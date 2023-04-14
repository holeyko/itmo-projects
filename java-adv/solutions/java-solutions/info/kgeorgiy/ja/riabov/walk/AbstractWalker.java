package info.kgeorgiy.ja.riabov.walk;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

public abstract class AbstractWalker {
    private final MessageDigest messageDigest;

    private final static int BUFFER_SIZE = 4096;
    private final static String ENCRYPTION_ALGORITHM = "SHA-256";
    private final static String LINE_SEPARATOR = System.lineSeparator();
    private final static String FAULT_SHA = "0".repeat(64);


    public AbstractWalker() {
        try {
            messageDigest = MessageDigest.getInstance(ENCRYPTION_ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalArgumentException("Unknown encryption algorithm [algorithm=%s]".formatted(ENCRYPTION_ALGORITHM));
        }
    }

    public void start(String[] args) {
        try {
            validApplicationArguments(args);
            createOutputFile(args[1]);
            walk(args);
        } catch (IOException | IllegalArgumentException e) { //:NOTE: catch Exception
            System.err.println("Can't write sha files [args=%s]. %s".formatted(Arrays.toString(args), e.getMessage()));
        }
    }

    private void validApplicationArguments(String[] args) {
        if (args == null) {
            throw new IllegalArgumentException("args is null");
        }

        if (args.length != 2) {
            throw new IllegalArgumentException("Number of arguments must be 2 [args.length=%d]".formatted(args.length));
        }

        if (args[0] == null) {
            throw new IllegalArgumentException("First argument is null");
        }
        if (args[1] == null) {
            throw new IllegalArgumentException("Second argument is null");
        }

        try {
            final Path inputFile = Path.of(args[0]);
            if (!Files.exists(inputFile)) {
                throw new IllegalArgumentException("Input file does not exist [pathFile=%s]".formatted(args[0]));
            }
            if (!Files.isReadable(inputFile)) {
                throw new IllegalArgumentException("Can't read from input file [pathFile=%s]".formatted(args[0]));
            }
        } catch (SecurityException e) {
            throw new IllegalArgumentException("Have not privilege to check input file [pathFile=%s]".formatted(args[0]));
        } catch (InvalidPathException e) {
            throw new IllegalArgumentException("Invalid path of file [pathFile=%s]".formatted(args[0]));
        }
    }

    private void createOutputFile(String filePath) throws IOException {
        Path file = Path.of(filePath);
        Path parent = file.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        Files.createFile(file);
    }

    public void walk(String[] files) throws IOException {
        try (BufferedWriter outputFile = new BufferedWriter(new FileWriter(files[1], StandardCharsets.UTF_8))) {
            try (BufferedReader inputFile = new BufferedReader(new FileReader(files[0], StandardCharsets.UTF_8))) {
                String entryPath;
                while ((entryPath = inputFile.readLine()) != null) {
                    walkImpl(entryPath, outputFile);
                }
            } catch (IOException e) {
                throw new IllegalArgumentException("Can't read input file [inputFile=%s]".formatted(files[0]));
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Can't write to output file [output=%s]".formatted(files[1]));
        }
    }

    protected abstract void walkImpl(String filePath, Writer writer) throws IOException;

    protected void writeFileSHA256(Writer writer, String sha, String filePath) throws IOException {
        writer.write(sha);
        writer.write(" ");
        writer.write(filePath);
        writer.write(LINE_SEPARATOR);
    }

    protected void writeFaultSHA256(Writer writer, String filePath) throws IOException {
        writeFileSHA256(writer, FAULT_SHA, filePath);
    }

    protected byte[] calculateSHA256(Path file) throws IOException {
        byte[] buffer = new byte[BUFFER_SIZE];
        try (InputStream reader = new FileInputStream(file.toFile())) {
            int count;
            while ((count = reader.read(buffer)) >= 0) {
                messageDigest.update(buffer, 0, count);
            }
        }

        return messageDigest.digest();
    }

    protected String bytesToHex(byte[] bytes) {
        StringBuilder result = new StringBuilder(2 * bytes.length);

        for (byte el : bytes) {
            result.append(String.format("%02x", el));
        }

        return result.toString();
    }
}
