package ru.itmo.wp.model.repository;

import ru.itmo.wp.model.domain.Article;

import java.util.List;

public interface ArticleRepository {
    void save(Article article);

    void toggleHidden(long articleId, boolean hide);

    Article find(long id);

    List<Article> findByUserId(long userId);

    List<Article> findAll();
}
