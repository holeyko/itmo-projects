package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ru.itmo.wp.domain.User;
import ru.itmo.wp.service.UserService;

import java.util.List;

@Controller
public class UsersPage extends Page {
    private final UserService userService;

    public UsersPage(UserService userService) {
        this.userService = userService;
    }

    @ModelAttribute("users")
    public List<User> getUsers() {
        return userService.findAll();
    }

    @GetMapping("/users/all")
    public String users() {
        return "UsersPage";
    }

    @PostMapping("/users/all")
    public String toggleDisabled(@RequestParam("userId") String userIdString, @RequestParam String toggleDisabled) {
        try {
            Long userId = Long.parseLong(userIdString);
            if (toggleDisabled.equals("Enable")) {
                userService.toggleDisabled(userId, false);
            } else if (toggleDisabled.equals("Disable")) {
                userService.toggleDisabled(userId, true);
            }
        } catch (NumberFormatException ignored) {
            // No operation
        }

        return "redirect:/users/all";
    }
}
