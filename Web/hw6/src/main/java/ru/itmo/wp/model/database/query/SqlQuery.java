package ru.itmo.wp.model.database.query;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public interface SqlQuery {
    String buildQuery();

    void fillStatement(PreparedStatement statement) throws SQLException;
}
