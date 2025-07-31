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
    List<Medicament> alertes = (List<Medicament>) request.getAttribute("alertes");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Alertes Stock - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(255, 193, 7, 0.15);
            max-width: 1200px;
            border-top: 6px solid #ffc107;
        }
        h1 {
            background: linear-gradient(135deg, #ffc107, #ff9800);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .alertes-table {
            background: linear-gradient(145deg, #ffffff 0%, #fffbf0 100%);
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
        }
        th {
            background: linear-gradient(135deg, #ffc107, #ff9800);
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
            background: rgba(255, 193, 7, 0.05);
        }
        .stock-critique {
            background: #dc3545;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }
        .stock-faible {
            background: #ffc107;
            color: #333;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #ffc107;
            text-decoration: none;
            font-weight: bold;
        }
        .alert-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-exclamation-triangle"></i> ⚠️ Alertes Stock</h1>
    
    <div class="alert-info">
        <strong>Information :</strong> Cette page affiche les médicaments avec un stock faible ou en rupture nécessitant un réapprovisionnement.
    </div>

    <div class="alertes-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Stock Actuel</th>
                    <th>Seuil d'Alerte</th>
                    <th>Catégorie</th>
                    <th>Date Expiration</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <% if (alertes != null && !alertes.isEmpty()) {
                    for (Medicament med : alertes) { 
                        String stockClass = med.getStock() == 0 ? "stock-critique" : "stock-faible";
                        String stockText = med.getStock() == 0 ? "RUPTURE" : "STOCK FAIBLE";
                %>
                <tr>
                    <td style="font-weight: bold; color: #ffc107;">
                        <%= med.getId() %>
                    </td>
                    <td>
                        <strong><%= med.getNom() %></strong>
                    </td>
                    <td style="text-align: center; font-weight: bold; color: <%= med.getStock() == 0 ? "#dc3545" : "#ff9800" %>;">
                        <%= med.getStock() %>
                    </td>
                    <td style="text-align: center;">
                        <%= med.getSeuilAlerte() %>
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
                        <% if (med.getDateExpiration() != null) { %>
                        <%= dateFormat.format(med.getDateExpiration()) %>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: center;">
                        <span class="<%= stockClass %>">
                            <%= stockText %>
                        </span>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="7" style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa fa-check-circle" style="font-size: 3em; margin-bottom: 20px; color: #28a745;"></i><br>
                        Aucune alerte de stock. Tous les médicaments ont un stock suffisant.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
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