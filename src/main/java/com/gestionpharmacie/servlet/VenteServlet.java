package com.gestionpharmacie.servlet;

import com.gestionpharmacie.model.Vente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ventes")
public class VenteServlet extends HttpServlet {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "insert":
                    insertVente(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateVente(request, response);
                    break;
                case "delete":
                    deleteVente(request, response);
                    break;
                default:
                    listVentes(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // Liste toutes les ventes
    private void listVentes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Vente> ventes = new ArrayList<>();
        List<String> medicamentsNoms = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             Statement stmt = conn.createStatement()) {

            String sql = "SELECT v.id, v.medicament_id, v.quantite, v.total, v.date_vente, m.nom AS medicament_nom " +
                    "FROM ventes v JOIN medicaments m ON v.medicament_id = m.id ORDER BY v.date_vente DESC";
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Vente v = new Vente();
                v.setId(rs.getInt("id"));
                v.setMedicamentId(rs.getInt("medicament_id"));
                v.setQuantite(rs.getInt("quantite"));
                v.setTotal(rs.getDouble("total"));
                v.setDateVente(rs.getDate("date_vente"));

                ventes.add(v);
                medicamentsNoms.add(rs.getString("medicament_nom"));
            }
        }

        request.setAttribute("ventes", ventes);
        request.setAttribute("medicamentsNoms", medicamentsNoms);
        RequestDispatcher dispatcher = request.getRequestDispatcher("liste-ventes.jsp");
        dispatcher.forward(request, response);
    }

    // Affiche le formulaire pour une nouvelle vente
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<String[]> medicaments = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SELECT id, nom FROM medicaments ORDER BY nom ASC");
            while (rs.next()) {
                medicaments.add(new String[]{ String.valueOf(rs.getInt("id")), rs.getString("nom") });
            }
        }
        request.setAttribute("medicaments", medicaments);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ajouter-vente.jsp");
        dispatcher.forward(request, response);
    }

    // Insert une nouvelle vente
    private void insertVente(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int medicamentId = Integer.parseInt(request.getParameter("medicament_id"));
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        Date dateVente = Date.valueOf(request.getParameter("date_vente"));

        double prixUnitaire = 0;
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement("SELECT prix FROM medicaments WHERE id = ?")) {
            ps.setInt(1, medicamentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                prixUnitaire = rs.getDouble("prix");
            }
        }

        double total = prixUnitaire * quantite;

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO ventes (medicament_id, quantite, total, date_vente) VALUES (?, ?, ?, ?)")) {
            ps.setInt(1, medicamentId);
            ps.setInt(2, quantite);
            ps.setDouble(3, total);
            ps.setDate(4, dateVente);
            ps.executeUpdate();
        }
        response.sendRedirect("ventes");
    }

    // Affiche le formulaire de modification d'une vente
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Vente vente = null;
        List<String[]> medicaments = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS)) {
            // Récupérer vente
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM ventes WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                vente = new Vente();
                vente.setId(rs.getInt("id"));
                vente.setMedicamentId(rs.getInt("medicament_id"));
                vente.setQuantite(rs.getInt("quantite"));
                vente.setTotal(rs.getDouble("total"));
                vente.setDateVente(rs.getDate("date_vente"));
            }

            // Récupérer tous les médicaments
            Statement stmt = conn.createStatement();
            ResultSet rs2 = stmt.executeQuery("SELECT id, nom FROM medicaments ORDER BY nom ASC");
            while (rs2.next()) {
                medicaments.add(new String[]{ String.valueOf(rs2.getInt("id")), rs2.getString("nom") });
            }
        }

        request.setAttribute("vente", vente);
        request.setAttribute("medicaments", medicaments);
        RequestDispatcher dispatcher = request.getRequestDispatcher("modifier-vente.jsp");
        dispatcher.forward(request, response);
    }

    // Met à jour une vente
    private void updateVente(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int medicamentId = Integer.parseInt(request.getParameter("medicament_id"));
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        Date dateVente = Date.valueOf(request.getParameter("date_vente"));

        double prixUnitaire = 0;
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement("SELECT prix FROM medicaments WHERE id = ?")) {
            ps.setInt(1, medicamentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                prixUnitaire = rs.getDouble("prix");
            }
        }

        double total = prixUnitaire * quantite;

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE ventes SET medicament_id = ?, quantite = ?, total = ?, date_vente = ? WHERE id = ?")) {
            ps.setInt(1, medicamentId);
            ps.setInt(2, quantite);
            ps.setDouble(3, total);
            ps.setDate(4, dateVente);
            ps.setInt(5, id);
            ps.executeUpdate();
        }
        response.sendRedirect("ventes");
    }

    // Supprime une vente
    private void deleteVente(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
             PreparedStatement ps = conn.prepareStatement("DELETE FROM ventes WHERE id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
        response.sendRedirect("ventes");
    }
}
