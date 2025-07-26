<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 15:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    PreparedStatement stmtCat = null;
    ResultSet rsCat = null;

    String nom = "";
    double prix = 0;
    int stock = 0;
    String dateExpiration = "";
    int categorieId = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacie_db", "root", "");

        // Charger les infos du médicament
        String sql = "SELECT * FROM medicaments WHERE id=?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        rs = stmt.executeQuery();
        if (rs.next()) {
            nom = rs.getString("nom");
            prix = rs.getDouble("prix");
            stock = rs.getInt("stock");
            dateExpiration = rs.getString("date_expiration");
            categorieId = rs.getInt("categorie_id");
        }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier un Médicament</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container {
            width: 50%; margin: 50px auto; background: #fff; padding: 20px;
            box-shadow: 0px 0px 10px #ccc; border-radius: 8px;
        }
        h1 { color: #f39c12; text-align: center; }
        label { font-weight: bold; display: block; margin-top: 10px; }
        input[type="text"], input[type="number"], input[type="date"], select {
            width: 100%; padding: 10px; margin-top: 5px; margin-bottom: 15px;
            border: 1px solid #ccc; border-radius: 5px;
        }
        button {
            background-color: #f39c12; color: white;
            padding: 10px 15px; border: none; border-radius: 5px;
            width: 100%; font-size: 16px;
        }
        button:hover { background-color: #d88d0a; }
        a {
            display: inline-block; margin-top: 10px; text-decoration: none;
            color: #2980b9;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>✏️ Modifier un Médicament</h1>
    <form method="post" action="modifier-medicament?id=<%= id %>">
        <label>Nom :</label>
        <input type="text" name="nom" value="<%= nom %>" required>

        <label>Catégorie :</label>
        <select name="categorie_id" required>
            <option value="">-- Sélectionner une catégorie --</option>
            <%
                // Charger toutes les catégories
                stmtCat = conn.prepareStatement("SELECT * FROM categories ORDER BY nom ASC");
                rsCat = stmtCat.executeQuery();
                while (rsCat.next()) {
                    int catId = rsCat.getInt("id");
                    String catNom = rsCat.getString("nom");
                    String selected = (catId == categorieId) ? "selected" : "";
            %>
            <option value="<%= catId %>" <%= selected %>><%= catNom %></option>
            <%
                }
            %>
        </select>

        <label>Prix (FCFA) :</label>
        <input type="number" name="prix" step="0.01" value="<%= prix %>" required>

        <label>Stock :</label>
        <input type="number" name="stock" value="<%= stock %>" required>

        <label>Date d’expiration :</label>
        <input type="date" name="date_expiration" value="<%= dateExpiration %>" required>

        <button type="submit">Modifier</button>
    </form>
    <a href="liste-medicaments.jsp">⬅ Retour à la liste</a>
</div>
</body>
</html>
<%
} catch (Exception e) {
%>
<p style="color:red; font-weight: bold;">Erreur : <%= e.getMessage() %></p>
<%
    } finally {
        if (rsCat != null) rsCat.close();
        if (stmtCat != null) stmtCat.close();
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
