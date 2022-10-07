package ru.itmo.wp.servlet;

import ru.itmo.wp.util.ImageUtils;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.Writer;
import java.util.Base64;
import java.util.Random;

public class CaptchaFilter extends HttpFilter {
    private final String CAPTCHA_USER_ANSWER_PARAMETER_TEXT = "captcha-answer";
    private final String CAPTCHA_PASSED_ATTRIBUTE_TEXT = "Captcha-Passed";
    private final String CAPTCHA_ANSWER_ATTRIBUTE_TEXT = "Captcha-Right-Answer";
    private final String LAST_URI_ATTRIBUTE_TEXT = "Last-URI";

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpSession session = request.getSession();
        if (request.getMethod().equals("GET"))  {
            if (session.getAttribute(this.CAPTCHA_PASSED_ATTRIBUTE_TEXT) == null) {
                session.setAttribute(this.LAST_URI_ATTRIBUTE_TEXT, request.getRequestURI());
                redirectToCaptcha(request, response);
            } else {
                chain.doFilter(request, response);
            }
        } else if (request.getMethod().equals("POST")) {
            if (
                    session.getAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT) != null &&
                            request.getParameter(this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT) != null &&
                            request.getParameter(this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT).equals(session.getAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT))
            ) {
                session.setAttribute(this.CAPTCHA_PASSED_ATTRIBUTE_TEXT, "true");

                String uri = (String) session.getAttribute(this.LAST_URI_ATTRIBUTE_TEXT);

            } else {
                redirectToCaptcha(request, response);
            }
        } else {
            response.setStatus(405);
        }
    }

    private void redirectToCaptcha(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        int randomNumber = new Random().nextInt(899) + 100;
        byte[] captcha = ImageUtils.toPng(Integer.toString(randomNumber));

        session.setAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT, Integer.toString(randomNumber));

        response.setContentType("text/html");
        try (Writer writer = response.getWriter()) {
            String html = String.format("""
                    <img width=237 height=97 src=data:image/png;base64,%s>
                    <form action="captcha/check" method="post">
                         <label for="captcha_input">Enter number:</label>
                         <input name=%s id="captcha_input">
                    </form>
                    """, Base64.getEncoder().encodeToString(captcha), this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT);
            writer.write(html);
            writer.flush();
        }
    }
}
