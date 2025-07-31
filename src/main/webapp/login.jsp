<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 03:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>Connexion | Gestion Pharmacie</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap');

    body {
      font-family: 'Poppins', sans-serif;
      margin: 0;
      background: linear-gradient(to right, #c9e4ca, #edf6f9);
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .login-wrapper {
      display: flex;
      background: #fff;
      box-shadow: 0 8px 20px rgba(0,0,0,0.15);
      border-radius: 12px;
      overflow: hidden;
      max-width: 800px;
      width: 100%;
    }

    .login-img {
      flex: 1;
      background: url('https://cdn-icons-png.flaticon.com/512/3209/3209265.png') no-repeat center;
      background-size: contain;
      background-color: #e3f9e5;
    }

    .login-form {
      flex: 1;
      padding: 40px 30px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .login-form h2 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 20px;
    }

    .login-form label {
      font-weight: 500;
      margin-top: 10px;
      display: block;
    }

    .login-form input[type="text"],
    .login-form input[type="password"] {
      width: 100%;
      padding: 10px 12px;
      margin-top: 8px;
      border: 1px solid #ccc;
      border-radius: 8px;
      background-color: #f9f9f9;
      transition: 0.3s;
    }

    .login-form input:focus {
      outline: none;
      border-color: #28a745;
      background-color: #fff;
    }

    .login-form input[type="submit"] {
      margin-top: 20px;
      padding: 12px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: bold;
      cursor: pointer;
      font-size: 16px;
      transition: background-color 0.3s ease;
    }

    .login-form input[type="submit"]:hover {
      background-color: #218838;
    }

    .error-message {
      color: #e74c3c;
      background-color: #fdecea;
      border: 1px solid #f5c6cb;
      padding: 10px;
      text-align: center;
      border-radius: 8px;
      margin-bottom: 15px;
      font-weight: bold;
    }

    @media (max-width: 768px) {
      .login-wrapper {
        flex-direction: column;
      }

      .login-img {
        height: 200px;
        background-size: 150px;
      }
    }
  </style>
</head>
<body>
<div class="login-wrapper">
  <div class="login-img"></div>
  <div class="login-form">
    <h2>Connexion à la Pharmacie</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form method="post" action="login">
      <label for="username">Nom d'utilisateur</label>
      <input type="text" id="username" name="username" required autofocus />

      <label for="password">Mot de passe</label>
      <input type="password" id="password" name="password" required />

      <input type="submit" value="Se connecter" />
    </form>
  </div>
</div>
</body>
</html>
