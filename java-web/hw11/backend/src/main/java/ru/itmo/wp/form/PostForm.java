package ru.itmo.wp.form;

import ru.itmo.wp.domain.User;

import javax.persistence.Lob;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class PostForm {
    @NotBlank
    @Size(min = 1, max = 60)
    private String title;

    @NotBlank
    @Size(min = 1, max = 65000)
    @Lob
    private String text;

    @NotBlank
    private String jwt;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getJwt() {
        return jwt;
    }

    public void setJwt(String jwt) {
        this.jwt = jwt;
    }
}
