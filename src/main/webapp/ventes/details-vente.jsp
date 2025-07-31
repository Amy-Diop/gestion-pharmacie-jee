<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Vente" %>
<%@ page import="com.gestionpharmacie.model.VenteItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    Vente vente = (Vente) request.getAttribute("vente");
    String contextPath = request.getContextPath();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    DecimalFormat moneyFormat = new DecimalFormat("#,##0");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails Vente - <%= vente != null ? vente.getIdFormate() : "" %></title>
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
            max-width: 800px;
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
        .vente-header {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        .info-section {
            background: rgba(30, 132, 73, 0.05);
            padding: 20px;
            border-radius: 15px;
            border: 2px solid rgba(30, 132, 73, 0.1);
        }
        .section-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #1e8449;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid rgba(30, 132, 73, 0.1);
        }
        .info-label {
            font-weight: 600;
            color: #666;
        }
        .info-value {
            color: #1e8449;
            font-weight: bold;
        }
        .status {
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
            text-align: center;
        }
        .status-payee { background: #27ae60; }
        .status-en-attente { background: #f39c12; }
        .status-annulee { background: #e74c3c; }
        .items-table {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(30, 132, 73, 0.1);
            margin: 30px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background: linear-gradient(135deg, #1e8449, #27ae60);
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background: rgba(30, 132, 73, 0.05);
        }
        .total-section {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            padding: 25px;
            border-radius: 15px;
            border: 3px solid #27ae60;
            margin: 30px 0;
            text-align: center;
        }
        .total-amount {
            font-size: 2.5em;
            font-weight: bold;
            color: #1e8449;
            margin-bottom: 10px;
        }
        .btn-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn-print {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
        }
        .btn-print:hover {
            background: linear-gradient(135deg, #8e44ad, #7d3c98);
            transform: translateY(-2px);
        }
        .btn-retour {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #27ae60;
            border: 3px solid #27ae60;
        }
        .btn-retour:hover {
            background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            transform: translateY(-3px);
        }
        @media print {
            body::before, .btn-actions { display: none; }
            .container { box-shadow: none; margin: 0; }
        }
    </style>
</head>
<body>
<div class="container">
    <% if (vente != null) { %>
    <h1><i class="fa-solid fa-receipt"></i> 🧾 Détails Vente <%= vente.getIdFormate() %></h1>
    
    <div class="vente-header">
        <div class="info-section">
            <div class="section-title">
                <i class="fa-solid fa-user"></i>
                👤 Informations Client
            </div>
            <div class="info-item">
                <span class="info-label">Nom :</span>
                <span class="info-value"><%= vente.getClientNom() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Téléphone :</span>
                <span class="info-value"><%= vente.getClientTelephone() != null ? vente.getClientTelephone() : "Non renseigné" %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Âge :</span>
                <span class="info-value"><%= vente.getClientAge() > 0 ? vente.getClientAge() + " ans" : "Non renseigné" %></span>
            </div>
            <% if (vente.getNumeroOrdonnance() != null && !vente.getNumeroOrdonnance().trim().isEmpty()) { %>
            <div class="info-item">
                <span class="info-label">N° Ordonnance :</span>
                <span class="info-value"><%= vente.getNumeroOrdonnance() %></span>
            </div>
            <% } %>
        </div>
        
        <div class="info-section">
            <div class="section-title">
                <i class="fa-solid fa-info-circle"></i>
                ℹ️ Informations Vente
            </div>
            <div class="info-item">
                <span class="info-label">Date :</span>
                <span class="info-value"><%= dateFormat.format(vente.getDateVente()) %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Vendeur :</span>
                <span class="info-value"><%= vente.getVendeur() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Mode paiement :</span>
                <span class="info-value"><%= vente.getModePaiement() %></span>
            </div>
            <div class="info-item">
                <span class="info-label">Statut :</span>
                <span class="status status-<%= vente.getStatut().toLowerCase().replace("_", "-") %>"><%= vente.getStatut() %></span>
            </div>
        </div>
    </div>

    <% if (vente.getItems() != null && !vente.getItems().isEmpty()) { %>
    <div class="items-table">
        <table>
            <thead>
                <tr>
                    <th>💊 Médicament</th>
                    <th>📦 Quantité</th>
                    <th>💰 Prix unitaire</th>
                    <th>💵 Sous-total</th>
                </tr>
            </thead>
            <tbody>
                <% for (VenteItem item : vente.getItems()) { %>
                <tr>
                    <td><%= item.getMedicamentNom() %></td>
                    <td style="text-align: center;"><%= item.getQuantite() %></td>
                    <td style="text-align: right;"><%= moneyFormat.format(item.getPrixUnitaire()) %> FCFA</td>
                    <td style="text-align: right; font-weight: bold; color: #27ae60;"><%= moneyFormat.format(item.getSousTotal()) %> FCFA</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

    <div class="total-section">
        <div class="total-amount"><%= moneyFormat.format(vente.getMontantTotal()) %> FCFA</div>
        <div style="color: #666; font-size: 1.1em;">💰 Total de la vente</div>
        <% if (vente.getMontantRecu() > 0) { %>
        <div style="margin-top: 15px; color: #666;">
            Montant reçu : <strong><%= moneyFormat.format(vente.getMontantRecu()) %> FCFA</strong><br>
            Monnaie rendue : <strong><%= moneyFormat.format(vente.getMonnaie()) %> FCFA</strong>
        </div>
        <% } %>
    </div>

    <% if (vente.getNotes() != null && !vente.getNotes().trim().isEmpty()) { %>
    <div class="info-section">
        <div class="section-title">
            <i class="fa-solid fa-sticky-note"></i>
            📝 Notes
        </div>
        <p style="color: #666; font-style: italic;"><%= vente.getNotes() %></p>
    </div>
    <% } %>

    <div class="btn-actions">
        <a href="#" class="btn btn-print" onclick="window.print();">
            <i class="fa fa-print"></i> 🖨️ Imprimer
        </a>
        <a href="<%= contextPath %>/ventes?action=list" class="btn btn-retour">
            <i class="fa fa-arrow-left"></i> 🔙 Retour
        </a>
    </div>
    
    <% } else { %>
    <h1>❌ Vente non trouvée</h1>
    <p style="text-align: center; color: #666;">La vente demandée n'existe pas ou a été supprimée.</p>
    <div class="btn-actions">
        <a href="<%= contextPath %>/ventes?action=list" class="btn btn-retour">
            <i class="fa fa-arrow-left"></i> 🔙 Retour à la liste
        </a>
    </div>
    <% } %>
</div>
</body>
</html>