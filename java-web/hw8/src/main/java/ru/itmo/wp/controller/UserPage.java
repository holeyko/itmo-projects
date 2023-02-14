package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import ru.itmo.wp.domain.User;
import ru.itmo.wp.service.UserService;

@Controller
public class UserPage extends Page {
    private final UserService userService;

    public UserPage(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/user/{id}")
    public String user(@PathVariable String id, Model model) {
        try {
            User user = userService.findById(Long.parseLong(id));
            if (user != null) {
                model.addAttribute("viewUser", user);
            }
        } catch (NumberFormatException ignored) {
            //No operation
        }

        return "UserPage";
    }
}
