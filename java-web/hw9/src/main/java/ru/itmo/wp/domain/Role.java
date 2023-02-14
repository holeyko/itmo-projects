package ru.itmo.wp.domain;

import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(indexes = @Index(columnList = "name", unique = true))
@Data
public class Role {
    @Id
    @GeneratedValue
    private long id;

    @NotNull
    @Enumerated(EnumType.STRING)
    private Name name;

    public Role(@NotNull Name name) {
        this.name = name;
    }

    public Role() {}

    public enum Name {
        WRITER,
        ADMIN
    }
}
