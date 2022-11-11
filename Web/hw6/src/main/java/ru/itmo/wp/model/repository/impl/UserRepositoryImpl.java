package ru.itmo.wp.model.repository.impl;

import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.model.repository.UserRepository;
import ru.itmo.wp.utils.Pair;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

public class UserRepositoryImpl extends BaseRepositoryImpl<User> implements UserRepository {
    public UserRepositoryImpl() {
        super("User");
    }

    @Override
    public User find(long id) {
        return findUser(List.of(
                new Pair<>("id", id)
        ));
    }

    @Override
    public User findByLogin(String login) {
        return findUser(List.of(
                new Pair<>("login", login)
        ));
    }

    @Override
    public User findByLoginAndPasswordSha(String login, String passwordSha) {
        return findUser(List.of(
                new Pair<>("login", login),
                new Pair<>("passwordSha", passwordSha)
        ));
    }

    @Override
    public User findByEmail(String email) {
        return findUser(List.of(
                new Pair<>("email", email)
        ));
    }

    @Override
    public User findByEmailAndPasswordSha(String email, String passwordSha) {
        return findUser(List.of(
                new Pair<>("email", email),
                new Pair<>("passwordSha", passwordSha)
        ));
    }

    private User findUser(List<Pair<String, Object>> whereParameters) {
        StringBuilder templateBuilder = new StringBuilder("SELECT * FROM " + tableName + " WHERE");
        for (int i = 0; i < whereParameters.size(); ++i) {
            if (i == 0) {
                templateBuilder.append(" %s=?");
            } else {
                templateBuilder.append(" AND %s=?");
            }
        }

        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                templateBuilder.toString(),
                whereParameters
        );

        List<User> users = findBy(queryBuilder);

        return (users == null || users.isEmpty()) ? null : users.get(0);
    }

    @Override
    public List<User> findAll() {
        return findBy(new SqlQueryImpl(
                "SELECT * FROM " + tableName + " ORDER BY id DESC"
        ));
    }

    @Override
    public int findCount() {
        return findCount(new SqlQueryImpl(
                "SELECT COUNT(*) FROM " + tableName
        ));
    }

    @Override
    public void save(User user, String passwordSha) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "INSERT INTO " + tableName + " (%s, %s, %s, %s) VALUES (?, ?, ?, NOW())",
                List.of(
                        new Pair<>("login", user.getLogin()),
                        new Pair<>("passwordSha", passwordSha),
                        new Pair<>("email", user.getEmail()),
                        new Pair<>("creationTime", null)
                )
        );

        long id = save(queryBuilder);

        user.setId(id);
        user.setCreationTime(find(id).getCreationTime());
    }

    @Override
    protected User parseSQLResponse(ResultSetMetaData metaData, ResultSet resultSet) throws SQLException {
        if (!resultSet.next()) {
            return null;
        }

        User user = new User();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            switch (metaData.getColumnName(i)) {
                case "id":
                    user.setId(resultSet.getLong(i));
                    break;
                case "login":
                    user.setLogin(resultSet.getString(i));
                    break;
                case "email":
                    user.setEmail(resultSet.getString(i));
                    break;
                case "creationTime":
                    user.setCreationTime(resultSet.getTimestamp(i));
                    break;
                default:
                    // No operations.
            }
        }

        return user;
    }
}
