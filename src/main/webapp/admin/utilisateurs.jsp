<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 27/07/2025
  Time: 03:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gestionpharmacie.model.Utilisateur" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Utilisateur> utilisateurs = (List<Utilisateur>) request.getAttribute("utilisateurs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Gestion Utilisateurs - Admin</title>
    <link rel="stylesheet" href="../assets/css/style.css" />
</head>
<body>
<header class="header admin-header">
    <h1>Gestion des Utilisateurs</h1>
    <a href="create" class="btn">➕ Ajouter un utilisateur</a>
    <a href="dashboard.jsp" class="btn logout">⬅ Retour</a>
</header>

<table class="table">
    <thead>
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Prénom</th>
        <th>Email</th>
        <th>Rôle</th>
        <th>Actif</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (utilisateurs != null) {
        for (Utilisateur u : utilisateurs) { %>
    <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getNom() %></td>
        <td><%= u.getPrenom() %></td>
        <td><%= u.getEmail() %></td>
        <td><%= u.getRole() %></td>
        <td><%= u.isActive() ? "Oui" : "Non" %></td>
        <td>
            <a href="edit?id=<%= u.getId() %>" class="btn btn-small">✏️ Editer</a>
            <form action="delete" method="post" style="display:inline" onsubmit="return confirm('Supprimer cet utilisateur ?');">
                <input type="hidden" name="id" value="<%= u.getId() %>"/>
                <button type="submit" class="btn btn-small btn-danger">🗑️ Supprimer</button>
            </form>
        </td>
    </tr>
    <%  }
    } else { %>
    <tr><td colspan="7">Aucun utilisateur trouvé</td></tr>
    <% } %>
    </tbody>
</table>
</body>
</html>
