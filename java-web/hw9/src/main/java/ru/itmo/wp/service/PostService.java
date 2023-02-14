package ru.itmo.wp.service;

import org.springframework.stereotype.Service;
import ru.itmo.wp.domain.Post;
import ru.itmo.wp.domain.Tag;
import ru.itmo.wp.repository.PostRepository;
import ru.itmo.wp.repository.TagRepository;

import java.util.List;

@Service
public class PostService {
    private final PostRepository postRepository;
    private final TagRepository tagRepository;

    public PostService(PostRepository postRepository, TagRepository tagRepository) {
        this.postRepository = postRepository;
        this.tagRepository = tagRepository;
    }

    public List<Post> findAll() {
        return postRepository.findAllByOrderByCreationTimeDesc();
    }

    public Post findById(Long id) {
        return postRepository.findById(id).orElse(null);
    }

    public Post save(Post post) {
        return postRepository.save(post);
    }

    public boolean tagExistsByName(String name) {
        return tagRepository.existsByName(name);
    }

    public Tag saveTag(Tag tag) {
        return tagRepository.save(tag);
    }
}
