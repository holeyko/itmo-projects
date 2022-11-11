package ru.itmo.wp.model.database;

import org.mariadb.jdbc.MariaDbDataSource;
import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.utils.Pair;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

public class DatabaseUtils {
    public static DataSource getDataSource() {
        return DataSourceHolder.INSTANCE;
    }

    public static Pair<PreparedStatement, ResultSet> executeSqlReadQuery(SqlQueryImpl queryBuilder) throws SQLException {
        Connection connection = getDataSource().getConnection();

        PreparedStatement statement = connection.prepareStatement(queryBuilder.buildQuery());
        queryBuilder.fillStatement(statement);
        ResultSet resultSet = statement.executeQuery();

        return new Pair<>(statement, resultSet);
    }

    public static Pair<PreparedStatement, Integer> executeSqlModifyQuery(SqlQueryImpl queryBuilder) throws SQLException {
        Connection connection = getDataSource().getConnection();

        PreparedStatement statement = connection.prepareStatement(queryBuilder.buildQuery(), Statement.RETURN_GENERATED_KEYS);
        queryBuilder.fillStatement(statement);

        return new Pair<>(statement, statement.executeUpdate());
    }

    private static final class DataSourceHolder {
        private static final DataSource INSTANCE;
        private static final Properties properties = new Properties();

        static {
            try {
                properties.load(DataSourceHolder.class.getResourceAsStream("/application.properties"));
            } catch (IOException e) {
                throw new RuntimeException("Can't load /application.properties.", e);
            }

            try {
                MariaDbDataSource instance = new MariaDbDataSource();
                instance.setUrl(properties.getProperty("database.url"));
                instance.setUser(properties.getProperty("database.user"));
                instance.setPassword(properties.getProperty("database.password"));
                INSTANCE = instance;
            } catch (SQLException e) {
                throw new RuntimeException("Can't initialize DataSource.", e);
            }

            try (Connection connection = INSTANCE.getConnection()) {
                if (connection == null) {
                    throw new RuntimeException("Can't create testing connection via DataSource.");
                }
            } catch (SQLException e) {
                throw new RuntimeException("Can't create testing connection via DataSource.", e);
            }
        }
    }
}

