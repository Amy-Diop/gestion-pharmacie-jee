package com.gestionpharmacie.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/ajouter-medicament")
public class AjouterMedicamentServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Récupération des paramètres du formulaire
        String nom = req.getParameter("nom");
        int categorieId = Integer.parseInt(req.getParameter("categorie_id")); // catégorie sélectionnée
        double prix = Double.parseDouble(req.getParameter("prix"));
        int stock = Integer.parseInt(req.getParameter("stock"));
        String dateExpiration = req.getParameter("date_expiration");

        try {
            // Chargement du driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connexion à la base de données
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
                // Préparation de la requête INSERT
                String sql = "INSERT INTO medicaments (nom, categorie_id, prix, stock, date_expiration) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, nom);
                stmt.setInt(2, categorieId);
                stmt.setDouble(3, prix);
                stmt.setInt(4, stock);
                stmt.setString(5, dateExpiration);

                // Exécution de la requête
                stmt.executeUpdate();
            }

            // Redirection vers la liste après ajout réussi
            resp.sendRedirect("liste-medicaments.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Affichage d'une erreur simple dans la page
            resp.getWriter().println("<h1 style='color:red;'>Erreur lors de l'ajout : " + e.getMessage() + "</h1>");
        }
    }
}
