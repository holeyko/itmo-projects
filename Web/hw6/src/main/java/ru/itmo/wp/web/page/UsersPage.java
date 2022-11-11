package ru.itmo.wp.web.page;

import java.util.Map;

@SuppressWarnings({"unused"})
public class UsersPage extends Page {
    private void action(Map<String, Object> view) {
        view.put("users", userService.findAll());
    }
}
