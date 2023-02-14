package ru.itmo.wp.controller;

import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import ru.itmo.wp.domain.User;
import ru.itmo.wp.exception.ValidationException;
import ru.itmo.wp.form.UserCredentialsRegister;
import ru.itmo.wp.form.validator.UserCredentialsRegisterValidator;
import ru.itmo.wp.service.JwtService;
import ru.itmo.wp.service.UserService;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/1")
public class UserController {
    private final JwtService jwtService;
    private final UserService userService;
    private final UserCredentialsRegisterValidator userCredentialsRegisterValidator;

    public UserController(JwtService jwtService, UserService userService, UserCredentialsRegisterValidator userCredentialsRegisterValidator) {
        this.jwtService = jwtService;
        this.userService = userService;
        this.userCredentialsRegisterValidator = userCredentialsRegisterValidator;
    }

    @GetMapping("users/auth")
    public User findUserByJwt(@RequestParam String jwt) {
        return jwtService.find(jwt);
    }

    @InitBinder("userCredentialsRegister")
    public void initBinder(WebDataBinder binder) {
        binder.addValidators(userCredentialsRegisterValidator);
    }

    @PostMapping("users/register")
    public String register(@Valid @RequestBody UserCredentialsRegister userCredentialsRegister,
                           BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new ValidationException(bindingResult);
        }

        User user = userService.register(userCredentialsRegister);

        return jwtService.create(user);
    }

    @GetMapping("users")
    public List<User> findAll() {
        return userService.findAll();
    }
}
