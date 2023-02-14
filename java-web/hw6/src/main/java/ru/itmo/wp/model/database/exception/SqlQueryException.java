package ru.itmo.wp.model.database.exception;

public class SqlQueryException extends RuntimeException {

    public SqlQueryException(String message) {
        super(message);
    }

    public SqlQueryException(String message, Throwable cause) {
        super(message, cause);
    }
}
