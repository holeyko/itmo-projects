package ru.itmo.wp.model.database.query;

import org.checkerframework.checker.nullness.qual.NonNull;
import ru.itmo.wp.utils.Pair;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SqlQueryImpl implements SqlQuery {
    @NonNull
    private final String template;
    @NonNull
    private List<Pair<String, Object>> parameters = new ArrayList<>();

    public SqlQueryImpl(@NonNull String template) {
        this.template = template;
    }

    public SqlQueryImpl(@NonNull String template, @NonNull List<Pair<String, Object>> parameters) {
        this.template = template;
        this.parameters = parameters;
    }

    @Override
    public String buildQuery() {
        List<String> parameterNames = new ArrayList<>();
        for (Pair<String, Object> pair : parameters) {
            parameterNames.add(pair.getFirst());
        }

        return String.format(template, parameterNames.toArray());
    }

    @Override
    public void fillStatement(PreparedStatement statement) throws SQLException {
        int numberParameter = 1;
        for (Pair<String, Object> pair : parameters) {
            Object value = pair.getSecond();
            if (value == null) {
                continue;
            }

            if (value instanceof Long) {
                statement.setLong(numberParameter, (Long) value);
            } else if (value instanceof Date) {
                statement.setDate(numberParameter, (Date) value);
            } else {
                statement.setString(numberParameter, value.toString());
            }

            ++numberParameter;
        }
    }

    public String getTemplate() {
        return template;
    }

    public List<Pair<String, Object>> getParameters() {
        return parameters;
    }

    public void setParameters(List<Pair<String, Object>> parameters) {
        this.parameters = parameters;
    }
}
