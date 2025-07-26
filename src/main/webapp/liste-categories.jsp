<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 18:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gestionpharmacie.model.Categorie" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Catégories</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        h1 { color: #2c3e50; }
        a.button { text-decoration: none; color: white; background: #3498db; padding: 8px 12px; border-radius: 4px; }
        a.button:hover { background: #2980b9; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; background: white; box-shadow: 0 0 10px #ccc; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #27ae60; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .actions a { margin: 0 5px; padding: 5px 8px; }
        .actions a.edit { background: #f39c12; }
        .actions a.delete { background: #e74c3c; }
    </style>
</head>
<body>
<h1>📂 Liste des Catégories</h1>
<a href="categories?action=new" class="button">➕ Ajouter une Catégorie</a>
<table>
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Actions</th>
    </tr>
    <% if (categories != null) {
        for (Categorie cat : categories) { %>
    <tr>
        <td><%= cat.getId() %></td>
        <td><%= cat.getNom() %></td>
        <td class="actions">
            <a href="categories?action=edit&id=<%= cat.getId() %>" class="edit">✏️ Modifier</a>
            <a href="categories?action=delete&id=<%= cat.getId() %>" class="delete" onclick="return confirm('Supprimer cette catégorie ?');">🗑️ Supprimer</a>
        </td>
    </tr>
    <% } } %>
</table>
</body>
</html>

