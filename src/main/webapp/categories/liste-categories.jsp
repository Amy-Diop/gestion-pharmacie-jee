<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.gestionpharmacie.model.Categorie" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ADMIN".equals(role)) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    String contextPath = request.getContextPath();
    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    List<Categorie> listeCategories = (List<Categorie>) request.getAttribute("listeCategories");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Catégories</title>
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
                radial-gradient(circle at 20% 80%, rgba(39, 174, 96, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(46, 204, 113, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            margin: 40px auto 0 auto;
            padding: 40px 45px 35px 45px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(30, 132, 73, 0.15), 0 5px 15px rgba(0,0,0,0.1);
            max-width: 1000px;
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
        h1 {
            background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        .btn-ajouter {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            border: none;
            padding: 14px 35px;
            border-radius: 25px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
            margin-bottom: 20px;
            margin-right: 12px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-ajouter:hover {
            background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1e8449 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.4);
        }
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .category-card {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.15), 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 2px solid transparent;
        }
        .category-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1e8449, #27ae60, #2ecc71);
        }
        .category-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 30px rgba(30, 132, 73, 0.2), 0 5px 15px rgba(0,0,0,0.15);
            border-color: #2ecc71;
        }
        .category-icon {
            font-size: 3em;
            background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin-bottom: 15px;
        }
        .category-name {
            font-size: 1.5em;
            font-weight: bold;
            color: #1e8449;
            text-align: center;
            margin-bottom: 10px;
        }
        .category-count {
            text-align: center;
            color: #666;
            margin-bottom: 20px;
        }
        .category-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 15px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .btn-edit {
            background: linear-gradient(135deg, #f39c12, #e67e22);
            color: white;
        }
        .btn-edit:hover {
            background: linear-gradient(135deg, #e67e22, #d35400);
            transform: translateY(-2px);
        }
        .btn-delete {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }
        .btn-delete:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-2px);
        }
        .btn-retour {
            display: block;
            width: fit-content;
            margin: 30px auto 0 auto;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #27ae60;
            border: 3px solid #27ae60;
            text-align: center;
            border-radius: 25px;
            padding: 12px 30px;
            font-size: 17px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(30, 132, 73, 0.2);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-retour:hover {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(30, 132, 73, 0.3);
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa-solid fa-layer-group"></i> 🏷️ Gestion des Catégories</h1>
    
    <form method="get" action="<%= contextPath %>/categories" style="display: flex; gap: 12px; margin-bottom: 25px; align-items: center;">
        <input type="hidden" name="action" value="list">
        <input type="text" name="search" placeholder="🔍 Rechercher une catégorie..." value="<%= search %>" style="padding: 12px 18px; border-radius: 25px; border: 2px solid #27ae60; font-size: 16px; width: 300px; background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%); transition: all 0.3s ease; box-shadow: 0 2px 10px rgba(30, 132, 73, 0.1);">
        <button type="submit" class="btn-ajouter" style="margin: 0;"><i class="fa fa-search"></i> 🔍 Rechercher</button>
    </form>
    
    <a href="<%= contextPath %>/categories?action=new" class="btn-ajouter">
        <i class="fa fa-plus"></i> ➕ Nouvelle Catégorie
    </a>
    
    <div class="categories-grid">
        <% if (listeCategories != null && !listeCategories.isEmpty()) {
            String[] icones = {"fa-capsules", "fa-heart-pulse", "fa-lungs", "fa-brain", "fa-stomach", "fa-shield-virus", "fa-syringe", "fa-tablets"};
            String[] emojis = {"💊", "❤️", "🫁", "🧠", "🫄", "🛡️", "💉", "💊"};
            int iconIndex = 0;
            for (Categorie c : listeCategories) { %>
        <div class="category-card">
            <div class="category-icon">
                <i class="fa-solid <%= icones[iconIndex % icones.length] %>"></i>
            </div>
            <div class="category-name"><%= c.getNom() %></div>
            <div class="category-count"><%= c.getNombreMedicaments() %> médicaments</div>
            <% if (c.getDescription() != null && !c.getDescription().trim().isEmpty()) { %>
            <div style="color: #666; font-size: 0.9em; margin: 10px 0; font-style: italic;"><%= c.getDescription() %></div>
            <% } %>
            <div class="category-actions">
                <a href="<%= contextPath %>/categories?action=edit&id=<%= c.getId() %>" class="btn-action btn-edit">
                    <i class="fa fa-edit"></i> Modifier
                </a>
                <a href="<%= contextPath %>/categories?action=delete&id=<%= c.getId() %>" class="btn-action btn-delete" onclick="return confirm('Supprimer la catégorie <%= c.getNom() %> ?');">
                    <i class="fa fa-trash"></i> Supprimer
                </a>
            </div>
        </div>
        <%  iconIndex++;
            }
        } else { %>
        <div style="text-align: center; padding: 40px; color: #666; font-size: 1.2em;">
            <i class="fa fa-folder-open" style="font-size: 3em; margin-bottom: 20px; color: #ddd;"></i><br>
            Aucune catégorie trouvée.
        </div>
        <% } %>
    </div>
    
    <a class="btn-retour" href="<%= request.getContextPath() %>/admin-dashboard.jsp">
        <i class="fa-solid fa-arrow-left"></i> Retour au Dashboard
    </a>
</div>
</body>
</html>