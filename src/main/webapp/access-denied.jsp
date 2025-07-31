<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 27/07/2025
  Time: 15:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Accès refusé</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #ffe6e6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .error-box {
            text-align: center;
            background-color: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(255,0,0,0.2);
            max-width: 400px;
            width: 90%;
        }
        .error-box h1 {
            color: red;
            font-size: 2.5em;
            margin-bottom: 15px;
        }
        .error-box p {
            font-size: 1.2em;
            margin-bottom: 20px;
            color: #555;
        }
        .error-box a {
            color: white;
            background-color: #e74c3c;
            padding: 10px 25px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }
        .error-box a:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
<div class="error-box">
    <h1>⛔ Accès refusé</h1>
    <p>Vous n'avez pas les droits nécessaires pour accéder à cette page.</p>
    <a href="login.jsp">Retour à la page de connexion</a>
</div>
</body>
</html>
