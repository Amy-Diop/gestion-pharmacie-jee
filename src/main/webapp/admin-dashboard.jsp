<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 13:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");
  if (username == null || !"ADMIN".equals(role)) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Dashboard Admin - Gestion Pharmacie</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      background: #f4f6f8;
    }
    .header {
      background: #2c3e50;
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
      font-weight: bold;
    }
    .logout:hover {
      background: #c0392b;
    }
    .container {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 20px;
      padding: 30px;
      max-width: 1200px;
      margin: auto;
    }
    .card {
      background: #fff;
      padding: 25px 20px;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      text-align: center;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      min-height: 200px;
    }
    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    }
    .card h2 {
      color: #2980b9;
      margin-bottom: 15px;
      font-size: 1.6em;
    }
    .card p {
      flex-grow: 1;
      margin: 10px 0 20px;
      color: #555;
      font-size: 1em;
    }
    .card a {
      display: inline-block;
      background: #3498db;
      color: white;
      text-decoration: none;
      padding: 12px 20px;
      border-radius: 5px;
      font-weight: bold;
      font-size: 1em;
      transition: background 0.3s ease;
    }
    .card a:hover {
      background: #2980b9;
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
  <h1>👨‍💼 Dashboard Administrateur</h1>
  <p>Bienvenue, <%= username %></p>
  <a href="logout" class="logout" onclick="return confirmLogout();">🚪 Déconnexion</a>
</div>
<div class="container">
  <div class="card">
    <h2>📦 Gestion des Médicaments</h2>
    <p>Ajouter, modifier et supprimer des médicaments.</p>
    <a href="liste-medicaments.jsp">Voir</a>
  </div>
  <div class="card">
    <h2>👥 Gestion des Utilisateurs</h2>
    <p>Créer et gérer les comptes Pharmacien et Assistant.</p>
    <a href="liste-utilisateurs.jsp">Voir</a>
  </div>
  <div class="card">
    <h2>🛒 Gestion des Ventes</h2>
    <p>Suivre, modifier et analyser les ventes.</p>
    <a href="ventes?action=list">Voir</a>
  </div>
  <div class="card">
    <h2>📊 Statistiques</h2>
    <p>Analyser les ventes, stocks et performances.</p>
    <a href="statistiques.jsp">Voir</a>
  </div>
</div>
</body>
</html>
