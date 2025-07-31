package com.gestionpharmacie.dao;

import com.gestionpharmacie.model.Rapport;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class RapportDAO {
    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db?useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    public RapportDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur de chargement du driver JDBC : " + e.getMessage());
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public Map<String, Object> genererRapportVentes(Date dateDebut, Date dateFin) throws SQLException {
        Map<String, Object> rapport = new HashMap<>();
        
        try (Connection connection = getConnection()) {
            // Total des ventes
            String sqlTotal = "SELECT COUNT(*) as nombre_ventes, SUM(montant_total) as chiffre_affaires FROM ventes WHERE date_vente BETWEEN ? AND ?";
            try (PreparedStatement stmt = connection.prepareStatement(sqlTotal)) {
                stmt.setTimestamp(1, new Timestamp(dateDebut.getTime()));
                stmt.setTimestamp(2, new Timestamp(dateFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        rapport.put("nombreVentes", rs.getInt("nombre_ventes"));
                        rapport.put("chiffreAffaires", rs.getDouble("chiffre_affaires"));
                    }
                }
            }

            // Ventes par jour
            String sqlParJour = "SELECT DATE(date_vente) as jour, COUNT(*) as ventes, SUM(montant_total) as ca FROM ventes WHERE date_vente BETWEEN ? AND ? GROUP BY DATE(date_vente) ORDER BY jour";
            try (PreparedStatement stmt = connection.prepareStatement(sqlParJour)) {
                stmt.setTimestamp(1, new Timestamp(dateDebut.getTime()));
                stmt.setTimestamp(2, new Timestamp(dateFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    Map<String, Map<String, Object>> ventesParJour = new HashMap<>();
                    while (rs.next()) {
                        Map<String, Object> donneeJour = new HashMap<>();
                        donneeJour.put("ventes", rs.getInt("ventes"));
                        donneeJour.put("ca", rs.getDouble("ca"));
                        ventesParJour.put(rs.getString("jour"), donneeJour);
                    }
                    rapport.put("ventesParJour", ventesParJour);
                }
            }

            // Top vendeurs
            String sqlVendeurs = "SELECT vendeur, COUNT(*) as ventes, SUM(montant_total) as ca FROM ventes WHERE date_vente BETWEEN ? AND ? GROUP BY vendeur ORDER BY ca DESC LIMIT 5";
            try (PreparedStatement stmt = connection.prepareStatement(sqlVendeurs)) {
                stmt.setTimestamp(1, new Timestamp(dateDebut.getTime()));
                stmt.setTimestamp(2, new Timestamp(dateFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    Map<String, Map<String, Object>> topVendeurs = new HashMap<>();
                    while (rs.next()) {
                        Map<String, Object> donneeVendeur = new HashMap<>();
                        donneeVendeur.put("ventes", rs.getInt("ventes"));
                        donneeVendeur.put("ca", rs.getDouble("ca"));
                        topVendeurs.put(rs.getString("vendeur"), donneeVendeur);
                    }
                    rapport.put("topVendeurs", topVendeurs);
                }
            }
        }
        
        return rapport;
    }

    public Map<String, Object> genererRapportStock() throws SQLException {
        Map<String, Object> rapport = new HashMap<>();
        
        try (Connection connection = getConnection()) {
            // Stock total
            String sqlStock = "SELECT COUNT(*) as nombre_medicaments, SUM(quantite) as stock_total FROM medicaments WHERE actif = 1";
            try (PreparedStatement stmt = connection.prepareStatement(sqlStock)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        rapport.put("nombreMedicaments", rs.getInt("nombre_medicaments"));
                        rapport.put("stockTotal", rs.getInt("stock_total"));
                    }
                }
            }

            // Alertes stock
            String sqlAlertes = "SELECT COUNT(*) as alertes_critiques FROM medicaments WHERE quantite <= seuil_alerte AND actif = 1";
            try (PreparedStatement stmt = connection.prepareStatement(sqlAlertes)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        rapport.put("alertesCritiques", rs.getInt("alertes_critiques"));
                    }
                }
            }

            // Stock par catégorie
            String sqlCategories = "SELECT c.nom as categorie, COUNT(m.id) as nombre, SUM(m.quantite) as stock FROM categories c LEFT JOIN medicaments m ON c.id = m.categorie_id WHERE m.actif = 1 GROUP BY c.id, c.nom";
            try (PreparedStatement stmt = connection.prepareStatement(sqlCategories)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    Map<String, Map<String, Object>> stockParCategorie = new HashMap<>();
                    while (rs.next()) {
                        Map<String, Object> donneeCategorie = new HashMap<>();
                        donneeCategorie.put("nombre", rs.getInt("nombre"));
                        donneeCategorie.put("stock", rs.getInt("stock"));
                        stockParCategorie.put(rs.getString("categorie"), donneeCategorie);
                    }
                    rapport.put("stockParCategorie", stockParCategorie);
                }
            }
        }
        
        return rapport;
    }

    public Map<String, Object> genererRapportClients() throws SQLException {
        Map<String, Object> rapport = new HashMap<>();
        
        try (Connection connection = getConnection()) {
            // Total clients
            String sqlTotal = "SELECT COUNT(*) as total_clients FROM clients WHERE actif = 1";
            try (PreparedStatement stmt = connection.prepareStatement(sqlTotal)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        rapport.put("totalClients", rs.getInt("total_clients"));
                    }
                }
            }

            // Nouveaux clients par mois
            String sqlNouveaux = "SELECT YEAR(date_inscription) as annee, MONTH(date_inscription) as mois, COUNT(*) as nouveaux FROM clients WHERE actif = 1 GROUP BY YEAR(date_inscription), MONTH(date_inscription) ORDER BY annee DESC, mois DESC LIMIT 12";
            try (PreparedStatement stmt = connection.prepareStatement(sqlNouveaux)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    Map<String, Integer> nouveauxParMois = new HashMap<>();
                    while (rs.next()) {
                        String cle = rs.getInt("annee") + "-" + String.format("%02d", rs.getInt("mois"));
                        nouveauxParMois.put(cle, rs.getInt("nouveaux"));
                    }
                    rapport.put("nouveauxParMois", nouveauxParMois);
                }
            }
        }
        
        return rapport;
    }

    public Map<String, Object> genererRapportFinancier(Date dateDebut, Date dateFin) throws SQLException {
        Map<String, Object> rapport = new HashMap<>();
        
        try (Connection connection = getConnection()) {
            // Chiffre d'affaires
            String sqlCA = "SELECT SUM(montant_total) as ca_total, AVG(montant_total) as ca_moyen FROM ventes WHERE date_vente BETWEEN ? AND ?";
            try (PreparedStatement stmt = connection.prepareStatement(sqlCA)) {
                stmt.setTimestamp(1, new Timestamp(dateDebut.getTime()));
                stmt.setTimestamp(2, new Timestamp(dateFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        rapport.put("caTotal", rs.getDouble("ca_total"));
                        rapport.put("caMoyen", rs.getDouble("ca_moyen"));
                    }
                }
            }

            // Répartition par mode de paiement
            String sqlPaiement = "SELECT mode_paiement, COUNT(*) as nombre, SUM(montant_total) as montant FROM ventes WHERE date_vente BETWEEN ? AND ? GROUP BY mode_paiement";
            try (PreparedStatement stmt = connection.prepareStatement(sqlPaiement)) {
                stmt.setTimestamp(1, new Timestamp(dateDebut.getTime()));
                stmt.setTimestamp(2, new Timestamp(dateFin.getTime()));
                try (ResultSet rs = stmt.executeQuery()) {
                    Map<String, Map<String, Object>> paiements = new HashMap<>();
                    while (rs.next()) {
                        Map<String, Object> donneePaiement = new HashMap<>();
                        donneePaiement.put("nombre", rs.getInt("nombre"));
                        donneePaiement.put("montant", rs.getDouble("montant"));
                        paiements.put(rs.getString("mode_paiement"), donneePaiement);
                    }
                    rapport.put("repartitionPaiements", paiements);
                }
            }
        }
        
        return rapport;
    }
}