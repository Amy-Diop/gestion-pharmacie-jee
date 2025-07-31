<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Vente" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    List<Vente> ventes = (List<Vente>) request.getAttribute("ventes");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Historique des Ventes - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(33, 150, 243, 0.15);
            max-width: 1400px;
            border-top: 6px solid #2196f3;
        }
        h1 {
            background: linear-gradient(135deg, #2196f3, #1976d2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .ventes-table {
            background: linear-gradient(145deg, #ffffff 0%, #f3f8ff 100%);
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }
        th {
            background: linear-gradient(135deg, #2196f3, #1976d2);
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
            background: rgba(33, 150, 243, 0.05);
        }
        .statut-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
            background: #28a745;
        }
        .mode-paiement {
            padding: 3px 8px;
            border-radius: 8px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .especes { background: #28a745; color: white; }
        .carte { background: #007bff; color: white; }
        .mobile { background: #ff9800; color: white; }
        .cheque { background: #6c757d; color: white; }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #2196f3;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-history"></i> Historique des Ventes</h1>

    <div class="ventes-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Date/Heure</th>
                    <th>Client</th>
                    <th>Vendeur</th>
                    <th>Montant Total</th>
                    <th>Montant Reçu</th>
                    <th>Monnaie</th>
                    <th>Mode Paiement</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <% if (ventes != null && !ventes.isEmpty()) {
                    for (Vente vente : ventes) { %>
                <tr>
                    <td style="font-weight: bold; color: #2196f3;">
                        <%= vente.getId() %>
                    </td>
                    <td>
                        <%= dateFormat.format(vente.getDateVente()) %>
                    </td>
                    <td>
                        <%= vente.getClientNom() != null ? vente.getClientNom() : "Client anonyme" %>
                    </td>
                    <td>
                        <strong><%= vente.getVendeur() %></strong>
                    </td>
                    <td style="text-align: right; font-weight: bold; color: #28a745;">
                        <%= String.format("%.0f", vente.getMontantTotal()) %> FCFA
                    </td>
                    <td style="text-align: right;">
                        <%= String.format("%.0f", vente.getMontantRecu()) %> FCFA
                    </td>
                    <td style="text-align: right; color: <%= vente.getMonnaie() > 0 ? "#ff9800" : "#28a745" %>;">
                        <%= String.format("%.0f", vente.getMonnaie()) %> FCFA
                    </td>
                    <td style="text-align: center;">
                        <span class="mode-paiement <%= vente.getModePaiement().toLowerCase() %>">
                            <%= vente.getModePaiement().toUpperCase() %>
                        </span>
                    </td>
                    <td style="text-align: center;">
                        <span class="statut-badge">
                            <%= vente.getStatut() %>
                        </span>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="9" style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa fa-shopping-cart" style="font-size: 3em; margin-bottom: 20px; color: #ddd;"></i><br>
                        Aucune vente enregistrée pour le moment.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <a class="back-link" href="ventes?action=list">Retour Nouvelle Vente</a>
</div>
</body>
</html>