package ru.itmo.wp.domain;

import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Entity
@Table(
        indexes = {@Index(columnList = "creationTime"),
                @Index(columnList = "login", unique = true)}
)
@Data
public class User {
    @Id
    @GeneratedValue
    private long id;

    @NotNull
    @NotEmpty
    private String login;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @OrderBy("creationTime desc")
    private List<Post> posts;

    @CreationTimestamp
    private Date creationTime;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "user_role",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id"))
    private Set<Role> roles;

    public void addPost(Post post) {
        post.setUser(this);
        getPosts().add(post);
    }
}
