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

@WebServlet("/supprimer-medicament")
public class SupprimerMedicamentServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);

            String sql = "DELETE FROM medicaments WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);

            stmt.executeUpdate();

            conn.close();

            // Redirection vers la liste après suppression
            resp.sendRedirect("liste-medicaments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h1 style='color:red;'>Erreur lors de la suppression : " + e.getMessage() + "</h1>");
        }
    }
}
