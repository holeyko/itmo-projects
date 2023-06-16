package info.kgeorgiy.ja.riabov.bank.app;

public class LogEntry {
    private static final String TEMPLATE = "[%s] App: %s | %s";
    private final String message;

    public LogEntry(final String app, final LogLevel level, final String message) {
        this.message = TEMPLATE.formatted(level, app, message);
    }

    public String getMessage() {
        return message;
    }

}
