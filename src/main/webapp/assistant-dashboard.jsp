<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 14:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Vérification session et rôle "ASSISTANT"
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ASSISTANT".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Assistant - Gestion Pharmacie</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
        }
        .header {
            background: #f39c12;
            color: white;
            padding: 20px;
            text-align: center;
            position: relative;
        }
        .header a.logout {
            position: absolute;
            top: 20px;
            right: 20px;
            background: #e74c3c;
            padding: 8px 12px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-weight: bold;
        }
        .header a.logout:hover {
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
            color: #f39c12;
            margin-bottom: 10px;
        }
        .card p {
            margin: 10px 0 20px;
            color: #555;
        }
        .card a {
            display: inline-block;
            background: #f39c12;
            color: white;
            text-decoration: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
        }
        .card a:hover {
            background: #d88d0a;
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
    <h1>📋 Dashboard Assistant</h1>
    <p>Bienvenue, <%= username %></p>
    <a href="logout" class="logout" onclick="return confirmLogout();">🚪 Déconnexion</a>
</div>
<div class="container">
    <div class="card">
        <h2>📦 Consulter Médicaments</h2>
        <p>Visualiser les médicaments et leurs stocks.</p>
        <a href="liste-medicaments.jsp">Voir</a>
    </div>
    <div class="card">
        <h2>🛒 Aider sur les Ventes</h2>
        <p>Assister le pharmacien dans la gestion des ventes.</p>
        <!-- Ici, on appelle la servlet pour lister les ventes -->
        <a href="ventes?action=list">Voir</a>
    </div>
</div>
</body>
</html>
