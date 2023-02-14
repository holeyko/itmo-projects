package ru.itmo.wp.domain;

import lombok.Data;

import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Entity
@Data
public class Tag {
    @Id
    @GeneratedValue
    private long id;

    @NotNull
    @NotEmpty
    @Size(max=32)
    private String name;

    public Tag() {}

    public Tag(String name) {
        this.name = name;
    }
}
