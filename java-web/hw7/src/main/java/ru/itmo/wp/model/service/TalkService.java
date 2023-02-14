package ru.itmo.wp.model.service;

import ru.itmo.wp.model.domain.Talk;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.model.exception.ValidationException;
import ru.itmo.wp.model.repository.impl.TalkRepositoryImpl;

import java.util.List;

public class TalkService {
    private final TalkRepositoryImpl talksRepository = new TalkRepositoryImpl();
    private final UserService userService = new UserService();

    public List<Talk> findByUserId(long userId) {
        return talksRepository.findByUserId(userId);
    }

    public void save(Talk talk) {
        talksRepository.save(talk);
    }

    public void validateTalk(User targetUser, Talk talk) throws ValidationException {
        if (targetUser == null) {
            throw new ValidationException("Target user doesn't exist");
        }

        if (talk.getText().length() > 1024) {
            throw new ValidationException("Text can't be longer than 1024 characters");
        }
        if (talk.getText().isEmpty()) {
            throw new ValidationException("Text can't be empty");
        }
    }
}
