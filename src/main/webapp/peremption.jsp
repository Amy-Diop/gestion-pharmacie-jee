<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Medicament" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("access-denied.jsp");
        return;
    }
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    Date aujourdhui = new Date();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Péremptions - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 50%, #fafafa 100%);
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
            max-width: 1400px;
            border-top: 6px solid #ff9800;
        }
        h1 {
            background: linear-gradient(135deg, #ff9800, #f57c00);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .peremption-table {
            background: linear-gradient(145deg, #ffffff 0%, #fff8f0 100%);
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 8px 25px rgba(255, 152, 0, 0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1200px;
        }
        th {
            background: linear-gradient(135deg, #ff9800, #f57c00);
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
            background: rgba(255, 152, 0, 0.05);
        }
        .statut-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
        }
        .perime { background: #dc3545; }
        .critique { background: #ff6b35; }
        .attention { background: #ffc107; color: #333; }
        .ok { background: #28a745; }
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn-action {
            padding: 4px 8px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.7em;
            transition: all 0.3s ease;
            display: inline-block;
        }
        .btn-retirer { background: #dc3545; color: white; }
        .btn-promotion { background: #ff9800; color: white; }
        .btn-surveillance { background: #17a2b8; color: white; }
        .btn-ok { background: #28a745; color: white; }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #ff9800;
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-calendar-times"></i> 📅 Gestion des Péremptions</h1>

    <div class="peremption-table">
        <table>
            <thead>
                <tr>
                    <th>💊 Médicament</th>
                    <th>🏷️ Catégorie</th>
                    <th>📦 Stock</th>
                    <th>📅 Date Expiration</th>
                    <th>⏰ Jours Restants</th>
                    <th>📊 Statut</th>
                    <th>⚙️ Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (medicaments != null && !medicaments.isEmpty()) {
                    for (Medicament med : medicaments) { 
                        if (med.getDateExpiration() != null) {
                            long diffInMillies = med.getDateExpiration().getTime() - aujourdhui.getTime();
                            long joursRestants = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
                            
                            String statutClass = "ok";
                            String statutText = "OK";
                            String joursText = joursRestants + " jours";
                            
                            if (joursRestants < 0) {
                                statutClass = "perime";
                                statutText = "PÉRIMÉ";
                                joursText = Math.abs(joursRestants) + " jours";
                            } else if (joursRestants <= 30) {
                                statutClass = "critique";
                                statutText = "CRITIQUE";
                            } else if (joursRestants <= 60) {
                                statutClass = "attention";
                                statutText = "ATTENTION";
                            } else if (joursRestants > 365) {
                                joursText = "365+ jours";
                            }
                %>
                <tr>
                    <td>
                        <strong><%= med.getNom() %></strong>
                        <% if (med.getDescription() != null && !med.getDescription().trim().isEmpty()) { %>
                        <br><small style="color: #666;"><%= med.getDescription().length() > 50 ? med.getDescription().substring(0, 50) + "..." : med.getDescription() %></small>
                        <% } %>
                    </td>
                    <td>
                        <% if (med.getCategorieNom() != null && !med.getCategorieNom().trim().isEmpty()) { %>
                        <span style="background: #007bff; color: white; padding: 2px 8px; border-radius: 10px; font-size: 0.8em;">
                            <%= med.getCategorieNom() %>
                        </span>
                        <% } else { %>
                        <span style="color: #999;">-</span>
                        <% } %>
                    </td>
                    <td style="text-align: center; font-weight: bold;">
                        <%= med.getStock() %> unités
                    </td>
                    <td style="text-align: center;">
                        <%= dateFormat.format(med.getDateExpiration()) %>
                    </td>
                    <td style="text-align: center; font-weight: bold;">
                        <%= joursText %>
                    </td>
                    <td style="text-align: center;">
                        <span class="statut-badge <%= statutClass %>">
                            <%= statutText %>
                        </span>
                    </td>
                    <td>
                        <div class="actions">
                            <% if (joursRestants < 0) { %>
                            <a href="#" class="btn-action btn-retirer" onclick="return confirm('Retirer ce médicament périmé ?');">
                                🗑️ Retirer
                            </a>
                            <% } else if (joursRestants <= 30) { %>
                            <a href="#" class="btn-action btn-promotion">
                                🏷️ Promotion
                            </a>
                            <a href="#" class="btn-action btn-retirer" onclick="return confirm('Retirer ce médicament ?');">
                                🗑️ Retirer
                            </a>
                            <% } else if (joursRestants <= 60) { %>
                            <a href="#" class="btn-action btn-surveillance">
                                👁️ Surveillance
                            </a>
                            <% } else { %>
                            <span class="btn-action btn-ok">
                                ✅ Aucune action
                            </span>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } } } else { %>
                <tr>
                    <td colspan="7" style="text-align: center; padding: 40px; color: #666;">
                        <i class="fa fa-calendar-times" style="font-size: 3em; margin-bottom: 20px; color: #ddd;"></i><br>
                        Aucun médicament avec date d'expiration trouvé.
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