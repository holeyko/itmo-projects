package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("*")
public class NotFoudPage extends Page {

    @GetMapping
    public String notFoundPage() {
        return "NotFoundPage";
    }
}
