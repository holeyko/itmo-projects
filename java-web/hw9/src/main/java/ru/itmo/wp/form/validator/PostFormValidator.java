package ru.itmo.wp.form.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import ru.itmo.wp.form.PostForm;

import java.util.Arrays;
import java.util.List;

@Component
public class PostFormValidator implements Validator {
    @Override
    public boolean supports(Class<?> clazz) {
        return PostForm.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        if (!errors.hasErrors()) {
            PostForm postForm = (PostForm) target;
            String[] tags = postForm.getTags().split("\\s+");

            if (!Arrays.stream(tags).allMatch(el -> el.matches("[a-z]+"))) {
                errors.rejectValue("tags", "tags.invalid-tags", "invalid tags");
            }
        }
    }
}
