package com.jdbcapp.servlet;

import com.jdbcapp.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

@WebServlet(urlPatterns = {"/register", "/login", "/logout"})
public class AuthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);

            if (session != null) {
                session.invalidate();
            }

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        } else {
            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if ("/register".equals(request.getServletPath())) {
            register(request, response);
        } else if ("/login".equals(request.getServletPath())) {
            login(request, response);
        }
    }

    private void register(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || name.isBlank() || name.length() > 100
                || email == null
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || password == null
                || password.length() < 8
                || password.length() > 72) {

            request.setAttribute("error",
                    "Enter a valid name, email and password (8–72 characters).");
            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "INSERT INTO users(full_name,email,password_hash) "
                   + "VALUES(?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, BCrypt.hashpw(password, BCrypt.gensalt()));

            ps.executeUpdate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?registered=1");

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                request.setAttribute("error",
                        "This email is already registered.");
            } else {
                log("Registration failed", e);
                request.setAttribute("error",
                        "Unable to register. Please try again.");
            }

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);
        }
    }

    private void login(HttpServletRequest request,
                       HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String sql = "SELECT user_id, full_name, password_hash "
                   + "FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1,
                    email == null ? "" : email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {

                if (password != null && password.length() <= 72
                        && rs.next()
                        && BCrypt.checkpw(
                                password, rs.getString("password_hash"))) {

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("user_id"));
                    session.setAttribute("userName", rs.getString("full_name"));

                    response.sendRedirect(
                            request.getContextPath() + "/employees");

                } else {
                    request.setAttribute("error",
                            "Invalid email or password.");
                    request.getRequestDispatcher("/login.jsp")
                           .forward(request, response);
                }
            }

        } catch (SQLException e) {
            log("Login failed", e);
            request.setAttribute("error",
                    "Unable to log in. Please try again.");
            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
        }
    }
}