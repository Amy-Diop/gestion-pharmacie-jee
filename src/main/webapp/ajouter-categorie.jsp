<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 19:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");
  if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Ajouter une Catégorie</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f5f5f5; }
    .form-container {
      max-width: 400px; margin: auto; background: #fff;
      padding: 20px; border-radius: 8px; box-shadow: 0 0 10px #ccc;
    }
    h1 { color: #2c3e50; }
    input[type="text"], input[type="submit"] {
      width: 100%; padding: 10px; margin: 8px 0; border: 1px solid #ccc; border-radius: 4px;
    }
    input[type="submit"] {
      background: #27ae60; color: white; border: none;
    }
    input[type="submit"]:hover {
      background: #219150;
    }
    a { display: block; text-align: center; margin-top: 10px; text-decoration: none; color: #3498db; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
<div class="form-container">
  <h1>➕ Ajouter une Catégorie</h1>
  <form action="categories?action=insert" method="post">
    <label>Nom de la Catégorie :</label>
    <input type="text" name="nom" required>
    <input type="submit" value="Enregistrer">
  </form>
  <a href="categories">⬅ Retour à la liste</a>
</div>
</body>
</html>

