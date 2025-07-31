package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Ordonnance;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdonnanceDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    public OrdonnanceDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public int ajouterOrdonnance(Ordonnance ordonnance) throws SQLException {
        String sql = "INSERT INTO ordonnances (numero, patient_nom, medecin_nom, date_ordonnance, statut, notes, pharmacien) VALUES (?, ?, ?, NOW(), ?, ?, ?)";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, "ORD-" + System.currentTimeMillis());
            statement.setString(2, ordonnance.getPatientNom());
            statement.setString(3, ordonnance.getMedecinNom());
            statement.setString(4, ordonnance.getStatut());
            statement.setString(5, ordonnance.getNotes());
            statement.setString(6, ordonnance.getPharmacien());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Échec de la création de l'ordonnance");
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Échec de la création de l'ordonnance, aucun ID généré");
                }
            }
        }
    }

    public void ajouterDetailOrdonnance(int ordonnanceId, int medicamentId, int quantite, String duree) throws SQLException {
        String sql = "INSERT INTO ordonnance_details (ordonnance_id, medicament_id, quantite, duree_traitement) VALUES (?, ?, ?, ?)";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, ordonnanceId);
            statement.setInt(2, medicamentId);
            statement.setInt(3, quantite);
            statement.setString(4, duree);
            statement.executeUpdate();
        }
    }

    public List<Ordonnance> listerOrdonnances() throws SQLException {
        List<Ordonnance> ordonnances = new ArrayList<>();
        try {
            String sql = "SELECT * FROM ordonnances ORDER BY id ASC";
            
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Ordonnance ordonnance = new Ordonnance();
                    ordonnance.setId(rs.getInt("id"));
                    ordonnance.setNumero(rs.getString("numero"));
                    ordonnance.setPatientNom(rs.getString("patient_nom"));
                    ordonnance.setMedecinNom(rs.getString("medecin_nom"));
                    ordonnance.setDateOrdonnance(rs.getTimestamp("date_ordonnance"));
                    ordonnance.setStatut(rs.getString("statut"));
                    ordonnance.setNotes(rs.getString("notes"));
                    ordonnance.setPharmacien(rs.getString("pharmacien"));
                    ordonnances.add(ordonnance);
                }
            }
        } catch (SQLException e) {
            System.out.println("Table ordonnances non trouvée, retour de liste vide");
        }
        return ordonnances;
    }

    public void validerOrdonnance(int id) throws SQLException {
        try {
            String sql = "UPDATE ordonnances SET statut = 'VALIDEE' WHERE id = ?";
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setInt(1, id);
                statement.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println("Erreur lors de la validation de l'ordonnance: " + e.getMessage());
        }
    }
}