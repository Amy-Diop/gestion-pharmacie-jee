<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 03:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Connexion - Gestion Pharmacie</title>
</head>
<body>
<h2>Connexion</h2>
<form method="post" action="login">
  <label for="username">Nom d'utilisateur :</label>
  <input type="text" id="username" name="username" required><br>

  <label for="password">Mot de passe :</label>
  <input type="password" id="password" name="password" required><br>

  <button type="submit">Se connecter</button>
</form>
</body>
</html>

