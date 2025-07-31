package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Vente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VenteDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    public VenteDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public int ajouterVente(Vente vente) throws SQLException {
        String sql = "INSERT INTO ventes (client_nom, vendeur, montant_total, montant_recu, monnaie, mode_paiement, statut, date_vente) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, vente.getClientNom());
            statement.setString(2, vente.getVendeur());
            statement.setDouble(3, vente.getMontantTotal());
            statement.setDouble(4, vente.getMontantRecu());
            statement.setDouble(5, vente.getMonnaie());
            statement.setString(6, vente.getModePaiement());
            statement.setString(7, vente.getStatut());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Échec de la création de la vente");
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Échec de la création de la vente, aucun ID généré");
                }
            }
        }
    }

    public void ajouterDetailVente(int venteId, int medicamentId, int quantite, double prixUnitaire, double sousTotal) throws SQLException {
        // Récupérer le nom du médicament
        String nomMedicament = "";
        String sqlNom = "SELECT nom FROM medicaments WHERE id = ?";
        try (Connection connection = getConnection();
             PreparedStatement stmtNom = connection.prepareStatement(sqlNom)) {
            stmtNom.setInt(1, medicamentId);
            try (ResultSet rs = stmtNom.executeQuery()) {
                if (rs.next()) {
                    nomMedicament = rs.getString("nom");
                }
            }
        }
        
        // Insérer dans vente_items
        String sql = "INSERT INTO vente_items (vente_id, medicament_id, medicament_nom, quantite, prix_unitaire, sous_total) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, venteId);
            statement.setInt(2, medicamentId);
            statement.setString(3, nomMedicament);
            statement.setInt(4, quantite);
            statement.setDouble(5, prixUnitaire);
            statement.setDouble(6, sousTotal);
            statement.executeUpdate();
        }
    }

    public List<Vente> listerVentes() throws SQLException {
        List<Vente> ventes = new ArrayList<>();
        String sql = "SELECT * FROM ventes ORDER BY id ASC";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Vente vente = new Vente();
                vente.setId(rs.getInt("id"));
                vente.setClientNom(rs.getString("client_nom"));
                vente.setVendeur(rs.getString("vendeur"));
                vente.setMontantTotal(rs.getDouble("montant_total"));
                vente.setMontantRecu(rs.getDouble("montant_recu"));
                vente.setMonnaie(rs.getDouble("monnaie"));
                vente.setModePaiement(rs.getString("mode_paiement"));
                vente.setStatut(rs.getString("statut"));
                vente.setDateVente(rs.getTimestamp("date_vente"));
                ventes.add(vente);
            }
        }
        return ventes;
    }
}