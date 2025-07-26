<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 21:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.gestionpharmacie.model.Vente" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Vente> ventes = (List<Vente>) request.getAttribute("ventes");
    List<String> medicamentsNoms = (List<String>) request.getAttribute("medicamentsNoms");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Ventes</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; }
        h1 { color: #2c3e50; }
        a.button {
            text-decoration: none; background: #27ae60; color: white;
            padding: 8px 15px; border-radius: 4px;
        }
        a.button:hover { background: #219150; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; box-shadow: 0 0 10px #ccc; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background-color: #27ae60; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .actions a { margin: 0 5px; padding: 5px 8px; text-decoration: none; color: white; border-radius: 4px; }
        .actions a.edit { background: #f39c12; }
        .actions a.delete { background: #e74c3c; }
    </style>
</head>
<body>
<h1>📦 Liste des Ventes</h1>
<a href="ventes?action=new" class="button">➕ Ajouter une Vente</a>
<table>
    <tr>
        <th>ID</th>
        <th>Médicament</th>
        <th>Quantité</th>
        <th>Total (FCFA)</th>
        <th>Date de Vente</th>
        <th>Actions</th>
    </tr>
    <%
        if (ventes != null) {
            for (int i = 0; i < ventes.size(); i++) {
                Vente v = ventes.get(i);
    %>
    <tr>
        <td><%= v.getId() %></td>
        <td><%= medicamentsNoms.get(i) %></td>
        <td><%= v.getQuantite() %></td>
        <td><%= String.format("%.2f", v.getTotal()) %></td>
        <td><%= v.getDateVente() %></td>
        <td class="actions">
            <a href="ventes?action=edit&id=<%= v.getId() %>" class="edit">✏️ Modifier</a>
            <a href="ventes?action=delete&id=<%= v.getId() %>" class="delete"
               onclick="return confirm('Voulez-vous vraiment supprimer cette vente ?');">🗑️ Supprimer</a>
        </td>
    </tr>
    <%
            }
        }
    %>
</table>
</body>
</html>

