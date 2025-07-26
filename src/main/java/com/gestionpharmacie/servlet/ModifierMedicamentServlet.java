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

@WebServlet("/modifier-medicament")
public class ModifierMedicamentServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Récupération des paramètres du formulaire
        int id = Integer.parseInt(req.getParameter("id"));
        String nom = req.getParameter("nom");
        double prix = Double.parseDouble(req.getParameter("prix"));
        int stock = Integer.parseInt(req.getParameter("stock"));
        String dateExpiration = req.getParameter("date_expiration");
        int categorieId = Integer.parseInt(req.getParameter("categorie_id")); // Catégorie sélectionnée

        try {
            // Chargement du driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connexion à la base
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
                // Requête SQL de mise à jour
                String sql = "UPDATE medicaments SET nom=?, prix=?, stock=?, date_expiration=?, categorie_id=? WHERE id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);

                stmt.setString(1, nom);
                stmt.setDouble(2, prix);
                stmt.setInt(3, stock);
                stmt.setString(4, dateExpiration);
                stmt.setInt(5, categorieId);
                stmt.setInt(6, id);

                stmt.executeUpdate();
            }
            // Redirection vers la liste des médicaments après modification
            resp.sendRedirect("liste-medicaments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("<h1 style='color:red;'>Erreur lors de la modification : " + e.getMessage() + "</h1>");
        }
    }
}
