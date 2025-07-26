<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 15:07
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

  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
  <title>Ajouter un Médicament</title>
  <style>
    body {
      font-family: Arial, sans-serif; background-color: #f5f5f5;
    }
    .container {
      width: 50%; margin: 50px auto; background: #fff; padding: 20px;
      box-shadow: 0 0 10px #ccc; border-radius: 8px;
    }
    h1 { color: #27ae60; text-align: center; }
    label {
      font-weight: bold; display: block; margin-top: 10px;
    }
    input[type="text"], input[type="number"], input[type="date"], select {
      width: 100%; padding: 10px; margin-top: 5px; margin-bottom: 15px;
      border: 1px solid #ccc; border-radius: 5px;
    }
    button {
      background-color: #27ae60; color: white;
      padding: 10px 15px; border: none; border-radius: 5px;
      width: 100%; font-size: 16px;
      cursor: pointer;
    }
    button:hover {
      background-color: #219150;
    }
    a {
      display: inline-block; margin-top: 10px; text-decoration: none;
      color: #2980b9;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>➕ Ajouter un Médicament</h1>
  <form method="post" action="ajouter-medicament">
    <label>Nom :</label>
    <input type="text" name="nom" placeholder="Nom du médicament" required>

    <label>Catégorie :</label>
    <select name="categorie_id" required>
      <option value="">-- Sélectionner une catégorie --</option>
      <%
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacie_db", "root", "");
          String sql = "SELECT * FROM categories ORDER BY nom ASC";
          stmt = conn.prepareStatement(sql);
          rs = stmt.executeQuery();
          while (rs.next()) {
      %>
      <option value="<%= rs.getInt("id") %>"><%= rs.getString("nom") %></option>
      <%
        }
      } catch (Exception e) {
      %>
      <option disabled style="color:red;">Erreur lors du chargement des catégories</option>
      <%
        } finally {
          if (rs != null) try { rs.close(); } catch (Exception e) {}
          if (stmt != null) try { stmt.close(); } catch (Exception e) {}
          if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
      %>
    </select>

    <label>Prix (FCFA) :</label>
    <input type="number" name="prix" step="0.01" placeholder="Ex: 1500" required>

    <label>Stock :</label>
    <input type="number" name="stock" placeholder="Ex: 50" required>

    <label>Date d’expiration :</label>
    <input type="date" name="date_expiration" required>

    <button type="submit">Ajouter</button>
  </form>
  <a href="liste-medicaments.jsp">⬅ Retour à la liste</a>
</div>
</body>
</html>
