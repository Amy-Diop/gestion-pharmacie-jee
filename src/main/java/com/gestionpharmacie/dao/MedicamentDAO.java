package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Medicament;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicamentDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String SELECT_ALL_MEDICAMENTS = "SELECT m.*, c.nom as categorie_nom, f.nom as fournisseur_nom FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id LEFT JOIN fournisseur f ON m.fournisseur_id = f.id WHERE m.actif = 1 ORDER BY m.id";
    private static final String SELECT_MEDICAMENT_BY_ID = "SELECT m.*, c.nom as categorie_nom, f.nom as fournisseur_nom FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id LEFT JOIN fournisseur f ON m.fournisseur_id = f.id WHERE m.id = ?";
    private static final String SEARCH_MEDICAMENTS = "SELECT m.*, c.nom as categorie_nom, f.nom as fournisseur_nom FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id LEFT JOIN fournisseur f ON m.fournisseur_id = f.id WHERE m.actif = 1 AND (m.nom LIKE ? OR m.description LIKE ? OR c.nom LIKE ?) ORDER BY m.nom";
    private static final String SELECT_ALERTES_STOCK = "SELECT m.*, c.nom as categorie_nom, f.nom as fournisseur_nom FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id LEFT JOIN fournisseur f ON m.fournisseur_id = f.id WHERE m.actif = 1 AND (m.stock <= m.seuil_alerte OR m.stock = 0) ORDER BY m.stock ASC";
    private static final String SELECT_MEDICAMENTS_PEREMPTION = "SELECT m.*, c.nom as categorie_nom, f.nom as fournisseur_nom FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id LEFT JOIN fournisseur f ON m.fournisseur_id = f.id WHERE m.actif = 1 AND m.date_expiration IS NOT NULL ORDER BY m.date_expiration ASC";
    private static final String INSERT_MEDICAMENT = "INSERT INTO medicaments (nom, description, prix, stock, seuil_alerte, date_expiration, categorie_id, fournisseur_id, actif) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_MEDICAMENT = "UPDATE medicaments SET nom = ?, description = ?, prix = ?, stock = ?, seuil_alerte = ?, date_expiration = ?, categorie_id = ?, fournisseur_id = ? WHERE id = ?";
    private static final String DELETE_MEDICAMENT = "UPDATE medicaments SET actif = 0 WHERE id = ?";

    public MedicamentDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public List<Medicament> listerMedicaments() throws SQLException {
        List<Medicament> medicaments = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_MEDICAMENTS);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                medicaments.add(mapMedicament(rs));
            }
        }
        return medicaments;
    }

    public Medicament getMedicamentById(int id) throws SQLException {
        Medicament medicament = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_MEDICAMENT_BY_ID)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    medicament = mapMedicament(rs);
                }
            }
        }
        return medicament;
    }

    public List<Medicament> getMedicamentsAlertes() throws SQLException {
        List<Medicament> medicaments = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALERTES_STOCK);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                medicaments.add(mapMedicament(rs));
            }
        }
        return medicaments;
    }

    public void ajouterMedicament(Medicament medicament) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_MEDICAMENT)) {
            statement.setString(1, medicament.getNom());
            statement.setString(2, medicament.getDescription());
            statement.setDouble(3, medicament.getPrix());
            statement.setInt(4, medicament.getStock());
            statement.setInt(5, medicament.getSeuilAlerte());
            if (medicament.getDateExpiration() != null) {
                statement.setDate(6, new java.sql.Date(medicament.getDateExpiration().getTime()));
            } else {
                statement.setNull(6, java.sql.Types.DATE);
            }
            if (medicament.getCategorieId() > 0) {
                statement.setInt(7, medicament.getCategorieId());
            } else {
                statement.setNull(7, java.sql.Types.INTEGER);
            }
            if (medicament.getFournisseurId() > 0) {
                statement.setInt(8, medicament.getFournisseurId());
            } else {
                statement.setNull(8, java.sql.Types.INTEGER);
            }
            statement.setBoolean(9, true);
            statement.executeUpdate();
        }
    }

    public boolean modifierMedicament(Medicament medicament) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_MEDICAMENT)) {
            statement.setString(1, medicament.getNom());
            statement.setString(2, medicament.getDescription());
            statement.setDouble(3, medicament.getPrix());
            statement.setInt(4, medicament.getStock());
            statement.setInt(5, medicament.getSeuilAlerte());
            if (medicament.getDateExpiration() != null) {
                statement.setDate(6, new java.sql.Date(medicament.getDateExpiration().getTime()));
            } else {
                statement.setNull(6, java.sql.Types.DATE);
            }
            if (medicament.getCategorieId() > 0) {
                statement.setInt(7, medicament.getCategorieId());
            } else {
                statement.setNull(7, java.sql.Types.INTEGER);
            }
            if (medicament.getFournisseurId() > 0) {
                statement.setInt(8, medicament.getFournisseurId());
            } else {
                statement.setNull(8, java.sql.Types.INTEGER);
            }
            statement.setInt(9, medicament.getId());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public boolean supprimerMedicament(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_MEDICAMENT)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    private Medicament mapMedicament(ResultSet rs) throws SQLException {
        Medicament medicament = new Medicament();
        medicament.setId(rs.getInt("id"));
        medicament.setNom(rs.getString("nom"));
        medicament.setDescription(rs.getString("description"));
        medicament.setPrix(rs.getDouble("prix"));
        medicament.setStock(rs.getInt("stock"));
        medicament.setSeuilAlerte(rs.getInt("seuil_alerte"));
        medicament.setDateExpiration(rs.getDate("date_expiration"));
        medicament.setCategorieId(rs.getInt("categorie_id"));
        medicament.setFournisseurId(rs.getInt("fournisseur_id"));
        medicament.setActif(rs.getBoolean("actif"));
        medicament.setDateCreation(rs.getTimestamp("date_creation"));
        
        // Ajouter le nom de la catégorie
        try {
            medicament.setCategorieNom(rs.getString("categorie_nom"));
        } catch (SQLException e) {
            medicament.setCategorieNom(null);
        }
        // Ajouter le nom du fournisseur
        try {
            medicament.setFournisseurNom(rs.getString("fournisseur_nom"));
        } catch (SQLException e) {
            medicament.setFournisseurNom(null);
        }
        
        return medicament;
    }

    public List<Medicament> getMedicamentsPeremption() throws SQLException {
        List<Medicament> medicaments = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_MEDICAMENTS_PEREMPTION);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                medicaments.add(mapMedicament(rs));
            }
        }
        return medicaments;
    }

    public List<Medicament> rechercherMedicaments(String recherche) throws SQLException {
        List<Medicament> medicaments = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SEARCH_MEDICAMENTS)) {
            String searchPattern = "%" + recherche + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            statement.setString(3, searchPattern);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    medicaments.add(mapMedicament(rs));
                }
            }
        }
        return medicaments;
    }

    public void mettreAJourStock(int medicamentId, int nouveauStock) throws SQLException {
        String sql = "UPDATE medicaments SET stock = ? WHERE id = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, nouveauStock);
            statement.setInt(2, medicamentId);
            statement.executeUpdate();
        }
    }
}