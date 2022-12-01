package ru.itmo.wp.web.page;

import ru.itmo.wp.web.annotation.Json;
import ru.itmo.wp.web.exception.RedirectException;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@SuppressWarnings({"unused"})
public class UsersPage extends Page {
    private void action(Map<String, Object> view) {
        // No operations.
    }

    @Json
    private void findAll(Map<String, Object> view) {
        view.put("users", userService.findAll());
    }

    @Json
    private void findUser(HttpServletRequest request, Map<String, Object> view) {
        long userId = Long.parseLong(request.getParameter("userId"));
        view.put("user", userService.find(userId));
    }

    @Json
    private void toggleAdmin(HttpServletRequest request, Map<String, Object> view) {
        requireUser("You can't change the admin status, because you are not logged in to your account");

        long userAdminId = Long.parseLong(request.getParameter("userAdminId"));
        long userToggleAdminId = Long.parseLong(request.getParameter("userToggleAdminId"));
        boolean admin = Boolean.parseBoolean(request.getParameter("admin"));

        if (!userService.find(userAdminId).isAdmin()) {
            setMessage("You can't toggle admin status, because you're not an admin");
            throw new RedirectException("/index");
        }

        userService.setAdmin(userToggleAdminId, admin);
    }
}
