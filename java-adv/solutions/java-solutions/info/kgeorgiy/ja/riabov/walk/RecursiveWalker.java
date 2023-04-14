package info.kgeorgiy.ja.riabov.walk;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

public class RecursiveWalker extends AbstractWalker {
    public RecursiveWalker() { super(); }

    @Override
    protected void walkImpl(String entryPath, Writer writer) throws IOException {
        try {
            Path entry = Path.of(entryPath);
            Files.walkFileTree(entry, new SimpleFileVisitor<>() {
                @Override
                public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                    try {
                        writeFileSHA256(writer, bytesToHex(calculateSHA256(file)), file.toString());
                    } catch (IOException e) {
                        writeFaultSHA256(writer, file.toString());
                    }

                    return FileVisitResult.CONTINUE;
                }
            });
        } catch (InvalidPathException | NoSuchFileException | FileNotFoundException e) {
            writeFaultSHA256(writer, entryPath);
        } catch (SecurityException e) {
            System.err.println("Have not an access to walk a directory [directory=%s]".formatted(entryPath));
        } catch (IOException e) {
            System.err.println("Can't walk a directory [directory=%s]".formatted(entryPath));
        }
    }
}
