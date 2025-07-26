<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 15:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role) && !"ASSISTANT".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String erreur = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacie_db", "root", "");
        String sql = "SELECT m.id, m.nom, c.nom AS categorie, m.prix, m.stock, m.date_expiration " +
                "FROM medicaments m " +
                "LEFT JOIN categories c ON m.categorie_id = c.id";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Médicaments</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px; }
        h1 { color: #2c3e50; text-align: center; }
        a.button {
            text-decoration: none;
            color: white;
            background: #27ae60;
            padding: 10px 15px;
            border-radius: 4px;
            display: inline-block;
            margin-bottom: 15px;
        }
        a.button:hover { background: #219150; }
        table {
            border-collapse: collapse;
            width: 100%;
            background: white;
            box-shadow: 0 0 10px #ccc;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #27ae60;
            color: white;
        }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .actions a {
            margin: 0 5px;
            padding: 5px 8px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
        }
        .actions a.edit { background: #f39c12; }
        .actions a.edit:hover { background: #d88d0a; }
        .actions a.delete { background: #e74c3c; }
        .actions a.delete:hover { background: #c0392b; }
        .actions span.locked {
            color: #aaa;
            font-style: italic;
            padding: 5px 8px;
            display: inline-block;
        }
    </style>
</head>
<body>
<h1>💊 Liste des Médicaments</h1>
<% if ("ADMIN".equals(role) || "PHARMACIEN".equals(role)) { %>
<a href="ajouter-medicament.jsp" class="button">➕ Ajouter un Médicament</a>
<% } %>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Catégorie</th>
        <th>Prix (FCFA)</th>
        <th>Stock</th>
        <th>Date Expiration</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        while (rs.next()) {
            int medId = rs.getInt("id");
            String medNom = rs.getString("nom");
            String medCategorie = rs.getString("categorie");
            double medPrix = rs.getDouble("prix");
            int medStock = rs.getInt("stock");
            java.sql.Date medDateExp = rs.getDate("date_expiration");
    %>
    <tr>
        <td><%= medId %></td>
        <td><%= medNom %></td>
        <td><%= medCategorie != null ? medCategorie : "Non définie" %></td>
        <td><%= String.format("%.2f", medPrix) %></td>
        <td><%= medStock %></td>
        <td><%= medDateExp != null ? medDateExp.toString() : "" %></td>
        <td class="actions">
            <% if ("ADMIN".equals(role) || "PHARMACIEN".equals(role)) { %>
            <a href="modifier-medicament.jsp?id=<%= medId %>" class="edit">✏️ Modifier</a>
            <a href="supprimer-medicament?id=<%= medId %>" class="delete" onclick="return confirm('Voulez-vous vraiment supprimer ce médicament ?');">🗑️ Supprimer</a>
            <% } else { %>
            <span class="locked">🔒 Actions réservées</span>
            <% } %>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
</body>
</html>
<%
} catch (Exception e) {
    erreur = e.getMessage();
%>
<p style="color:red; font-weight: bold;">Erreur : <%= erreur %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
