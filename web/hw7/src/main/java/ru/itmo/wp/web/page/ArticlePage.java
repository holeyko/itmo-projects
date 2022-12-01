package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Article;
import ru.itmo.wp.model.exception.ValidationException;
import ru.itmo.wp.web.annotation.Json;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public class ArticlePage extends Page {
    @Override
    protected void before(HttpServletRequest request, Map<String, Object> view) {
        commonPrepare(request, view);
        requireUser("To write an article, enter in to your account.");
    }

    @Json
    private void write(HttpServletRequest request, Map<String, Object> view) throws ValidationException {
        Article article = new Article();

        article.setUserId(Long.parseLong(request.getParameter("userId")));
        article.setTitle(request.getParameter("title"));
        article.setText(request.getParameter("text"));
        article.setHidden(false);

        articleService.validate(article);
        articleService.save(article);

        setMessage("Your article has been successfully saved");
        putMessage(view);
    }
}
