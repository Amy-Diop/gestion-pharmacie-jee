<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 27/07/2025
  Time: 20:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  com.gestionpharmacie.model.Utilisateur utilisateur = (com.gestionpharmacie.model.Utilisateur) request.getAttribute("utilisateur");
  boolean estEdition = utilisateur != null;
  String action = estEdition ? "update" : "insert";
  String titre = estEdition ? "Modifier Utilisateur" : "Ajouter Utilisateur";
  String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title><%= titre %> - Gestion Pharmacie</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #e8f8f5 0%, #d5f4e6 50%, #fafafa 100%);
      margin: 0; padding: 0;
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
        radial-gradient(circle at 25% 75%, rgba(39, 174, 96, 0.08) 0%, transparent 50%),
        radial-gradient(circle at 75% 25%, rgba(46, 204, 113, 0.08) 0%, transparent 50%);
      pointer-events: none;
      z-index: -1;
    }
    .container {
      max-width: 550px;
      background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
      margin: 50px auto;
      padding: 45px 50px 40px 50px;
      border-radius: 25px;
      box-shadow: 0 15px 40px rgba(30, 132, 73, 0.15), 0 5px 15px rgba(0,0,0,0.1);
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
      text-align: center;
      background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 35px;
      font-size: 2.3rem;
      letter-spacing: 1px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      font-weight: bold;
      text-shadow: 0 2px 4px rgba(30, 132, 73, 0.2);
    }
    h2 .fa-user-plus, h2 .fa-user-edit {
      color: #27ae60;
      font-size: 2rem;
    }
    form label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #219150;
    }
    form input[type="text"],
    form input[type="password"],
    form select {
      width: 100%;
      padding: 15px 18px;
      margin-bottom: 25px;
      border: 2px solid #27ae60;
      border-radius: 15px;
      font-size: 16px;
      box-sizing: border-box;
      background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
      transition: all 0.3s ease;
      box-shadow: 0 2px 10px rgba(30, 132, 73, 0.1);
    }
    form input[type="text"]:focus,
    form input[type="password"]:focus,
    form select:focus {
      border-color: #2ecc71;
      box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
      outline: none;
      transform: translateY(-2px);
    }
    .btn {
      background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
      color: #fff;
      padding: 16px 0;
      font-weight: bold;
      border: none;
      border-radius: 25px;
      cursor: pointer;
      width: 100%;
      font-size: 18px;
      box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
      transition: all 0.3s ease;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      border: 2px solid transparent;
    }
    .btn:hover {
      background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1e8449 100%);
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(30, 132, 73, 0.4);
      border-color: rgba(255,255,255,0.3);
    }
    .back-link {
      display: block;
      margin-top: 18px;
      text-align: center;
      color: #27ae60;
      border: 2px solid #27ae60;
      background: #fff;
      border-radius: 8px;
      padding: 10px 0;
      font-weight: 600;
      text-decoration: none;
      width: 100%;
      transition: background 0.2s, color 0.2s, box-shadow 0.2s;
      box-shadow: 0 2px 8px #27ae6044;
    }
    .back-link:hover {
      background: #27ae60;
      color: #fff;
      text-decoration: none;
      box-shadow: 0 4px 16px #27ae6044;
    }
    @media (max-width: 600px) {
      .container {
        margin: 20px 8px;
        padding: 18px 5px;
      }
    }
  </style>
</head>
<body>

<div class="container">
  <h2>
    <i class="fa <%= estEdition ? "fa-user-edit" : "fa-user-plus" %>"></i>
    <%= titre %>
  </h2>

  <form action="<%= contextPath %>/utilisateurs?action=<%= action %>" method="post">
    <% if (estEdition) { %>
    <input type="hidden" name="id" value="<%= utilisateur.getId() %>"/>
    <% } %>

    <label for="username">👤 Nom d'utilisateur</label>
    <input type="text" id="username" name="username" required
           value="<%= estEdition ? utilisateur.getUsername() : "" %>"/>

    <label for="password">🔒 <%= estEdition ? "Nouveau mot de passe" : "Mot de passe" %></label>
    <input type="password" id="password" name="password" <%= estEdition ? "" : "required" %>
           placeholder="<%= estEdition ? "Laissez vide pour garder l'ancien" : "" %>" />

    <label for="role">🏥 Rôle</label>
    <select id="role" name="role" required>
      <option value="">-- Sélectionnez un rôle --</option>
      <option value="ADMIN" <%= estEdition && "ADMIN".equals(utilisateur.getRole()) ? "selected" : "" %>>👨‍💼 Administrateur</option>
      <option value="PHARMACIEN" <%= estEdition && "PHARMACIEN".equals(utilisateur.getRole()) ? "selected" : "" %>>👨‍⚕️ Pharmacien</option>
      <option value="ASSISTANT" <%= estEdition && "ASSISTANT".equals(utilisateur.getRole()) ? "selected" : "" %>>👩‍⚕️ Assistant</option>
    </select>

    <button type="submit" class="btn"><%= estEdition ? "✏️ Mettre à jour" : "➕ Ajouter" %></button>
  </form>

  <a href="<%= contextPath %>/utilisateurs?action=list" class="back-link">
    <i class="fa fa-arrow-left"></i> 🔙 Retour à la liste
  </a>
</div>

</body>
</html>
