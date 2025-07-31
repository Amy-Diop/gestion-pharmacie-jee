<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gestionpharmacie.model.Vente" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role) && !"ASSISTANT".equals(role))) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    String contextPath = request.getContextPath();
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    List<Vente> listeVentes = (List<Vente>) request.getAttribute("listeVentes");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    DecimalFormat moneyFormat = new DecimalFormat("#,##0");
    
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
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Ventes</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f8f5 0%, #d5f4e6 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            position: relative;
            min-height: 100vh;
            margin: 0;
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
        h1 {
            background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        .btn-ajouter {
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
        }
        .btn-ajouter:hover {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1e8449 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.4);
        }
        .search-form {
            display: flex;
            gap: 12px;
            margin-bottom: 25px;
            align-items: center;
        }
        .search-input {
            padding: 12px 18px;
            border-radius: 25px;
            border: 2px solid #27ae60;
            font-size: 16px;
            width: 300px;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(30, 132, 73, 0.1);
        }
        .search-input:focus {
            outline: none;
            border-color: #2ecc71;
            box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
            transform: translateY(-2px);
        }
        .ventes-table {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.1);
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: linear-gradient(135deg, #1e8449, #27ae60);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        tr:hover {
            background: rgba(30, 132, 73, 0.05);
        }
        .vente-id {
            font-weight: bold;
            color: #1e8449;
        }
        .client-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .client-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .montant {
            font-weight: bold;
            color: #27ae60;
            font-size: 1.1em;
        }
        .status {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
            text-align: center;
        }
        .status-payee { background: #27ae60; }
        .status-en-attente { background: #f39c12; }
        .status-annulee { background: #e74c3c; }
        .actions {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            font-size: 0.8em;
            border: 2px solid transparent;
        }
        .btn-voir {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        .btn-voir:hover {
            background: linear-gradient(135deg, #2980b9, #1f4e79);
            transform: translateY(-2px);
        }
        .btn-imprimer {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
        }
        .btn-imprimer:hover {
            background: linear-gradient(135deg, #8e44ad, #7d3c98);
            transform: translateY(-2px);
        }
        .btn-retour {
            display: block;
            width: fit-content;
            margin: 30px auto 0 auto;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #27ae60;
            border: 3px solid #27ae60;
            text-align: center;
            border-radius: 25px;
            padding: 12px 30px;
            font-size: 17px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-retour:hover {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa-solid fa-cash-register"></i> 💰 Gestion des Ventes</h1>
    
    <div class="search-form">
        <input type="text" class="search-input" placeholder="🔍 Rechercher par client ou ID vente...">
        <button class="btn-ajouter" style="margin: 0;">
            <i class="fa fa-search"></i> 🔍 Rechercher
        </button>
    </div>
    
    <% if (!"ASSISTANT".equals(role)) { %>
    <a href="<%= contextPath %>/ventes?action=new" class="btn-ajouter">
        <i class="fa fa-plus"></i> ➕ Nouvelle Vente
    </a>
    <% } %>
    
    <div class="ventes-table">
        <table>
            <thead>
                <tr>
                    <th>📄 ID Vente</th>
                    <th>👤 Client</th>
                    <th>📅 Date</th>
                    <th>💰 Montant</th>
                    <th>📊 Statut</th>
                    <th>⚙️ Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (listeVentes != null && !listeVentes.isEmpty()) {
                    for (Vente v : listeVentes) { %>
                <tr>
                    <td>
                        <div class="vente-id"><%= v.getIdFormate() %></div>
                    </td>
                    <td>
                        <div class="client-info">
                            <div class="client-avatar"><%= v.getClientNom().substring(0,1).toUpperCase() %></div>
                            <div>
                                <div style="font-weight: bold;"><%= v.getClientNom() %></div>
                                <% if (v.getClientTelephone() != null && !v.getClientTelephone().trim().isEmpty()) { %>
                                <div style="color: #666; font-size: 0.9em;"><%= v.getClientTelephone() %></div>
                                <% } %>
                            </div>
                        </div>
                    </td>
                    <td><%= dateFormat.format(v.getDateVente()) %></td>
                    <td>
                        <div class="montant"><%= moneyFormat.format(v.getMontantTotal()) %> FCFA</div>
                    </td>
                    <td>
                        <div class="status status-<%= v.getStatut().toLowerCase().replace("_", "-") %>"><%= v.getStatut().replace("_", " ") %></div>
                    </td>
                    <td>
                        <div class="actions">
                            <a href="<%= contextPath %>/ventes?action=view&id=<%= v.getId() %>" class="btn-action btn-voir">
                                <i class="fa fa-eye"></i> Voir
                            </a>
                            <a href="<%= contextPath %>/ventes?action=view&id=<%= v.getId() %>" class="btn-action btn-imprimer" onclick="setTimeout(() => window.print(), 500);">
                                <i class="fa fa-print"></i> Imprimer
                            </a>
                        </div>
                    </td>
                </tr>
                <%  }
                } else { %>
                <tr>
                    <td colspan="6" style="text-align:center; padding: 40px; color: #666;">
                        <i class="fa fa-receipt" style="font-size: 3em; margin-bottom: 15px; color: #ddd;"></i><br>
                        Aucune vente trouvée.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    
    <% if ("ADMIN".equals(role)) { %>
        <a class="btn-retour" href="<%= request.getContextPath() %>/admin-dashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> 🔙 Retour Dashboard Admin
        </a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="btn-retour" href="<%= request.getContextPath() %>/pharmacien-dashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> 🔙 Retour Dashboard Pharmacien
        </a>
    <% } else { %>
        <a class="btn-retour" href="<%= request.getContextPath() %>/assistant-dashboard.jsp">
            <i class="fa-solid fa-arrow-left"></i> 🔙 Retour Dashboard Assistant
        </a>
    <% } %>
</div>
</body>
</html>