package ru.itmo.wp.model.repository.impl;

import ru.itmo.wp.model.database.DatabaseUtils;
import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.model.exception.RepositoryException;
import ru.itmo.wp.utils.Pair;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public abstract class BaseRepositoryImpl<T> {
    protected final String tableName;
    protected final DataSource DATA_SOURCE = DatabaseUtils.getDataSource();

    public BaseRepositoryImpl(String tableName) {
        this.tableName = tableName;
    }

    protected List<T> findBy(SqlQueryImpl queryBuilder) {
        List<T> models = new ArrayList<>();
        try (Pair<PreparedStatement, ResultSet> queryResponse = DatabaseUtils.executeSqlReadQuery(queryBuilder)) {
            PreparedStatement statement = queryResponse.getFirst();
            ResultSet resultSet = queryResponse.getSecond();
            T model;
            while ((model = parseSQLResponse(statement.getMetaData(), resultSet)) != null) {
                models.add(model);
            }
        } catch (SQLException | IOException e) {
            throw new RepositoryException("Can't find elements [query=" + queryBuilder.buildQuery() + "]", e);
        }

        return models;
    }

    protected int findCount(SqlQueryImpl queryBuilder) {
        int result = 0;
        try (Pair<PreparedStatement, ResultSet> queryResponse = DatabaseUtils.executeSqlReadQuery(queryBuilder)) {
            ResultSet resultSet = queryResponse.getSecond();
            if (resultSet.next()) {
                result = resultSet.getInt(1);
            }
        } catch (SQLException | IOException e) {
            throw new RepositoryException("Can't count elements [query=" + queryBuilder.buildQuery() + "]", e);
        }

        return result;
    }

    protected long save(SqlQueryImpl queryBuilder) {
        try (Pair<PreparedStatement, Integer> queryResponse = DatabaseUtils.executeSqlInsertQuery(queryBuilder)){
            PreparedStatement statement = queryResponse.getFirst();
            int resultExecution = queryResponse.getSecond();
            if (resultExecution != 1) {
                throw new RepositoryException("Can't save element [query=" + queryBuilder.buildQuery() + "]");
            } else {
                ResultSet generatedKeys = statement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                } else {
                    throw new RepositoryException("Can't save element [query=" + queryBuilder.buildQuery() + ", no autogenerated fields]");
                }
            }
        } catch (SQLException | IOException e) {
            throw new RepositoryException("Can't save element [query=" + queryBuilder.buildQuery() + "]", e);
        }
    }

    protected void update(SqlQueryImpl queryBuilder) {
        try {
            DatabaseUtils.executeSqlUpdateQuery(queryBuilder);
        } catch (SQLException e) {
            throw new RepositoryException("Can't update element [query=" + queryBuilder.buildQuery() + "]", e);
        }
    }

    protected abstract T parseSQLResponse(ResultSetMetaData metaData, ResultSet resultSet) throws SQLException;
}

