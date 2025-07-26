<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 14:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"PHARMACIEN".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Pharmacien - Gestion Pharmacie</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
        }
        .header {
            background: #27ae60;
            color: white;
            padding: 20px;
            text-align: center;
            position: relative;
        }
        .logout {
            position: absolute;
            right: 20px;
            top: 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background 0.3s ease;
        }
        .logout:hover {
            background: #c0392b;
        }
        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            padding: 30px;
        }
        .card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }
        .card h2 {
            color: #27ae60;
            margin-bottom: 10px;
        }
        .card p {
            margin: 10px 0 20px;
            color: #555;
        }
        .card a {
            display: inline-block;
            background: #27ae60;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
        }
        .card a:hover {
            background: #219150;
        }
    </style>
    <script>
        function confirmLogout() {
            return confirm("Voulez-vous vraiment vous déconnecter ?");
        }
    </script>
</head>
<body>
<div class="header">
    <h1>💊 Dashboard Pharmacien</h1>
    <p>Bienvenue, <%= username %></p>
    <a href="logout" class="logout" onclick="return confirmLogout();">🚪 Déconnexion</a>
</div>
<div class="container">
    <div class="card">
        <h2>📦 Médicaments</h2>
        <p>Gérer les stocks et suivre les dates d’expiration.</p>
        <a href="liste-medicaments.jsp">Voir</a>
    </div>
    <div class="card">
        <h2>🛒 Ventes</h2>
        <p>Enregistrer les ventes et générer des factures.</p>
        <a href="liste-ventes.jsp">Voir</a>
    </div>
    <div class="card">
        <h2>📊 Alertes Stock</h2>
        <p>Voir les médicaments en rupture ou périmés.</p>
        <a href="alertes-stock.jsp">Voir</a>
    </div>
</div>
</body>
</html>
