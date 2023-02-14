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
    private final String CAPTCHA_ATTRIBUTE_TEXT = "Captcha";

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpSession session = request.getSession();
        if (session.getAttribute(this.CAPTCHA_PASSED_ATTRIBUTE_TEXT) != null) {
            if (request.getRequestURI().equals("/captcha/check") || request.getRequestURI().equals("/captcha/refresh")) {
                String lastUri = (String) session.getAttribute(this.LAST_URI_ATTRIBUTE_TEXT);
                response.setStatus(303);
                response.setHeader("Location", lastUri);
            }
            chain.doFilter(request, response);
        } else if (request.getMethod().equals("GET")) {
            session.setAttribute(this.LAST_URI_ATTRIBUTE_TEXT, request.getRequestURI());
            redirectToCaptcha(request, response, false);
        } else if (request.getMethod().equals("POST")) {
            String uri = request.getRequestURI();
            if (uri.equals("/captcha/check")) {
                if (
                        session.getAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT) != null &&
                                request.getParameter(this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT) != null &&
                                request.getParameter(this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT).equals(session.getAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT))
                ) {
                    session.setAttribute(this.CAPTCHA_PASSED_ATTRIBUTE_TEXT, "true");

                    String lastUri = (String) session.getAttribute(this.LAST_URI_ATTRIBUTE_TEXT);
                    response.setStatus(303);
                    response.setHeader("Location", lastUri);
                } else {
                    redirectToCaptcha(request, response, true);
                }
            } else if (uri.equals("/captcha/refresh")) {
                redirectToCaptcha(request, response, true);
            } else {
                response.setStatus(405);
            }
        } else {
            response.setStatus(405);
        }
    }

    private void redirectToCaptcha(HttpServletRequest request, HttpServletResponse response, boolean refresh) throws IOException {
        HttpSession session = request.getSession();
        if (refresh) {
            session.removeAttribute(this.CAPTCHA_ATTRIBUTE_TEXT);
            session.removeAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT);
        }

        byte[] captcha;
        if (session.getAttribute(this.CAPTCHA_ATTRIBUTE_TEXT) == null) {
            int randomNumber = new Random().nextInt(899) + 100;
            captcha = ImageUtils.toPng(Integer.toString(randomNumber));
            session.setAttribute(this.CAPTCHA_ATTRIBUTE_TEXT, captcha);
            session.setAttribute(this.CAPTCHA_ANSWER_ATTRIBUTE_TEXT, Integer.toString(randomNumber));
        } else {
            captcha = (byte[]) session.getAttribute(this.CAPTCHA_ATTRIBUTE_TEXT);
        }

        response.setContentType("text/html");
        try (Writer writer = response.getWriter()) {
            String html = String.format("""
                    <main style="height: 100%s; min-width: 400px; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                        <img width=180 height=90 src=data:image/png;base64,%s>
                        <form action="/captcha/check" method="post">
                             <label for="captcha_input">Enter number:</label>
                             <input name=%s id="captcha_input autofocus">
                        </form>
                        <form action="/captcha/refresh" method="post">
                            <button>Refresh</button>
                        </form>
                    </main>
                    """, "%", Base64.getEncoder().encodeToString(captcha), this.CAPTCHA_USER_ANSWER_PARAMETER_TEXT);
            writer.write(html);
            writer.flush();
        }
    }
}
