package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import ru.itmo.wp.form.NoticeForm;
import ru.itmo.wp.service.NoticeService;

import javax.validation.Valid;

@Controller
public class NoticePage extends Page {
    private NoticeService noticeService;

    public NoticePage(NoticeService noticeService) {
        this.noticeService = noticeService;
    }

    @GetMapping("/notice/add")
    public String addNotice(Model model) {
        model.addAttribute("noticeForm", new NoticeForm());

        return "AddNotice";
    }

    @PostMapping("/notice/add")
    public String addNotice(@Valid  @ModelAttribute("noticeForm") NoticeForm noticeForm, BindingResult bindingResult) {
        if (!bindingResult.hasErrors()) {
            noticeService.save(noticeForm);
            return "redirect:/notice/add";
        }

        return "AddNotice";
    }
}
