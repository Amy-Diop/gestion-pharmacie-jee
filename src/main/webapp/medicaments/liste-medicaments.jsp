<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Medicament" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des Médicaments - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(40, 167, 69, 0.15);
            max-width: 1200px;
            border-top: 6px solid #28a745;
        }
        h1 {
            background: linear-gradient(135deg, #28a745, #20c997);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            gap: 20px;
            flex-wrap: wrap;
        }
        .search-container {
            flex: 1;
            max-width: 500px;
        }
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-input {
            flex: 1;
            min-width: 250px;
            padding: 12px 20px;
            border: 2px solid #28a745;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            border-color: #20c997;
            box-shadow: 0 0 10px rgba(40, 167, 69, 0.3);
        }
        .search-btn, .clear-btn {
            padding: 12px 20px;
            border: none;
            border-radius: 25px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }
        .search-btn {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }
        .clear-btn {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        .btn-nouveau {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        .btn-nouveau:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }
        .medicaments-table {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1400px;
        }
        th {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: rgba(40, 167, 69, 0.05);
        }
        .stock-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
        }
        .stock-ok { background: #28a745; }
        .stock-faible { background: #ffc107; color: #333; }
        .stock-critique { background: #dc3545; }
        .actions {
            display: flex;
            gap: 8px;
        }
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.8em;
            transition: all 0.3s ease;
        }
        .btn-modifier {
            background: #007bff;
            color: white;
        }
        .btn-supprimer {
            background: #dc3545;
            color: white;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .pagination {
            margin: 30px 0;
            text-align: center;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 15px;
        }
        .page-btn {
            padding: 10px 15px;
            border: 2px solid #28a745;
            border-radius: 8px;
            text-decoration: none;
            color: #28a745;
            font-weight: bold;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .page-btn:hover, .page-btn.active {
            background: #28a745;
            color: white;
            transform: translateY(-2px);
        }
        .pagination-info {
            color: #666;
            font-size: 0.9em;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #28a745;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-pills"></i> 💊 Liste des Médicaments</h1>
    
    <div class="toolbar">
        <div class="search-container">
            <form method="get" action="liste-medicaments" class="search-form">
                <input type="text" name="search" placeholder="🔍 Rechercher un médicament..." 
                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" 
                       class="search-input">
                <button type="submit" class="search-btn">
                    <i class="fa fa-search"></i> Rechercher
                </button>
                <% if (request.getParameter("search") != null && !request.getParameter("search").trim().isEmpty()) { %>
                <a href="liste-medicaments" class="clear-btn">
                    <i class="fa fa-times"></i> Effacer
                </a>
                <% } %>
            </form>
        </div>
        <% if ("ADMIN".equals(role)) { %>
        <a href="ajouter-medicament" class="btn-nouveau">
            <i class="fa fa-plus"></i> ➕ Ajouter Nouveau Médicament
        </a>
        <% } %>
    </div>

    <div class="medicaments-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Description</th>
                    <th>Prix (FCFA)</th>
                    <th>Stock</th>
                    <th>Seuil Alerte</th>
                    <th>Date Expiration</th>
                    <th>Catégorie</th>
                    <th>Fournisseur</th>
                    <th>Actif</th>
                    <% if ("ADMIN".equals(role) || "PHARMACIEN".equals(role)) { %>
                    <th>Actions</th>
                    <% } %>
                </tr>
            </thead>
            <tbody>
                <% if (medicaments != null && !medicaments.isEmpty()) {
                    for (Medicament med : medicaments) { 
                        String stockClass = "stock-ok";
                        if (med.getStock() == 0) stockClass = "stock-critique";
                        else if (med.getStock() <= med.getSeuilAlerte()) stockClass = "stock-faible";
                %>
                <tr>
                    <td style="text-align: center; color: #28a745;">
                        <%= med.getId() %>
                    </td>
                    <td style="max-width: 150px;">
                        <%= med.getNom() %>
                    </td>
                    <td style="max-width: 200px; font-size: 0.9em;">
                        <% if (med.getDescription() != null && !med.getDescription().trim().isEmpty()) { %>
                        <%= med.getDescription().length() > 50 ? med.getDescription().substring(0, 50) + "..." : med.getDescription() %>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: right;">
                        <%= String.format("%.0f", med.getPrix()) %> FCFA
                    </td>
                    <td style="text-align: center;">
                        <%= med.getStock() %>
                    </td>
                    <td style="text-align: center;">
                        <%= med.getSeuilAlerte() %>
                    </td>
                    <td style="text-align: center;">
                        <% if (med.getDateExpiration() != null) { %>
                        <%= dateFormat.format(med.getDateExpiration()) %>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: center;">
                        <% if (med.getCategorieNom() != null && !med.getCategorieNom().trim().isEmpty()) { %>
                        <span style="background: #007bff; color: white; padding: 2px 8px; border-radius: 10px; font-size: 0.8em;">
                            <%= med.getCategorieNom() %>
                        </span>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: center;">
                        <% if (med.getFournisseurNom() != null && !med.getFournisseurNom().trim().isEmpty()) { %>
                        <span style="background: #ff9800; color: white; padding: 2px 8px; border-radius: 10px; font-size: 0.8em;">
                            <%= med.getFournisseurNom() %>
                        </span>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: center;">
                        <span style="background: <%= med.isActif() ? "#28a745" : "#dc3545" %>; color: white; padding: 2px 8px; border-radius: 10px; font-size: 0.8em;">
                            <%= med.isActif() ? "✅ Oui" : "❌ Non" %>
                        </span>
                    </td>
                    <% if ("ADMIN".equals(role) || "PHARMACIEN".equals(role)) { %>
                    <td>
                        <div class="actions">
                            <a href="modifier-medicament?id=<%= med.getId() %>" class="btn-action btn-modifier">
                                ✏️ Modifier
                            </a>
                            <% if ("ADMIN".equals(role)) { %>
                            <a href="supprimer-medicament?id=<%= med.getId() %>" 
                               class="btn-action btn-supprimer"
                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce médicament ?');">
                                🗑️ Supprimer
                            </a>
                            <% } %>
                        </div>
                    </td>
                    <% } %>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="<%= ("ADMIN".equals(role) || "PHARMACIEN".equals(role)) ? "11" : "10" %>" style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa fa-pills" style="font-size: 3em; margin-bottom: 20px; color: #ddd;"></i><br>
                        Aucun médicament trouvé.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="pagination">
        <% 
        Integer currentPageObj = (Integer) request.getAttribute("currentPage");
        Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
        Integer totalItemsObj = (Integer) request.getAttribute("totalItems");
        
        int currentPage = currentPageObj != null ? currentPageObj : 1;
        int totalPages = totalPagesObj != null ? totalPagesObj : 1;
        int totalItems = totalItemsObj != null ? totalItemsObj : 0;
        
        String searchParam = request.getParameter("search") != null ? "&search=" + java.net.URLEncoder.encode(request.getParameter("search"), "UTF-8") : "";
        
        if (totalPages > 1) {
        %>
        <div class="pagination-container">
            <% if (currentPage > 1) { %>
            <a href="liste-medicaments?page=<%= currentPage - 1 %><%= searchParam %>" class="page-btn">
                <i class="fa fa-chevron-left"></i> Précédent
            </a>
            <% } %>
            
            <% for (int i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) { %>
            <a href="liste-medicaments?page=<%= i %><%= searchParam %>" 
               class="page-btn <%= i == currentPage ? "active" : "" %>">
                <%= i %>
            </a>
            <% } %>
            
            <% if (currentPage < totalPages) { %>
            <a href="liste-medicaments?page=<%= currentPage + 1 %><%= searchParam %>" class="page-btn">
                Suivant <i class="fa fa-chevron-right"></i>
            </a>
            <% } %>
        </div>
        <div class="pagination-info">
            Page <%= currentPage %> sur <%= totalPages %> 
            (<%= totalItems %> médicaments au total)
        </div>
        <% } else if (totalItems > 0) { %>
        <div class="pagination-info">
            <%= totalItems %> médicament<%= totalItems > 1 ? "s" : "" %> trouvé<%= totalItems > 1 ? "s" : "" %>
        </div>
        <% } %>
    </div>

    <% if ("ADMIN".equals(role)) { %>
        <a class="back-link" href="admin-dashboard.jsp">🔙 Retour Dashboard Admin</a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="back-link" href="pharmacien-dashboard.jsp">🔙 Retour Dashboard Pharmacien</a>
    <% } else { %>
        <a class="back-link" href="assistant-dashboard.jsp">🔙 Retour Dashboard Assistant</a>
    <% } %>
</div>
</body>
</html>