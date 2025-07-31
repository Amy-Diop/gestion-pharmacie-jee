<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Medicament" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("access-denied.jsp");
        return;
    }
    List<Medicament> alertes = (List<Medicament>) request.getAttribute("alertes");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Alertes Stock - Gestion Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #fff5f5 0%, #ffe6e6 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(231, 76, 60, 0.15);
            max-width: 1000px;
            border-top: 6px solid #e74c3c;
        }
        h1 {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .alert-section {
            background: rgba(231, 76, 60, 0.05);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border-left: 5px solid #e74c3c;
        }
        .alert-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 2px solid #fadbd8;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .medicament-info {
            flex: 1;
        }
        .medicament-nom {
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .medicament-details {
            color: #7f8c8d;
            font-size: 0.9em;
        }
        .stock-badge {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: bold;
            color: white;
            text-align: center;
            min-width: 80px;
        }
        .stock-critique { background: #e74c3c; }
        .stock-faible { background: #f39c12; }
        .stock-perime { background: #8e44ad; }
        .btn-retour {
            display: block;
            width: fit-content;
            margin: 30px auto 0;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #e74c3c;
            border: 3px solid #e74c3c;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-retour:hover {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: #fff;
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-exclamation-triangle"></i> ⚠️ Alertes Stock</h1>
    
    <% if (alertes != null && !alertes.isEmpty()) { %>
        <!-- Stock Critique et Faible -->
        <div class="alert-section">
            <div class="alert-title">
                <i class="fa fa-exclamation-triangle"></i>
                ⚠️ Alertes Stock Actives
            </div>
            <% for (Medicament med : alertes) { %>
            <div class="alert-item">
                <div class="medicament-info">
                    <div class="medicament-nom"><%= med.getNom() %></div>
                    <div class="medicament-details">
                        Prix: <%= String.format("%.0f", med.getPrix()) %> FCFA | 
                        Seuil: <%= med.getSeuilAlerte() %> unités
                        <% if (med.getDateExpiration() != null) { %>
                        | Expire: <%= dateFormat.format(med.getDateExpiration()) %>
                        <% } %>
                    </div>
                </div>
                <div class="stock-badge <%= med.getStock() == 0 ? "stock-critique" : "stock-faible" %>">
                    <%= med.getStock() %> unités
                </div>
            </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="alert-section">
            <div class="alert-title">
                <i class="fa fa-check-circle"></i>
                ✅ Aucune Alerte
            </div>
            <div style="text-align: center; padding: 40px; color: #27ae60;">
                <i class="fa fa-smile" style="font-size: 3em; margin-bottom: 20px;"></i><br>
                Tous les médicaments ont un stock suffisant !
            </div>
        </div>
    <% } %>

    <% if ("ADMIN".equals(role)) { %>
        <a class="btn-retour" href="admin-dashboard.jsp">
            <i class="fa fa-arrow-left"></i> 🔙 Retour Dashboard Admin
        </a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="btn-retour" href="pharmacien-dashboard.jsp">
            <i class="fa fa-arrow-left"></i> 🔙 Retour Dashboard Pharmacien
        </a>
    <% } else { %>
        <a class="btn-retour" href="assistant-dashboard.jsp">
            <i class="fa fa-arrow-left"></i> 🔙 Retour Dashboard Assistant
        </a>
    <% } %>
</div>
</body>
</html>