package ru.itmo.wp.model.repository;

import ru.itmo.wp.model.database.query.SqlQueryImpl;

import java.util.List;

public interface BaseRepository<T> {
    List<T> findBy(SqlQueryImpl queryBuilder);

    int findCount(SqlQueryImpl queryBuilder);

    long save(SqlQueryImpl queryBuilder);
}
