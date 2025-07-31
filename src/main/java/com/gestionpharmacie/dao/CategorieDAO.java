package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Categorie;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategorieDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String SELECT_ALL_CATEGORIES = "SELECT * FROM categories ORDER BY nom";
    private static final String SELECT_CATEGORIE_BY_ID = "SELECT * FROM categories WHERE id = ?";
    private static final String SEARCH_CATEGORIES = "SELECT * FROM categories WHERE nom LIKE ? OR description LIKE ? ORDER BY nom";
    private static final String INSERT_CATEGORIE = "INSERT INTO categories (nom, description) VALUES (?, ?)";
    private static final String UPDATE_CATEGORIE = "UPDATE categories SET nom = ?, description = ? WHERE id = ?";
    private static final String DELETE_CATEGORIE = "DELETE FROM categories WHERE id = ?";

    public CategorieDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public List<Categorie> listerCategories() throws SQLException {
        List<Categorie> categories = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_CATEGORIES);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Categorie categorie = new Categorie();
                categorie.setId(rs.getInt("id"));
                categorie.setNom(rs.getString("nom"));
                categorie.setDescription(rs.getString("description"));
                categories.add(categorie);
            }
        }
        return categories;
    }

    public List<Categorie> rechercherCategories(String recherche) throws SQLException {
        List<Categorie> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(m.id) as nombre_medicaments FROM categories c LEFT JOIN medicaments m ON c.id = m.categorie_id AND m.actif = 1 WHERE c.nom LIKE ? OR c.description LIKE ? GROUP BY c.id, c.nom, c.description ORDER BY c.nom";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String searchPattern = "%" + recherche + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Categorie categorie = new Categorie();
                    categorie.setId(rs.getInt("id"));
                    categorie.setNom(rs.getString("nom"));
                    categorie.setDescription(rs.getString("description"));
                    categorie.setNombreMedicaments(rs.getInt("nombre_medicaments"));
                    categories.add(categorie);
                }
            }
        }
        return categories;
    }

    public Categorie getCategorieById(int id) throws SQLException {
        Categorie categorie = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_CATEGORIE_BY_ID)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    categorie = new Categorie();
                    categorie.setId(rs.getInt("id"));
                    categorie.setNom(rs.getString("nom"));
                    categorie.setDescription(rs.getString("description"));
                }
            }
        }
        return categorie;
    }

    public void ajouterCategorie(Categorie categorie) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_CATEGORIE)) {
            statement.setString(1, categorie.getNom());
            statement.setString(2, categorie.getDescription());
            statement.executeUpdate();
        }
    }

    public boolean modifierCategorie(Categorie categorie) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_CATEGORIE)) {
            statement.setString(1, categorie.getNom());
            statement.setString(2, categorie.getDescription());
            statement.setInt(3, categorie.getId());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public boolean supprimerCategorie(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_CATEGORIE)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public List<Categorie> listerCategoriesAvecNombreMedicaments() throws SQLException {
        List<Categorie> categories = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(m.id) as nombre_medicaments FROM categories c LEFT JOIN medicaments m ON c.id = m.categorie_id AND m.actif = 1 GROUP BY c.id, c.nom, c.description ORDER BY c.nom";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Categorie categorie = new Categorie();
                categorie.setId(rs.getInt("id"));
                categorie.setNom(rs.getString("nom"));
                categorie.setDescription(rs.getString("description"));
                categorie.setNombreMedicaments(rs.getInt("nombre_medicaments"));
                categories.add(categorie);
            }
        }
        return categories;
    }
}