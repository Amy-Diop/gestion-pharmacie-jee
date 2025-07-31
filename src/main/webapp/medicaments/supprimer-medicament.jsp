<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Suppression d'un médicament</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #e0f7fa 0%, #a5d6a7 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .container {
            background: #fff;
            margin-top: 40px;
            padding: 32px 36px 28px 36px;
            border-radius: 18px;
            box-shadow: 0 8px 32px #81c78455;
            max-width: 420px;
            width: 100%;
        }
        h2 {
            color: #c62828;
            text-align: center;
            margin-bottom: 28px;
        }
        .pharma-icon {
            font-size: 38px;
            color: #43a047;
            display: block;
            text-align: center;
            margin-bottom: 10px;
        }
        form {
            text-align: center;
        }
        .btn-main {
            background: linear-gradient(90deg, #e53935 60%, #c62828 100%);
            color: #fff;
            border: none;
            padding: 12px 0;
            border-radius: 7px;
            font-size: 18px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 2px 8px #a5d6a7aa;
            margin-bottom: 10px;
            transition: background 0.2s;
        }
        .btn-main:hover {
            background: linear-gradient(90deg, #b71c1c 60%, #8d1919 100%);
        }
        .btn-retour {
            display: block;
            margin: 0 auto 0 auto;
            background: #fff;
            color: #16a085;
            border: 2px solid #16a085;
            border-radius: 7px;
            padding: 10px 22px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            text-align: center;
            margin-top: 10px;
            transition: background 0.2s, color 0.2s;
        }
        .btn-retour:hover {
            background: #16a085;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="container">
    <span class="pharma-icon"><i class="fa-solid fa-capsules"></i></span>
    <h2>Voulez-vous vraiment supprimer ce médicament ?</h2>
    <form action="<%= request.getContextPath() %>/supprimer-medicament" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <button type="submit" class="btn-main"><i class="fa-solid fa-trash"></i> Confirmer la suppression</button>
    </form>
    <a class="btn-retour" href="<%= request.getContextPath() %>/liste-medicaments" style="margin-top: 10px;"><i class="fa-solid fa-arrow-left"></i> Retour à la liste</a>
</div>
</body>
</html>
