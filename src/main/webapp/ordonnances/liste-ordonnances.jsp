<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Ordonnance" %>
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
    List<Ordonnance> ordonnances = (List<Ordonnance>) request.getAttribute("ordonnances");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des Ordonnances - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #e8f8f5 0%, #d1f2eb 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(39, 174, 96, 0.15);
            max-width: 1400px;
            border-top: 6px solid #27ae60;
        }
        h1 {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .btn-nouveau {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .btn-nouveau:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.4);
        }
        .ordonnances-table {
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }
        th {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
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
            background: rgba(39, 174, 96, 0.05);
        }
        .statut-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
        }
        .en-attente { background: #f39c12; }
        .validee { background: #28a745; }
        .actions {
            display: flex;
            gap: 10px;
        }
        .btn-action {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-valider {
            background: #28a745;
            color: white;
        }
        .btn-valider:hover {
            background: #218838;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #27ae60;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-file-medical"></i> 📋 Liste des Ordonnances</h1>

    <% if ("PHARMACIEN".equals(role) || "ADMIN".equals(role)) { %>
    <a href="ordonnances?action=new" class="btn-nouveau">
        <i class="fa fa-plus"></i> ➕ Nouvelle Ordonnance
    </a>
    <% } %>

    <div class="ordonnances-table">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Numéro</th>
                    <th>Patient</th>
                    <th>Médecin</th>
                    <th>Date Ordonnance</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (ordonnances != null && !ordonnances.isEmpty()) {
                    for (Ordonnance ord : ordonnances) { %>
                <tr>
                    <td style="font-weight: bold; color: #27ae60;">
                        <%= ord.getId() %>
                    </td>
                    <td>
                        <%= ord.getNumero() %>
                    </td>
                    <td>
                        <strong><%= ord.getPatientNom() %></strong>
                    </td>
                    <td>
                        Dr. <%= ord.getMedecinNom() %>
                    </td>
                    <td>
                        <%= dateFormat.format(ord.getDateOrdonnance()) %>
                    </td>
                    <td>
                        <span class="statut-badge <%= ord.getStatut().toLowerCase().replace("_", "-") %>">
                            <%= ord.getStatut().replace("_", " ") %>
                        </span>
                    </td>
                    <td class="actions">
                        <% if ("EN_ATTENTE".equals(ord.getStatut()) && ("PHARMACIEN".equals(role) || "ADMIN".equals(role))) { %>
                        <a href="ordonnances?action=validate&id=<%= ord.getId() %>" 
                           class="btn-action btn-valider"
                           onclick="return confirm('Valider cette ordonnance ?');">
                            <i class="fa fa-check"></i> Valider
                        </a>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="7" style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa fa-file-medical" style="font-size: 3em; margin-bottom: 20px; color: #ddd;"></i><br>
                        Aucune ordonnance enregistrée pour le moment.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

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