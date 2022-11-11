package ru.itmo.wp.model.repository.impl;

import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.model.domain.Event;
import ru.itmo.wp.model.repository.EventRepository;
import ru.itmo.wp.utils.Pair;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.List;

public class EventRepositoryImpl extends BaseRepositoryImpl<Event> implements EventRepository {
    public EventRepositoryImpl() {
        super("Event");
    }

    @Override
    public void save(Event event) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "INSERT INTO " + tableName + " (%s, %s, %s) VALUES (?, ?, NOW())",
                List.of(
                        new Pair<>("userId", event.getUserId()),
                        new Pair<>("type", event.getType()),
                        new Pair<>("creationTime", null)
                )
        );

        save(queryBuilder);
    }

    @Override
    protected Event parseSQLResponse(ResultSetMetaData metaData, ResultSet resultSet) {
        return null;
    }
}
