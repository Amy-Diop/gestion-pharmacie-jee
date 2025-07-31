<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Categorie" %>
<%
    Categorie categorie = (Categorie) request.getAttribute("categorie");
    boolean estEdition = categorie != null;
    String action = estEdition ? "update" : "insert";
    String titre = estEdition ? "Modifier Catégorie" : "Ajouter Catégorie";
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><%= titre %> - Gestion Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f8f5 0%, #d5f4e6 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            position: relative;
            min-height: 100vh;
            margin: 0;
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
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            margin: 50px auto;
            padding: 45px 50px 40px 50px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(30, 132, 73, 0.15), 0 5px 15px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 95%;
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
            background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.3rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        form label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1e8449;
            font-size: 16px;
        }
        form input[type="text"], form textarea {
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
        form input[type="text"]:focus, form textarea:focus {
            border-color: #2ecc71;
            box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
            outline: none;
            transform: translateY(-2px);
        }
        form textarea {
            resize: vertical;
            min-height: 100px;
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
            margin-top: 20px;
            text-align: center;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #27ae60;
            border: 3px solid #27ae60;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .back-link:hover {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
        }
    </style>
</head>
<body>
<div class="container">
    <h2>
        <i class="fa <%= estEdition ? "fa-edit" : "fa-plus" %>"></i>
        <%= estEdition ? "Modifier" : "Ajouter" %> une Catégorie
    </h2>

    <form action="<%= contextPath %>/categories?action=<%= action %>" method="post">
        <% if (estEdition) { %>
        <input type="hidden" name="id" value="<%= categorie.getId() %>"/>
        <% } %>

        <label for="nom">Nom de la catégorie *</label>
        <input type="text" id="nom" name="nom" required
               value="<%= estEdition ? categorie.getNom() : "" %>"
               placeholder="Ex: Antibiotiques, Antalgiques..."/>

        <label for="description">Description</label>
        <textarea id="description" name="description" 
                  placeholder="Description de la catégorie (optionnel)..."><%= estEdition && categorie.getDescription() != null ? categorie.getDescription() : "" %></textarea>

        <button type="submit" class="btn">
            <%= estEdition ? "Mettre à jour" : "Ajouter" %>
        </button>
    </form>

    <a href="<%= contextPath %>/categories?action=list" class="back-link">
        <i class="fa fa-arrow-left"></i> Retour à la liste
    </a>
</div>
</body>
</html>