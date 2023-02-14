package ru.itmo.wp.model.service;

import com.google.common.base.Strings;
import ru.itmo.wp.model.domain.Article;
import ru.itmo.wp.model.exception.ValidationException;
import ru.itmo.wp.model.repository.impl.ArticleRepositoryImpl;

import java.util.List;

public class ArticleService {
    ArticleRepositoryImpl articleRepository = new ArticleRepositoryImpl();

    public void validate(Article article) throws ValidationException {
        if (Strings.isNullOrEmpty(article.getTitle())) {
            throw new ValidationException("Title is required");
        }
        if (article.getTitle().length() < 3) {
            throw new ValidationException("Title can't be shorter than 3 characters");
        }
        if (article.getTitle().length() > 30) {
            throw new ValidationException("Title can't be longer than 30 characters");
        }

        if (Strings.isNullOrEmpty(article.getText())) {
            throw new ValidationException("Text is required");
        }
        if (article.getText().length() < 5) {
            throw new ValidationException("Text can't be shorter than 5 characters");
        }
        if (article.getText().length() > 1000) {
            throw new ValidationException("Text can't be longer than 1000 characters");
        }
    }

    public void save(Article article) {
        articleRepository.save(article);
    }

    public void toggleHidden(long articleId, boolean hide) {
        articleRepository.toggleHidden(articleId, hide);
    }

    public Article find(long id) {
        return articleRepository.find(id);
    }

    public List<Article> findByUserId(long userId) {
        return articleRepository.findByUserId(userId);
    }

    public List<Article> findAll() {
        return articleRepository.findAll();
    }
}
