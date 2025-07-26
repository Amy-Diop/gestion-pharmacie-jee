package com.gestionpharmacie.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root"; // Ton user MySQL
    private static final String JDBC_PASS = "";     // Ton mot de passe MySQL

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                // Créer une session
                HttpSession session = req.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                // Rediriger selon le rôle
                switch (role) {
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
                        resp.getWriter().println("Rôle inconnu !");
                        break;
                }
            } else {
                resp.getWriter().println("<h1 style='color:red;'> Nom d'utilisateur ou mot de passe incorrect.</h1>");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h1 style='color:red;'>Erreur serveur : " + e.getMessage() + "</h1>");
        }
    }
}
