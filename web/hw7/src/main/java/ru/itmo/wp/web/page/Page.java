package ru.itmo.wp.web.page;

import com.google.common.base.Strings;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.model.service.ArticleService;
import ru.itmo.wp.model.service.EventService;
import ru.itmo.wp.model.service.TalkService;
import ru.itmo.wp.model.service.UserService;
import ru.itmo.wp.web.exception.RedirectException;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public abstract class Page {
    protected HttpServletRequest lastRequest;

    protected final UserService userService = new UserService();
    protected final EventService eventService = new EventService();
    protected final TalkService talkService = new TalkService();
    protected final ArticleService articleService = new ArticleService();

    protected void before(HttpServletRequest request, Map<String, Object> view) {
        commonPrepare(request, view);
    }

    protected void commonPrepare(HttpServletRequest request, Map<String, Object> view) {
        lastRequest = request;

        putUser(view);
        putMessage(view);
        view.put("userCount", userService.findCount());
    }

    protected void requireUser(String messageRedirect) {
        if (getUser() == null) {
            setMessage(messageRedirect);
            throw new RedirectException("/index");
        }
    }

    protected void action() {}

    protected void after() {
    }

    protected void putUser(Map<String, Object> view) {
        User user = (User) getAttribute("user");
        if (user != null) {
            view.put("user", user);
        }
    }

    protected void setUser(User user) {
        setAttribute("user", user);
    }

    protected User getUser() {
        return lastRequest == null ? null : (User) lastRequest.getSession().getAttribute("user");
    }

    protected void removeUser() {
        removeAttribute("user");
    }

    protected void putMessage(Map<String, Object> view) {
        String message = (String) lastRequest.getSession().getAttribute("message");
        if (!Strings.isNullOrEmpty(message)) {
            view.put("message", message);
            removeAttribute("message");
        }
    }

    protected void setMessage(String message) {
       setAttribute("message", message);
    }

    protected void setAttribute(String key, Object value) {
        if (lastRequest != null) {
            lastRequest.getSession().setAttribute(key, value);
        }
    }

    protected Object getAttribute(String key) {
        return lastRequest == null ? null : lastRequest.getSession().getAttribute(key);
    }

    protected void removeAttribute(String key) {
        if (lastRequest != null) {
            lastRequest.getSession().removeAttribute(key);
        }
    }
}
