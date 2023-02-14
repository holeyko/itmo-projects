package ru.itmo.web.hw4.model;

public class Post {
    private final long id;
    private final long userId;
    private final String title;
    private final String text;

    public Post(long id, long userId, String title, String text) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.text = text;
    }

    public Long getId() {
        return id;
    }

    public Long getUserId() {
        return userId;
    }

    public String getTitle() {
        return title;
    }

    public String getText() {
        return text;
    }
}
