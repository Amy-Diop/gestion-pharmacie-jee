<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Fournisseur" %>
<%
    Fournisseur fournisseur = (Fournisseur) request.getAttribute("fournisseur");
    boolean estEdition = fournisseur != null;
    String action = estEdition ? "update" : "insert";
    String titre = estEdition ? "Modifier Fournisseur" : "Nouveau Fournisseur";
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
            background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(255, 152, 0, 0.15);
            max-width: 800px;
            border-top: 6px solid #ff9800;
        }
        h2 {
            background: linear-gradient(135deg, #ff9800, #f57c00);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.3rem;
            font-weight: bold;
        }
        .form-section {
            background: rgba(255, 152, 0, 0.05);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 2px solid rgba(255, 152, 0, 0.1);
        }
        .section-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #ff9800;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
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
            color: #ff9800;
            margin-bottom: 8px;
            font-size: 16px;
        }
        input, textarea {
            padding: 15px 18px;
            border: 2px solid #ff9800;
            border-radius: 15px;
            font-size: 16px;
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(255, 152, 0, 0.1);
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #f57c00;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.2);
            transform: translateY(-2px);
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        .btn {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: #fff;
            padding: 16px 0;
            font-weight: bold;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            font-size: 18px;
            box-shadow: 0 6px 20px rgba(255, 152, 0, 0.3);
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 15px;
        }
        .btn:hover {
            background: linear-gradient(135deg, #f57c00 0%, #e65100 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 152, 0, 0.4);
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            color: #ff9800;
            border: 3px solid #ff9800;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .back-link:hover {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: #fff;
            transform: translateY(-3px);
        }
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>
        <i class="fa <%= estEdition ? "fa-edit" : "fa-plus" %>"></i>
        <%= estEdition ? "✏️ Modifier" : "➕ Nouveau" %> Fournisseur
    </h2>

    <form action="<%= contextPath %>/fournisseurs?action=<%= action %>" method="post">
        <% if (estEdition) { %>
        <input type="hidden" name="id" value="<%= fournisseur.getId() %>"/>
        <% } %>

        <!-- Informations générales -->
        <div class="form-section">
            <div class="section-title">
                <i class="fa-solid fa-building"></i>
                🏢 Informations Générales
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="nom">🏷️ Nom du Fournisseur *</label>
                    <input type="text" id="nom" name="nom" required
                           value="<%= estEdition ? fournisseur.getNom() : "" %>"
                           placeholder="Nom de l'entreprise"/>
                </div>
                <div class="form-group">
                    <label for="numeroImmatriculation">🆔 N° Immatriculation</label>
                    <input type="text" id="numeroImmatriculation" name="numeroImmatriculation"
                           value="<%= estEdition && fournisseur.getNumeroImmatriculation() != null ? fournisseur.getNumeroImmatriculation() : "" %>"
                           placeholder="Numéro d'immatriculation"/>
                </div>
            </div>
            <div class="form-group full-width">
                <label for="adresse">📍 Adresse</label>
                <textarea id="adresse" name="adresse" placeholder="Adresse complète du fournisseur..."><%= estEdition && fournisseur.getAdresse() != null ? fournisseur.getAdresse() : "" %></textarea>
            </div>
        </div>

        <!-- Contact -->
        <div class="form-section">
            <div class="section-title">
                <i class="fa-solid fa-phone"></i>
                📞 Informations de Contact
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="telephone">📞 Téléphone</label>
                    <input type="tel" id="telephone" name="telephone"
                           value="<%= estEdition && fournisseur.getTelephone() != null ? fournisseur.getTelephone() : "" %>"
                           placeholder="+221 33 123 45 67"/>
                </div>
                <div class="form-group">
                    <label for="email">📧 Email</label>
                    <input type="email" id="email" name="email"
                           value="<%= estEdition && fournisseur.getEmail() != null ? fournisseur.getEmail() : "" %>"
                           placeholder="contact@fournisseur.com"/>
                </div>
            </div>
        </div>

        <!-- Informations commerciales -->
        <div class="form-section">
            <div class="section-title">
                <i class="fa-solid fa-handshake"></i>
                💼 Informations Commerciales
            </div>
            <div class="form-group">
                <label for="produitsFournis">📦 Produits Fournis</label>
                <textarea id="produitsFournis" name="produitsFournis" placeholder="Liste des produits ou catégories fournis..."><%= estEdition && fournisseur.getProduitsFournis() != null ? fournisseur.getProduitsFournis() : "" %></textarea>
            </div>
            <div class="form-group">
                <label for="conditionsPaiement">💳 Conditions de Paiement</label>
                <textarea id="conditionsPaiement" name="conditionsPaiement" placeholder="Conditions de paiement (délais, modalités...)..."><%= estEdition && fournisseur.getConditionsPaiement() != null ? fournisseur.getConditionsPaiement() : "" %></textarea>
            </div>
        </div>

        <button type="submit" class="btn">
            <%= estEdition ? "✏️ Mettre à jour" : "➕ Ajouter" %> le Fournisseur
        </button>
    </form>

    <a href="<%= contextPath %>/fournisseurs?action=list" class="back-link">
        <i class="fa fa-arrow-left"></i> 🔙 Retour à la liste
    </a>
</div>
</body>
</html>