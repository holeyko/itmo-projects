package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Article;
import ru.itmo.wp.web.annotation.Json;
import ru.itmo.wp.web.exception.RedirectException;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public class MyArticlesPage extends Page {
    @Override
    protected void before(HttpServletRequest request, Map<String, Object> view) {
        commonPrepare(request, view);
        requireUser("To see your articles, enter in to your account.");
    }

    private void action(Map<String, Object> view) {
        List<Article> userArticles = articleService.findByUserId(getUser().getId());
        view.put("userArticles", userArticles);
    }

    @Json
    private void toggleHidden(HttpServletRequest request) {
        long articleId = Long.parseLong(request.getParameter("articleId"));
        long userId = Long.parseLong(request.getParameter("userId"));
        boolean hide = Boolean.parseBoolean(request.getParameter("hide"));

        if (articleService.find(articleId).getUserId() != userId) {
            setMessage("You can't toggle hidden not your own article");
            throw new RedirectException("/index");
        }

        articleService.toggleHidden(articleId, hide);
    }
}
