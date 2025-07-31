package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Utilisateur;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    private static final String INSERT_USER = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
    private static final String SELECT_USER_BY_ID = "SELECT * FROM users WHERE id = ?";
    private static final String SELECT_ALL_USERS = "SELECT * FROM users ORDER BY id";
    private static final String SELECT_USER_LOGIN = "SELECT * FROM users WHERE username = ? AND password = ?";
    private static final String UPDATE_USER = "UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?";
    private static final String DELETE_USER = "DELETE FROM users WHERE id = ?";
    private static final String CHECK_USERNAME = "SELECT COUNT(*) FROM users WHERE username = ? AND id != ?";

    public UtilisateurDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public void ajouterUtilisateur(Utilisateur utilisateur) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_USER)) {
            statement.setString(1, utilisateur.getUsername());
            statement.setString(2, utilisateur.getPassword());
            statement.setString(3, utilisateur.getRole());
            statement.executeUpdate();
        }
    }

    public Utilisateur getUtilisateurById(int id) throws SQLException {
        Utilisateur utilisateur = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_USER_BY_ID)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    utilisateur = mapUtilisateur(rs);
                }
            }
        }
        return utilisateur;
    }

    public List<Utilisateur> listerUtilisateurs() throws SQLException {
        List<Utilisateur> utilisateurs = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                utilisateurs.add(mapUtilisateur(rs));
            }
        }
        return utilisateurs;
    }

    public Utilisateur authentifier(String username, String password) throws SQLException {
        Utilisateur utilisateur = null;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_USER_LOGIN)) {
            statement.setString(1, username);
            statement.setString(2, password);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    utilisateur = mapUtilisateur(rs);
                }
            }
        }
        return utilisateur;
    }

    public boolean modifierUtilisateur(Utilisateur utilisateur) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_USER)) {
            statement.setString(1, utilisateur.getUsername());
            statement.setString(2, utilisateur.getPassword());
            statement.setString(3, utilisateur.getRole());
            statement.setInt(4, utilisateur.getId());
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public boolean supprimerUtilisateur(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_USER)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    public boolean usernameExiste(String username, int excludeId) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(CHECK_USERNAME)) {
            statement.setString(1, username);
            statement.setInt(2, excludeId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public List<Utilisateur> rechercherUtilisateurs(String recherche) throws SQLException {
        List<Utilisateur> utilisateurs = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE username LIKE ? OR role LIKE ? ORDER BY username";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            String searchPattern = "%" + recherche + "%";
            statement.setString(1, searchPattern);
            statement.setString(2, searchPattern);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    utilisateurs.add(mapUtilisateur(rs));
                }
            }
        }
        return utilisateurs;
    }

    private Utilisateur mapUtilisateur(ResultSet rs) throws SQLException {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setId(rs.getInt("id"));
        utilisateur.setUsername(rs.getString("username"));
        utilisateur.setPassword(rs.getString("password"));
        utilisateur.setRole(rs.getString("role"));
        return utilisateur;
    }
}