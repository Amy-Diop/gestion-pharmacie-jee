package com.gestionpharmacie.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root"; // ton utilisateur MySQL
    private static final String JDBC_PASS = "";     // ton mot de passe MySQL

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
                // Authentification réussie
                resp.getWriter().println("<h1 style='color:green;'>Connexion réussie : Bienvenue " + rs.getString("role") + " !</h1>");
            } else {
                // Authentification échouée
                resp.getWriter().println("<h1 style='color:red;'> Nom d'utilisateur ou mot de passe incorrect.</h1>");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h1 style='color:red;'>Erreur serveur : " + e.getMessage() + "</h1>");
        }
    }
}
