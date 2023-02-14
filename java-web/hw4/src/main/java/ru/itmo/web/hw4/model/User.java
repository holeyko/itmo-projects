package ru.itmo.web.hw4.model;

public class User {
    private final long id;
    private final String handle;
    private final String name;
    private final UserColor color;

    public UserColor getColor() {
        return color;
    }

    public User(long id, String handle, String name, UserColor color) {
        this.id = id;
        this.handle = handle;
        this.name = name;
        this.color = color;
    }

    public long getId() {
        return id;
    }

    public String getHandle() {
        return handle;
    }

    public String getName() {
        return name;
    }

    public static enum UserColor {
        RED("red"),
        GREEN("green"),
        BLUE("blue");

        private final String colorName;

        private UserColor(String colorName) {
            this.colorName = colorName;
        }

        public String getColorName() {
            return colorName;
        }
    }
}
