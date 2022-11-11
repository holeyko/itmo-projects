package ru.itmo.wp.model.repository.impl;

import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.model.domain.Talk;
import ru.itmo.wp.model.repository.TalkRepository;
import ru.itmo.wp.utils.Pair;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

public class TalkRepositoryImpl extends BaseRepositoryImpl<Talk> implements TalkRepository {
    public TalkRepositoryImpl() {
        super("Talk");
    }

    @Override
    public Talk find(long id) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "SELECT * FROM " + tableName + " WHERE %s=?",
                List.of(new Pair<>("id", id))
        );

        List<Talk> talks = findBy(queryBuilder);

        return talks.isEmpty() ? null : talks.get(0);
    }

    @Override
    public List<Talk> findByUserId(long userId) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "SELECT * FROM " + tableName + " WHERE %s=? OR %s=? ORDER BY creationTime DESC",
                List.of(
                        new Pair<>("sourceUserId", userId),
                        new Pair<>("targetUserId", userId)
                )
        );

        return findBy(queryBuilder);
    }

    @Override
    public void save(Talk talk) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "INSERT INTO " + tableName + " (%s, %s, %s, %s) VALUES (?, ?, ?, NOW())",
                List.of(
                        new Pair<>("sourceUserId", talk.getSourceUserId()),
                        new Pair<>("targetUserId", talk.getTargetUserId()),
                        new Pair<>("text", talk.getText()),
                        new Pair<>("creationTime", null)
                )
        );

        long id = save(queryBuilder);
        talk.setId(id);
        talk.setCreationTime(find(id).getCreationTime());
    }

    @Override
    protected Talk parseSQLResponse(ResultSetMetaData metaData, ResultSet resultSet) throws SQLException {
        if (!resultSet.next()) {
            return null;
        }

        Talk talk = new Talk();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            switch (metaData.getColumnName(i)) {
                case "id":
                    talk.setId(resultSet.getLong(i));
                    break;
                case "sourceUserId":
                    talk.setSourceUserId(resultSet.getLong(i));
                    break;
                case "targetUserId":
                    talk.setTargetUserId(resultSet.getLong(i));
                    break;
                case "creationTime":
                    talk.setCreationTime(resultSet.getTimestamp(i));
                    break;
                case "text":
                    talk.setText(resultSet.getString(i));
                default:
                    // No operations.
            }
        }

        return talk;
    }
}
