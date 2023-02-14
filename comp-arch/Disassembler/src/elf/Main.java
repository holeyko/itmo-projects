package elf;

import elf.dataContainers.ELFData;

import java.io.*;

public class Main {
    public static void main(String[] args) {
        final String inFileName = args[0];
        final String outFileName = args[1];

        try (Reader in = new InputStreamReader(new FileInputStream(inFileName))) {
            ELFData results = ELF.parse(inFileName);
            BufferedWriter out = new BufferedWriter(
                    new FileWriter(
                            outFileName
                    )
            );
            System.out.println(results.info());
            out.write(results.info());
        } catch (FileNotFoundException e) {
            System.err.println("Input file not found " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Something went wrong");
        }

    }
}
