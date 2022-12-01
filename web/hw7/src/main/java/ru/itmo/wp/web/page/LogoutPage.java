package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Event;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.web.exception.RedirectException;

public class LogoutPage extends Page {
    @Override
    protected void action() {
        User user = getUser();
        if (user != null) {
            Event event = new Event();
            event.setUserId(user.getId());
            event.setType(Event.Type.LOGOUT);
            eventService.save(event);

            removeUser();
            setMessage("Good bye. Hope to see you soon!");
        }

        throw new RedirectException("/index");
    }
}
