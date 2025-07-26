<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 03:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
  String erreur = (String) request.getAttribute("erreur");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Connexion - Gestion Pharmacie</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #27ae60, #2980b9);
      height: 100vh;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .login-container {
      background: #fff;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0px 0px 15px rgba(0,0,0,0.2);
      width: 400px;
    }
    h1 {
      text-align: center;
      color: #27ae60;
      margin-bottom: 20px;
    }
    label {
      font-weight: bold;
    }
    input[type="text"], input[type="password"] {
      width: 100%; padding: 10px;
      margin: 10px 0 20px 0;
      border: 1px solid #ccc; border-radius: 5px;
    }
    button {
      width: 100%;
      padding: 10px;
      background: #27ae60;
      border: none;
      color: white;
      font-size: 16px;
      border-radius: 5px;
      cursor: pointer;
    }
    button:hover {
      background: #219150;
    }
    .error {
      color: red;
      text-align: center;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>
<div class="login-container">
  <h1>🔑 Connexion</h1>
  <% if (erreur != null) { %>
  <div class="error"><%= erreur %></div>
  <% } %>
  <form method="post" action="login">
    <label>Nom d'utilisateur :</label>
    <input type="text" name="username" placeholder="Entrer votre nom" required>

    <label>Mot de passe :</label>
    <input type="password" name="password" placeholder="Entrer votre mot de passe" required>

    <button type="submit">Se connecter</button>
  </form>
</div>
</body>
</html>


