package ru.itmo.wp.model.repository;

import ru.itmo.wp.model.domain.Talk;

import java.util.List;

public interface TalkRepository extends BaseRepository<Talk> {
    Talk find(long id);

    List<Talk> findByUserId(long userId);

    void save(Talk talk);
}
