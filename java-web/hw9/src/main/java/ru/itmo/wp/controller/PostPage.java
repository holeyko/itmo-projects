package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import ru.itmo.wp.domain.Comment;
import ru.itmo.wp.domain.Post;
import ru.itmo.wp.security.Guest;
import ru.itmo.wp.service.PostService;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.NoSuchElementException;

@Controller
@RequestMapping("/post/{id}")
public class PostPage extends Page {
    private PostService postService;

    public PostPage(PostService postService) {
        this.postService = postService;
    }

    @ModelAttribute("post")
    public Post getPost(@PathVariable Long id, HttpSession httpSession) {
        Post post = postService.findById(id);
        if (post == null) {
            throw new NoSuchElementException("Not found post [post_id=" + id + "]");
        }

        return post;
    }

    @GetMapping
    @Guest
    public String showPost(Model model, HttpSession httpSession) {
        if (getUser(httpSession) != null) {
            model.addAttribute("newComment", new Comment());
        }

        return "PostPage";
    }

    @PostMapping
    public String writeComment(@PathVariable Long id, @Valid @ModelAttribute("newComment") Comment comment, BindingResult bindingResult, HttpSession httpSession) {
        if (bindingResult.hasErrors()) {
            return "PostPage";
        }

        Post post = postService.findById(id);
        if (post == null) {
            throw new NoSuchElementException("Not found post [id=" + id + "]");
        }

        comment.setUser(getUser(httpSession));
        post.addComment(comment);
        postService.save(post);

        putMessage(httpSession, "Comment was written successfully");

        return "redirect:/post/" + post.getId();
    }

    @ExceptionHandler({NumberFormatException.class, NoSuchElementException.class})
    public String handleNumberFormatException() {
        return "NotFoundPost";
    }
}
