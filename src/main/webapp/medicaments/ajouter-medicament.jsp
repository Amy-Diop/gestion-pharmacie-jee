<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Categorie" %>
<%@ page import="com.gestionpharmacie.model.Fournisseur" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ADMIN".equals(role)) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    List<Categorie> categories = (List<Categorie>) request.getAttribute("categories");
    List<Fournisseur> fournisseurs = (List<Fournisseur>) request.getAttribute("fournisseurs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter Médicament - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(40, 167, 69, 0.15);
            max-width: 800px;
            border-top: 6px solid #28a745;
        }
        h2 {
            background: linear-gradient(135deg, #28a745, #20c997);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.3rem;
            font-weight: bold;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        label {
            font-weight: 600;
            color: #28a745;
            margin-bottom: 8px;
            font-size: 16px;
        }
        input, select, textarea {
            padding: 15px 18px;
            border: 2px solid #28a745;
            border-radius: 15px;
            font-size: 16px;
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            transition: all 0.3s ease;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #20c997;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
            transform: translateY(-2px);
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: #fff;
            padding: 16px 0;
            font-weight: bold;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            font-size: 18px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #28a745;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>➕ Ajouter Nouveau Médicament</h2>

    <form action="ajouter-medicament" method="post">
        <div class="form-row">
            <div class="form-group">
                <label for="nom">💊 Nom du Médicament *</label>
                <input type="text" id="nom" name="nom" required placeholder="Nom du médicament"/>
            </div>
            <div class="form-group">
                <label for="prix">💰 Prix (FCFA) *</label>
                <input type="number" id="prix" name="prix" step="0.01" required placeholder="Prix en FCFA"/>
            </div>
        </div>

        <div class="form-group full-width">
            <label for="description">📝 Description</label>
            <textarea id="description" name="description" placeholder="Description du médicament..."></textarea>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="stock">📦 Stock *</label>
                <input type="number" id="stock" name="stock" required placeholder="Quantité en stock"/>
            </div>
            <div class="form-group">
                <label for="seuilAlerte">⚠️ Seuil d'Alerte *</label>
                <input type="number" id="seuilAlerte" name="seuilAlerte" required value="10" placeholder="Seuil d'alerte"/>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="dateExpiration">📅 Date d'Expiration</label>
                <input type="date" id="dateExpiration" name="dateExpiration"/>
            </div>
            <div class="form-group">
                <label for="categorieId">🏷️ Catégorie</label>
                <select id="categorieId" name="categorieId">
                    <option value="">Sélectionner une catégorie</option>
                    <% if (categories != null) {
                        for (Categorie cat : categories) { %>
                    <option value="<%= cat.getId() %>"><%= cat.getNom() %></option>
                    <% } } %>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label for="fournisseurId">🚛 Fournisseur</label>
            <select id="fournisseurId" name="fournisseurId">
                <option value="">Sélectionner un fournisseur</option>
                <% if (fournisseurs != null) {
                    for (Fournisseur four : fournisseurs) { %>
                <option value="<%= four.getId() %>"><%= four.getNom() %></option>
                <% } } %>
            </select>
        </div>

        <button type="submit" class="btn">➕ Ajouter le Médicament</button>
    </form>

    <% if ("ADMIN".equals(role)) { %>
        <a class="back-link" href="admin-dashboard.jsp">🔙 Retour Dashboard Admin</a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="back-link" href="pharmacien-dashboard.jsp">🔙 Retour Dashboard Pharmacien</a>
    <% } else { %>
        <a class="back-link" href="assistant-dashboard.jsp">🔙 Retour Dashboard Assistant</a>
    <% } %>
</div>
</body>
</html>