package ru.itmo.wp.model.repository.impl;

import ru.itmo.wp.model.database.query.SqlQueryImpl;
import ru.itmo.wp.model.domain.Article;
import ru.itmo.wp.model.repository.ArticleRepository;
import ru.itmo.wp.utils.Pair;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;

public class ArticleRepositoryImpl extends BaseRepositoryImpl<Article> implements ArticleRepository {
    public ArticleRepositoryImpl() {
        super("Article");
    }

    @Override
    public void save(Article article) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "INSERT INTO " + tableName + " (%s, %s, %s, %s, %s) VALUES (?, ?, ?, NOW(), ?)",
                List.of(
                        new Pair<>("userId", article.getUserId()),
                        new Pair<>("title", article.getTitle()),
                        new Pair<>("text", article.getText()),
                        new Pair<>("creationTime", null),
                        new Pair<>("hidden", article.isHidden() ? 1 : 0)
                )
        );

        long id = save(queryBuilder);

        article.setId(id);
        article.setCreationTime(find(id).getCreationTime());
    }

    @Override
    public void toggleHidden(long articleId, boolean hide) {
        update(new SqlQueryImpl(
                "UPDATE " + tableName + " SET %s=? WHERE %s=?",
                List.of(
                        new Pair<>("hidden", hide ? 1 : 0),
                        new Pair<>("id", articleId)
                )
        ));
    }

    @Override
    public Article find(long id) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "SELECT * FROM " + tableName + " WHERE %s=?",
                List.of(new Pair<>("id", id))
        );

        List<Article> articles = findBy(queryBuilder);
        return articles.isEmpty() ? null : articles.get(0);
    }

    @Override
    public List<Article> findByUserId(long userId) {
        SqlQueryImpl queryBuilder = new SqlQueryImpl(
                "SELECT * FROM " + tableName + " WHERE %s=? ORDER BY id DESC",
                List.of(new Pair<>("userId", userId))
        );

        return findBy(queryBuilder);
    }

    @Override
    public List<Article> findAll() {
        return findBy(new SqlQueryImpl(
                "SELECT * FROM " + tableName + " ORDER BY id DESC"
        ));
    }

    @Override
    protected Article parseSQLResponse(ResultSetMetaData metaData, ResultSet resultSet) throws SQLException {
        if (!resultSet.next()) {
            return null;
        }

        Article article = new Article();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            switch (metaData.getColumnName(i)) {
                case "id":
                    article.setId(resultSet.getLong(i));
                    break;
                case "userId":
                    article.setUserId(resultSet.getLong(i));
                    break;
                case "title":
                    article.setTitle(resultSet.getString(i));
                    break;
                case "text":
                    article.setText(resultSet.getString(i));
                    break;
                case "creationTime":
                    article.setCreationTime(resultSet.getTimestamp(i));
                    break;
                case "hidden":
                    article.setHidden(resultSet.getBoolean(i));
                default:
                    // No operations.
            }
        }

        return article;
    }
}
