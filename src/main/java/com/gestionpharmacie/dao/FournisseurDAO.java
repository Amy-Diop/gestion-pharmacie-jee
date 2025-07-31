package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Fournisseur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FournisseurDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String INSERT_FOURNISSEUR = "INSERT INTO fournisseur (nom, adresse, telephone, email, produits_fournis, numero_immatriculation, conditions_paiement, date_ajout) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
    private static final String SELECT_FOURNISSEUR_BY_ID = "SELECT * FROM fournisseur WHERE id = ?";
    private static final String SELECT_ALL_FOURNISSEURS = "SELECT * FROM fournisseur ORDER BY id";
    private static final String UPDATE_FOURNISSEUR = "UPDATE fournisseur SET nom = ?, adresse = ?, telephone = ?, email = ?, produits_fournis = ?, numero_immatriculation = ?, conditions_paiement = ? WHERE id = ?";
    private static final String DELETE_FOURNISSEUR = "DELETE FROM fournisseur WHERE id = ?";

    public FournisseurDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void ajouterFournisseur(Fournisseur fournisseur) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_FOURNISSEUR)) {
            statement.setString(1, fournisseur.getNom());
            statement.setString(2, fournisseur.getAdresse());
            statement.setString(3, fournisseur.getTelephone());
            statement.setString(4, fournisseur.getEmail());
            statement.setString(5, fournisseur.getProduitsFournis());
            statement.setString(6, fournisseur.getNumeroImmatriculation());
            statement.setString(7, fournisseur.getConditionsPaiement());
            statement.executeUpdate();
        }
    }

    public Fournisseur getFournisseurById(int id) throws SQLException {
        Fournisseur fournisseur = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_FOURNISSEUR_BY_ID)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    fournisseur = mapFournisseur(rs);
                }
            }
        }
        return fournisseur;
    }

    public List<Fournisseur> listerFournisseurs() throws SQLException {
        List<Fournisseur> fournisseurs = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_FOURNISSEURS);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                fournisseurs.add(mapFournisseur(rs));
            }
        }
        return fournisseurs;
    }

    public boolean modifierFournisseur(Fournisseur fournisseur) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_FOURNISSEUR)) {
            statement.setString(1, fournisseur.getNom());
            statement.setString(2, fournisseur.getAdresse());
            statement.setString(3, fournisseur.getTelephone());
            statement.setString(4, fournisseur.getEmail());
            statement.setString(5, fournisseur.getProduitsFournis());
            statement.setString(6, fournisseur.getNumeroImmatriculation());
            statement.setString(7, fournisseur.getConditionsPaiement());
            statement.setInt(8, fournisseur.getId());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public boolean supprimerFournisseur(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_FOURNISSEUR)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    private Fournisseur mapFournisseur(ResultSet rs) throws SQLException {
        Fournisseur fournisseur = new Fournisseur();
        fournisseur.setId(rs.getInt("id"));
        fournisseur.setNom(rs.getString("nom"));
        fournisseur.setAdresse(rs.getString("adresse"));
        fournisseur.setTelephone(rs.getString("telephone"));
        fournisseur.setEmail(rs.getString("email"));
        fournisseur.setDateAjout(rs.getTimestamp("date_ajout"));
        fournisseur.setProduitsFournis(rs.getString("produits_fournis"));
        fournisseur.setNumeroImmatriculation(rs.getString("numero_immatriculation"));
        fournisseur.setConditionsPaiement(rs.getString("conditions_paiement"));
        return fournisseur;
    }

    public List<Fournisseur> rechercherFournisseurs(String recherche) throws SQLException {
        List<Fournisseur> fournisseurs = new ArrayList<>();
        String sql = "SELECT * FROM fournisseur WHERE nom LIKE ? OR adresse LIKE ? OR email LIKE ? ORDER BY id";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String searchPattern = "%" + recherche + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            statement.setString(3, searchPattern);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    fournisseurs.add(mapFournisseur(rs));
                }
            }
        }
        return fournisseurs;
    }
}