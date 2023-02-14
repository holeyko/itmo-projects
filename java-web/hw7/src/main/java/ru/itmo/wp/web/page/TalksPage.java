package ru.itmo.wp.web.page;

import ru.itmo.wp.model.domain.Talk;
import ru.itmo.wp.model.domain.User;
import ru.itmo.wp.model.exception.ValidationException;
import ru.itmo.wp.web.exception.RedirectException;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public class TalksPage extends Page {
    @Override
    protected void before(HttpServletRequest request, Map<String, Object> view) {
        commonPrepare(request, view);
        requireUser("To talk with other users, enter in to your account.");
    }

    private void sendMessage(HttpServletRequest request) throws ValidationException {
        String targetLogin = request.getParameter("targetLogin");
        String text = request.getParameter("text");

        Talk talk = new Talk();
        talk.setText(text);
        User targetUser = userService.findByLogin(targetLogin);

        talkService.validateTalk(targetUser, talk);

        User user = getUser();
        talk.setSourceUserId(user.getId());
        talk.setTargetUserId(targetUser.getId());

        talkService.save(talk);
        setAttribute("targetUser", targetUser);

        throw new RedirectException("/talks");
    }

    private void after(Map<String, Object> view) {
        view.put("users", userService.findAll());
        view.put("talks", talkService.findByUserId(getUser().getId()));

        User targetUser;
        if ((targetUser = (User) getAttribute("targetUser")) != null) {
            view.put("targetUser", targetUser);
        }
    }
}
