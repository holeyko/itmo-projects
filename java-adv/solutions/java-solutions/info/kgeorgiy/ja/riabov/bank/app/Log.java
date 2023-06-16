package info.kgeorgiy.ja.riabov.bank.app;

import java.util.ArrayList;
import java.util.List;

public class Log {
    private final String name;
    private final List<LogEntry> logs;

    public Log(final String name) {
        this.name = name;
        this.logs = new ArrayList<>();
    }

    public void log(final LogLevel level, final String message) {
        log(name, level, message);
    }

    public synchronized void log(final String app, final LogLevel level, final String message) {
        logs.add(new LogEntry(app, level, message));
        System.out.println(logs.get(logs.size() - 1).getMessage());
    }

    public void error(final LogLevel level, final Throwable e) {
        log(level, e.getClass().getSimpleName() + ": " + e.getMessage());
    }

    public List<LogEntry> getLogs() {
        return logs;
    }
}
