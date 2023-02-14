package ru.itmo.wp.servlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

public class StaticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uries = request.getRequestURI();
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        try (OutputStream outputStream = response.getOutputStream()) {
            for (String curUri : uries.split("\\+")) {
                File file = new File(getServletContext().getRealPath("/src/main/webapp/static/" + curUri));
                file = file.isFile() ? file : new File(getServletContext().getRealPath("/static/" + curUri));

                if (file.isFile()) {
                    if (response.getContentType() == null) {
                        response.setContentType(getServletContext().getMimeType(file.getName()));
                    }
                    buf.write(Files.readAllBytes(file.toPath()));
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }

            outputStream.write(buf.toByteArray());
        }
    }
}
