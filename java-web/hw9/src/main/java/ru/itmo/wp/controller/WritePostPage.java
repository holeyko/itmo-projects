package ru.itmo.wp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import ru.itmo.wp.domain.Post;
import ru.itmo.wp.domain.Role;
import ru.itmo.wp.domain.Tag;
import ru.itmo.wp.form.PostForm;
import ru.itmo.wp.form.validator.PostFormValidator;
import ru.itmo.wp.security.AnyRole;
import ru.itmo.wp.service.PostService;
import ru.itmo.wp.service.UserService;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class WritePostPage extends Page {
    private final UserService userService;
    private final PostService postService;
    private final PostFormValidator postFormValidator;

    public WritePostPage(UserService userService, PostService postService, PostFormValidator postFormValidator) {
        this.userService = userService;
        this.postService = postService;
        this.postFormValidator = postFormValidator;
    }

    @InitBinder("postForm")
    public void initBinder(WebDataBinder binder) {
        binder.addValidators(postFormValidator);
    }

    @AnyRole({Role.Name.WRITER})
    @GetMapping("/writePost")
    public String writePostGet(Model model) {
        model.addAttribute("postForm", new PostForm());
        return "WritePostPage";
    }

    @AnyRole({Role.Name.WRITER})
    @PostMapping("/writePost")
    public String writePostPost(@Valid @ModelAttribute("postForm") PostForm postForm,
                                BindingResult bindingResult,
                                HttpSession httpSession) {
        if (bindingResult.hasErrors()) {
            return "WritePostPage";
        }

        Post post = new Post();
        post.setTitle(postForm.getTitle());
        post.setText(postForm.getText());
        Set<Tag> setTags = Arrays.stream(postForm.getTags().split("\\s+")).map(Tag::new).collect(Collectors.toCollection(HashSet::new));
        for (Tag tag: setTags) {
            if (!postService.tagExistsByName(tag.getName())) {
                postService.saveTag(tag);
            }

            post.addTag(tag);
        }
        userService.writePost(getUser(httpSession), post);

        putMessage(httpSession, "You published new post");
        return "redirect:/myPosts";
    }
}
