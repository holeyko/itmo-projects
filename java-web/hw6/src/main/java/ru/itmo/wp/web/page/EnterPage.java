package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Event;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.model.exception.ValidationException;
import ru.itmo.wp.web.exception.RedirectException;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@SuppressWarnings({"unused"})
public class EnterPage extends Page {
    private void enter(HttpServletRequest request, Map<String, Object> view) throws ValidationException {
        if (getUser() == null) {
            String loginOrEmail = request.getParameter("loginOrEmail");
            String password = request.getParameter("password");

            User user = userService.validateEnter(loginOrEmail, password);

            Event event = new Event();
            event.setUserId(user.getId());
            event.setType(Event.Type.ENTER);
            eventService.save(event);

            setUser(user);
            setMessage("Hello, " + user.getLogin());

            throw new RedirectException("/index");
        }
    }
}
