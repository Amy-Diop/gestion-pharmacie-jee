package com.gestionpharmacie.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            String role = rs.getString("role");

                            HttpSession session = req.getSession();
                            session.setAttribute("username", username);
                            session.setAttribute("role", role);

                            switch (role.toUpperCase()) {
                                case "ADMIN":
                                    resp.sendRedirect("admin-dashboard.jsp");
                                    break;
                                case "PHARMACIEN":
                                    resp.sendRedirect("pharmacien-dashboard.jsp");
                                    break;
                                case "ASSISTANT":
                                    resp.sendRedirect("assistant-dashboard.jsp");
                                    break;
                                default:
                                    resp.sendRedirect("access-denied.jsp");
                                    break;
                            }
                        } else {
                            req.setAttribute("error", "Nom d'utilisateur ou mot de passe incorrect.");
                            req.getRequestDispatcher("login.jsp").forward(req, resp);
                        }
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            req.setAttribute("error", "Pilote JDBC introuvable.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur base de données : " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur interne du serveur : " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
