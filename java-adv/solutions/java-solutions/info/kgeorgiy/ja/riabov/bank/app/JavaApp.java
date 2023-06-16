package info.kgeorgiy.ja.riabov.bank.app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;

public class JavaApp {
    private final String name;
    private final ProcessBuilder processBuilder;
    private final Log log;
    private Process process;

    public JavaApp(final String name, final String classpath, final String... command) {
        this.name = name;
        this.log = new Log(name);
        processBuilder = new ProcessBuilder(command);
        processBuilder.environment().put("CLASSPATH", classpath);
    }

    public String getName() {
        return name;
    }

    public void start() {
        if (process != null && process.isAlive()) {
            logPid(LogLevel.ERROR, "Already running");
            return;
        }

        process = null;

        try {
            process = processBuilder.start();
            handle(LogLevel.OUTPUT, process.getInputStream());
            handle(LogLevel.ERROR, process.getErrorStream());
            logPid(LogLevel.INFO, "Started process");
        } catch (final IOException e) {
            log.error(LogLevel.ERROR, e);
        }
    }

    public void stop() {
        if (process == null) {
            log.log(name, LogLevel.INFO, "No process");
            return;
        }

        while (process.isAlive()) {
            process.destroy();
            try {
                if (process.waitFor(1, TimeUnit.DAYS)) {
                    logPid(LogLevel.INFO, "Stopped process");
                    process = null;
                    break;
                } else {
                    logPid(LogLevel.ERROR, "Process still alive after 1 day");
                }
            } catch (final InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }

    private void logPid(final LogLevel level, final String message) {
        log.log(name, level, message + ", pid=" + process.pid());
    }

    private void handle(final LogLevel level, final InputStream stream) {
        new Thread(() -> {
            // Using default encoding
            try (final BufferedReader reader = new BufferedReader(new InputStreamReader(stream))) {
                while (true) {
                    final String line = reader.readLine();
                    if (line == null) {
                        return;
                    }
                    log.log(name, level, line.replace("\t", "\u00a0\u00a0\u00a0\u00a0"));
                }
            } catch (final IOException e) {
                log.error(LogLevel.ERROR, e);
            }
        }).start();
    }
}