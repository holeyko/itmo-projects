package ru.itmo.wp.form.validator;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import ru.itmo.wp.form.PostForm;
import ru.itmo.wp.form.UserCredentialsEnter;
import ru.itmo.wp.service.UserService;

@Component
public class PostFormValidator implements Validator {
    public boolean supports(Class<?> clazz) {
        return PostForm.class.equals(clazz);
    }

    public void validate(Object target, Errors errors) {
        if (errors.hasErrors()) {
            errors.reject("invalid-text-or-title", "Invalid title or text");
        }
    }
}
