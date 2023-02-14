package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Article;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.web.annotation.Json;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings({"unused"})
public class IndexPage extends Page {
    @Json
    private void findAllArticles(Map<String, Object> view) {
        List<Article> articles = articleService.findAll().stream().filter(el -> !el.isHidden()).toList();
        Map<Long, User> writers = new HashMap<>();

        for (Article article : articles) {
            if (!writers.containsKey(article.getUserId())) {
                User user = userService.find(article.getUserId());
                writers.put(user.getId(), user);
            }
        }

        view.put("articles", articles);
        view.put("writers", writers);
    }
}
