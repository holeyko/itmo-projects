package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class NotFoundPage extends Page {
    @GetMapping("*")
    public String notFound() {
        return "NotFoundPage";
    }
}
