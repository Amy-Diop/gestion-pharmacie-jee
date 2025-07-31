package com.gestionpharmacie.dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class StatistiqueDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    public StatistiqueDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public int getNombreMedicaments() throws SQLException {
        String sql = "SELECT COUNT(*) FROM medicaments WHERE actif = 1";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getNombreVentes() throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM ventes WHERE statut = 'PAYEE'";
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Table ventes non trouvée, retour de 0");
            return 0;
        }
        return 0;
    }

    public int getNombreCategories() throws SQLException {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getNombreAlertes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM medicaments WHERE actif = 1 AND (stock <= seuil_alerte OR stock = 0)";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getChiffreAffaires() throws SQLException {
        try {
            String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes WHERE statut = 'PAYEE'";
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Table ventes non trouvée, retour de 0.0");
            return 0.0;
        }
        return 0.0;
    }

    public Map<String, Double> getVentesParJour() throws SQLException {
        Map<String, Double> ventesParJour = new HashMap<>();
        try {
            String sql = "SELECT DAYNAME(date_vente) as jour, COALESCE(SUM(montant_total), 0) as montant FROM ventes WHERE statut = 'PAYEE' AND date_vente >= DATE_SUB(NOW(), INTERVAL 7 DAY) GROUP BY DAYNAME(date_vente), DAYOFWEEK(date_vente) ORDER BY DAYOFWEEK(date_vente)";
            
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    String jour = rs.getString("jour");
                    double montant = rs.getDouble("montant");
                    ventesParJour.put(jour, montant);
                }
            }
        } catch (SQLException e) {
            System.out.println("Table ventes non trouvée ou vide, retour de map vide");
        }
        return ventesParJour;
    }

    public Map<String, Integer> getMedicamentsParCategorie() throws SQLException {
        Map<String, Integer> medicamentsParCategorie = new HashMap<>();
        String sql = "SELECT c.nom as categorie, COUNT(m.id) as nombre FROM medicaments m LEFT JOIN categories c ON m.categorie_id = c.id WHERE m.actif = 1 GROUP BY c.nom ORDER BY nombre DESC LIMIT 5";
        
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                String categorie = rs.getString("categorie");
                if (categorie == null) categorie = "Sans catégorie";
                int nombre = rs.getInt("nombre");
                medicamentsParCategorie.put(categorie, nombre);
            }
        }
        return medicamentsParCategorie;
    }

    public int getMedicamentsEnRupture() throws SQLException {
        String sql = "SELECT COUNT(*) FROM medicaments WHERE actif = 1 AND stock = 0";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getMedicamentsPerimes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM medicaments WHERE actif = 1 AND date_expiration < CURDATE()";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getChiffresAffairesHebdomadaire() throws SQLException {
        String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes WHERE statut = 'PAYEE' AND date_vente >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public double getChiffresAffairesMensuel() throws SQLException {
        String sql = "SELECT COALESCE(SUM(montant_total), 0) FROM ventes WHERE statut = 'PAYEE' AND date_vente >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public int getNombreUtilisateurs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getNombreFournisseurs() throws SQLException {
        try {
            String sql = "SELECT COUNT(*) FROM fournisseur";
            try (Connection connection = getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql);
                 ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            // Table fournisseurs n'existe pas encore
            System.out.println("Table fournisseurs non trouvée, retour de 0");
            return 0;
        }
        return 0;
    }
}