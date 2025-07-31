<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gestionpharmacie.model.Utilisateur" %>
<%
    int currentPage = 1;
    Object pageAttr = request.getAttribute("page");
    if (pageAttr != null) {
        try {
            currentPage = Integer.parseInt(pageAttr.toString());
        } catch (Exception e) {
            currentPage = 1;
        }
    }
    int totalPages = 1;
    Object totalPagesAttr = request.getAttribute("totalPages");
    if (totalPagesAttr != null) {
        try {
            totalPages = Integer.parseInt(totalPagesAttr.toString());
        } catch (Exception e) {
            totalPages = 1;
        }
    }
    String role = session.getAttribute("role") != null ? (String) session.getAttribute("role") : "";
    String contextPath = request.getContextPath();
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    List<Utilisateur> listeUtilisateurs = (List<Utilisateur>) request.getAttribute("listeUtilisateurs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des utilisateurs</title>
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #e8f8f5 0%, #d5f4e6 50%, #fafafa 100%);
            position: relative;
            min-height: 100vh;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 80%, rgba(39, 174, 96, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(46, 204, 113, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            margin: 40px auto 0 auto;
            padding: 40px 45px 35px 45px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(30, 132, 73, 0.15), 0 5px 15px rgba(0,0,0,0.1);
            max-width: 1200px;
            width: 95%;
            border: 3px solid transparent;
            background-clip: padding-box;
            position: relative;
            overflow: hidden;
        }
        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #1e8449, #27ae60, #2ecc71);
        }
        h2 {
            background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            text-shadow: 0 2px 4px rgba(30, 132, 73, 0.2);
            font-weight: bold;
        }
        h2 .fa-notes-medical {
            color: #27ae60;
            font-size: 2.1rem;
        }
        table {
            border: none;
            width: 100%;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 2px 12px #27ae6044;
        }
        th, td {
            padding: 16px 18px;
            text-align: center;
        }
        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #27ae60 60%, #48c774 100%);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            font-weight: bold;
            margin: 0 auto 4px auto;
            box-shadow: 0 2px 8px #27ae6044;
            border: 2px solid #fff;
        }
        .badge-role {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 12px;
            font-size: 0.98rem;
            font-weight: 600;
            color: #fff;
        }
        .badge-role.admin { background: #2c3e50; }
        .badge-role.pharmacien { background: #27ae60; }
        .badge-role.assistant { background: #f39c12; }
        th {
            background: linear-gradient(90deg, #27ae60 60%, #48c774 100%);
            color: #fff;
            font-size: 1.15rem;
            border: none;
        }
        tr {
            transition: background 0.2s, box-shadow 0.2s;
        }
        tr:nth-child(even) { background-color: #f4f9f8; }
        tr:hover {
            background: #eafaf1;
            box-shadow: 0 4px 16px #27ae6044;
        }
        .actions a {
            margin: 0 5px;
            padding: 8px 16px;
            border-radius: 6px;
            color: white;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px #27ae6033;
        }
        .actions a.edit {
            background: #48c774;
            color: #fff !important;
            border: 2px solid #fff;
            font-size: 18px;
            box-shadow: 0 2px 8px #27ae6044;
        }
        .actions a.edit:hover {
            background: #27ae60;
            color: #fff !important;
            border: 2px solid #27ae60;
            box-shadow: 0 4px 12px #27ae6044;
        }
        .actions a.delete { background: #e74c3c; }
        .actions a.delete:hover { background: #c0392b; box-shadow: 0 4px 12px #e74c3c44; }
        .actions span.locked {
            color: #aaa;
            font-style: italic;
            padding: 7px 12px;
            display: inline-block;
        }
        .btn-ajouter, .btn-ajouter.active-page {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            border: none;
            padding: 14px 35px;
            border-radius: 25px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
            margin-bottom: 20px;
            margin-right: 12px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 2px solid transparent;
        }
        .btn-ajouter.active-page, .btn-ajouter:active {
            background: #2c3e50;
            color: #fff;
            box-shadow: 0 4px 16px #2c3e5055;
        }
        .btn-ajouter:hover {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1e8449 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.4);
            border-color: rgba(255,255,255,0.3);
        }
        @media (max-width: 800px) {
            .container { padding: 18px 5px; }
            table, thead, tbody, th, td, tr { font-size: 15px; }
        }
        @media (max-width: 600px) {
            .container { padding: 8px 2px; }
            table, thead, tbody, th, td, tr { font-size: 13px; }
        }
    </style>
    <script>
        function confirmDelete(username) {
            return confirm("Voulez-vous vraiment supprimer l'utilisateur '" + username + "' ?");
        }
    </script>
</head>
<body>
<div class="container">
    <h2><i class="fa-solid fa-users-medical"></i> 👥 Gestion des Utilisateurs</h2>
    <form method="get" action="<%= contextPath %>/utilisateurs" style="display: flex; gap: 12px; margin-bottom: 18px; align-items: center;">
        <input type="hidden" name="action" value="list">
        <input type="text" name="search" placeholder="🔍 Rechercher par nom ou rôle..." value="<%= search %>" style="padding: 12px 18px; border-radius: 25px; border: 2px solid #27ae60; font-size: 16px; width: 300px; background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%); transition: all 0.3s ease; box-shadow: 0 2px 10px rgba(30, 132, 73, 0.1);" onfocus="this.style.borderColor='#2ecc71'; this.style.boxShadow='0 4px 15px rgba(30, 132, 73, 0.2)'; this.style.transform='translateY(-2px)';" onblur="this.style.borderColor='#27ae60'; this.style.boxShadow='0 2px 10px rgba(30, 132, 73, 0.1)'; this.style.transform='translateY(0)';">
        <button type="submit" class="btn-ajouter" style="margin: 0;"><i class="fa fa-search"></i> 🔍 Rechercher</button>
    </form>
    <a href="<%= contextPath %>/utilisateurs?action=new" class="btn-ajouter">
        <i class="fa fa-user"></i>  Nouvel Utilisateur
    </a>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Nom d'utilisateur</th>
            <th>Rôle</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (listeUtilisateurs != null && !listeUtilisateurs.isEmpty()) {
            for (Utilisateur u : listeUtilisateurs) { %>
        <tr>
            <td data-label="ID"><%= u.getId() %></td>
            <td data-label="Nom d'utilisateur">
                <span class="avatar"><%= u.getUsername().substring(0,1).toUpperCase() %></span><br>
                <span style="font-size:1.08em; font-weight:500; color:#34495e;"><%= u.getUsername() %></span>
            </td>
            <td data-label="Rôle">
                <% String roleClass = "";
                   if ("ADMIN".equals(u.getRole())) roleClass = "admin";
                   else if ("PHARMACIEN".equals(u.getRole())) roleClass = "pharmacien";
                   else if ("ASSISTANT".equals(u.getRole())) roleClass = "assistant";
                %>
                <span class="badge-role <%= roleClass %>"><%= u.getRole() %></span>
            </td>
            <td data-label="Actions" class="actions">
                <a href="<%= contextPath %>/utilisateurs?action=edit&id=<%= u.getId() %>" title="Modifier" class="edit">
                    <i class="fa fa-user-edit"></i>
                </a>
                <a href="<%= contextPath %>/utilisateurs?action=delete&id=<%= u.getId() %>" title="Supprimer" class="delete"
                   onclick="return confirmDelete('<%= u.getUsername() %>');">
                    <i class="fa fa-user-times"></i>
                </a>
            </td>
        </tr>
        <%  }
        } else { %>
        <tr>
            <td colspan="4" style="text-align:center; padding: 20px;">
                Aucun utilisateur trouvé dans la base de données.
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <!-- Pagination -->
    <% 
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
    
    int realCurrentPage = currentPageObj != null ? currentPageObj : 1;
    int realTotalPages = totalPagesObj != null ? totalPagesObj : 1;
    int totalItems = totalItemsObj != null ? totalItemsObj : 0;
    
    String searchParam = request.getParameter("search") != null ? "&search=" + java.net.URLEncoder.encode(request.getParameter("search"), "UTF-8") : "";
    
    if (realTotalPages > 1) {
    %>
    <div style="display: flex; justify-content: center; align-items: center; margin-top: 25px; gap: 10px; flex-wrap: wrap;">
        <% if (realCurrentPage > 1) { %>
        <a href="<%= contextPath %>/utilisateurs?page=<%= realCurrentPage - 1 %><%= searchParam %>" 
           style="padding: 10px 15px; background: #27ae60; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s ease;">
            <i class="fa fa-chevron-left"></i> Précédent
        </a>
        <% } %>
        
        <% for (int i = Math.max(1, realCurrentPage - 2); i <= Math.min(realTotalPages, realCurrentPage + 2); i++) { %>
        <a href="<%= contextPath %>/utilisateurs?page=<%= i %><%= searchParam %>" 
           style="padding: 10px 15px; background: <%= i == realCurrentPage ? "#1e8449" : "#27ae60" %>; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s ease;">
            <%= i %>
        </a>
        <% } %>
        
        <% if (realCurrentPage < realTotalPages) { %>
        <a href="<%= contextPath %>/utilisateurs?page=<%= realCurrentPage + 1 %><%= searchParam %>" 
           style="padding: 10px 15px; background: #27ae60; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; transition: all 0.3s ease;">
            Suivant <i class="fa fa-chevron-right"></i>
        </a>
        <% } %>
    </div>
    <div style="text-align: center; margin-top: 15px; color: #666; font-size: 0.9em;">
        Page <%= realCurrentPage %> sur <%= realTotalPages %> (<%= totalItems %> utilisateurs au total)
    </div>
    <% } else if (totalItems > 0) { %>
    <div style="text-align: center; margin-top: 15px; color: #666; font-size: 0.9em;">
        <%= totalItems %> utilisateur<%= totalItems > 1 ? "s" : "" %> trouvé<%= totalItems > 1 ? "s" : "" %>
    </div>
    <% } %>
    <!-- Bouton Retour dynamique -->
    <a class="btn-ajouter" style="display: block; width: fit-content; margin: 30px auto 0 auto; background: #fff; color: #27ae60; border: 2px solid #27ae60; text-align: center;" href="<% if ("ADMIN".equals(role)) { %><%= contextPath %>/admin-dashboard.jsp<% } else if ("PHARMACIEN".equals(role)) { %><%= contextPath %>/pharmacien-dashboard.jsp<% } else if ("ASSISTANT".equals(role)) { %><%= contextPath %>/assistant-dashboard.jsp<% } else { %>#<% } %>"><i class="fa-solid fa-arrow-left"></i> Retour au tableau de bord</a>
</div>
</body>
</html>
