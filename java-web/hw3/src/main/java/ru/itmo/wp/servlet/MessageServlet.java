package ru.itmo.wp.servlet;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MessageServlet extends HttpServlet {

    private List<Map<String, String>> textHistory = new ArrayList<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession curSession = request.getSession();
        String uri = request.getRequestURI();
        Object returnJSONObject = null;

        if (uri.equals("/message/auth")) {
            String name = request.getParameter("user");
            if (name == null) {
                name = "";
            }
            name = name.trim();

            if (!name.isBlank()) {
                returnJSONObject = name;
                if (curSession.getAttribute("user") == null) {
                    curSession.setAttribute("user", name);
                }
            }
        } else if (uri.equals("/message/findAll")) {
            if (curSession.getAttribute("user") != null) {
                returnJSONObject = this.textHistory;
            }
        } else if (uri.equals("/message/add")) {
            String text = request.getParameter("text");
            if (!text.isBlank()) {
                this.textHistory.add(Map.of(
                        "user", (String) curSession.getAttribute("user"),
                        "text", text
                ));
                returnJSONObject = text;
            }
        }

        Gson json = new Gson();
        try (Writer writer = response.getWriter()) {
            writer.write(json.toJson(returnJSONObject));
            writer.flush();
        }
        response.setContentType("application/json");
    }
}
