<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("access-denied.jsp");
        return;
    }

    // Récupérer les statistiques avec valeurs par défaut
    Integer nombreMedicamentsObj = (Integer) request.getAttribute("nombreMedicaments");
    Integer nombreVentesObj = (Integer) request.getAttribute("nombreVentes");
    Integer nombreCategoriesObj = (Integer) request.getAttribute("nombreCategories");
    Integer nombreAlertesObj = (Integer) request.getAttribute("nombreAlertes");
    Integer nombreFournisseursObj = (Integer) request.getAttribute("nombreFournisseurs");
    Integer nombreUtilisateursObj = (Integer) request.getAttribute("nombreUtilisateurs");
    Integer medicamentsEnRuptureObj = (Integer) request.getAttribute("medicamentsEnRupture");
    Integer medicamentsPerimesObj = (Integer) request.getAttribute("medicamentsPerimes");
    Double chiffreAffairesObj = (Double) request.getAttribute("chiffreAffaires");
    Double chiffreAffairesHebdoObj = (Double) request.getAttribute("chiffreAffairesHebdo");
    Double chiffreAffairesMensuelObj = (Double) request.getAttribute("chiffreAffairesMensuel");
    
    int nombreMedicaments = nombreMedicamentsObj != null ? nombreMedicamentsObj : 0;
    int nombreVentes = nombreVentesObj != null ? nombreVentesObj : 0;
    int nombreCategories = nombreCategoriesObj != null ? nombreCategoriesObj : 0;
    int nombreAlertes = nombreAlertesObj != null ? nombreAlertesObj : 0;
    int nombreFournisseurs = nombreFournisseursObj != null ? nombreFournisseursObj : 0;
    int nombreUtilisateurs = nombreUtilisateursObj != null ? nombreUtilisateursObj : 0;
    int medicamentsEnRupture = medicamentsEnRuptureObj != null ? medicamentsEnRuptureObj : 0;
    int medicamentsPerimes = medicamentsPerimesObj != null ? medicamentsPerimesObj : 0;
    double chiffreAffaires = chiffreAffairesObj != null ? chiffreAffairesObj : 0.0;
    double chiffreAffairesHebdo = chiffreAffairesHebdoObj != null ? chiffreAffairesHebdoObj : 0.0;
    double chiffreAffairesMensuel = chiffreAffairesMensuelObj != null ? chiffreAffairesMensuelObj : 0.0;
    
    Map<String, Double> ventesParJour = (Map<String, Double>) request.getAttribute("ventesParJour");
    Map<String, Integer> medicamentsParCategorie = (Map<String, Integer>) request.getAttribute("medicamentsParCategorie");
    
    if (ventesParJour == null) ventesParJour = new java.util.HashMap<>();
    if (medicamentsParCategorie == null) medicamentsParCategorie = new java.util.HashMap<>();
    
    // Si aucune donnée n'est présente, rediriger vers le servlet
    if (nombreMedicamentsObj == null && nombreVentesObj == null) {
        response.sendRedirect("statistiques");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Statistiques - Pharmacie</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 50%, #fafafa 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            background: linear-gradient(145deg, #ffffff 0%, #fefefe 100%);
            margin: 40px auto;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 40px rgba(156, 39, 176, 0.15);
            max-width: 1400px;
            border-top: 6px solid #9c27b0;
        }
        h1 {
            background: linear-gradient(135deg, #9c27b0, #7b1fa2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-align: center;
            margin-bottom: 35px;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: linear-gradient(145deg, #ffffff 0%, #f8f9ff 100%);
            padding: 25px 20px;
            border-radius: 18px;
            box-shadow: 0 8px 25px rgba(156, 39, 176, 0.15);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 2px solid transparent;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #9c27b0, #7b1fa2, #673ab7);
        }
        .stat-card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 30px rgba(156, 39, 176, 0.2);
            border-color: #9c27b0;
        }
        .stat-card i {
            font-size: 2.5em;
            background: linear-gradient(135deg, #9c27b0, #7b1fa2, #673ab7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            filter: drop-shadow(0 2px 4px rgba(156, 39, 176, 0.3));
        }
        .stat-card h3 {
            margin-top: 10px;
            font-size: 28px;
            color: #9c27b0;
            font-weight: bold;
        }
        .stat-card p {
            font-size: 16px;
            color: #5d6d7e;
            margin-bottom: 15px;
        }
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 40px;
        }
        .chart-container {
            background: linear-gradient(145deg, #ffffff 0%, #f8f9ff 100%);
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(156, 39, 176, 0.15);
            border-top: 4px solid #9c27b0;
        }
        .chart-title {
            font-size: 1.3em;
            font-weight: bold;
            color: #9c27b0;
            margin-bottom: 20px;
            text-align: center;
        }
        canvas {
            max-height: 300px;
        }
        .back-link {
            display: block;
            margin-top: 30px;
            text-align: center;
            color: #9c27b0;
            text-decoration: none;
            font-weight: bold;
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .stat-card {
            animation: fadeInUp 0.6s ease-out;
        }
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }
        .stat-card:nth-child(5) { animation-delay: 0.5s; }
        .stat-card:nth-child(6) { animation-delay: 0.6s; }
        .stat-card:nth-child(7) { animation-delay: 0.7s; }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-chart-bar"></i> 📊 Statistiques de la Pharmacie</h1>

    <div class="stats-grid">
        <div class="stat-card">
            <i class="fa-solid fa-capsules"></i>
            <h3>💊 <%= nombreMedicaments %></h3>
            <p>Médicaments en stock</p>
        </div>
        <div class="stat-card">
            <i class="fa-solid fa-cash-register"></i>
            <h3>💳 <%= nombreVentes %></h3>
            <p>Ventes réalisées</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-tags"></i>
            <h3>🏷️ <%= nombreCategories %></h3>
            <p>Catégories de médicaments</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-exclamation-triangle"></i>
            <h3>⚠️ <%= nombreAlertes %></h3>
            <p>Alertes stock faible</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-times-circle"></i>
            <h3>🚫 <%= medicamentsEnRupture %></h3>
            <p>Médicaments en rupture</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-calendar-times"></i>
            <h3>📅 <%= medicamentsPerimes %></h3>
            <p>Médicaments périmés</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-money-bill-wave"></i>
            <h3>💰 <%= String.format("%.0f", chiffreAffaires) %></h3>
            <p>CA Total (FCFA)</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-chart-line"></i>
            <h3>📈 <%= String.format("%.0f", chiffreAffairesHebdo) %></h3>
            <p>CA 7 derniers jours (FCFA)</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-calendar-month"></i>
            <h3>📆 <%= String.format("%.0f", chiffreAffairesMensuel) %></h3>
            <p>CA 30 derniers jours (FCFA)</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-users"></i>
            <h3>👥 <%= nombreUtilisateurs %></h3>
            <p>Utilisateurs du système</p>
        </div>
        <div class="stat-card">
            <i class="fa fa-truck"></i>
            <h3>🚛 <%= nombreFournisseurs %></h3>
            <p>Fournisseurs partenaires</p>
        </div>
    </div>

    <div class="charts-section">
        <div class="chart-container">
            <div class="chart-title">📈 Chiffre d'Affaires par Jour (7 derniers jours)</div>
            <canvas id="ventesChart"></canvas>
        </div>
        <div class="chart-container">
            <div class="chart-title">🏷️ Médicaments par Catégorie (Top 5)</div>
            <canvas id="categoriesChart"></canvas>
        </div>
    </div>

    <% if ("ADMIN".equals(role)) { %>
        <a class="back-link" href="admin-dashboard.jsp">🔙 Retour Dashboard Admin</a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="back-link" href="pharmacien-dashboard.jsp">🔙 Retour Dashboard Pharmacien</a>
    <% } else { %>
        <a class="back-link" href="assistant-dashboard.jsp">🔙 Retour Dashboard Assistant</a>
    <% } %>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
// Graphique des ventes par jour
const ventesCtx = document.getElementById('ventesChart').getContext('2d');
const ventesChart = new Chart(ventesCtx, {
    type: 'bar',
    data: {
        labels: [
            <% 
            String[] jours = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
            String[] joursVF = {"Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"};
            for (int i = 0; i < jours.length; i++) {
                out.print("'" + joursVF[i] + "'");
                if (i < jours.length - 1) out.print(", ");
            }
            %>
        ],
        datasets: [{
            label: 'Chiffre d\'affaires (FCFA)',
            data: [
                <% 
                for (int i = 0; i < jours.length; i++) {
                    Double ventes = ventesParJour.get(jours[i]);
                    out.print(ventes != null ? ventes.intValue() : 0);
                    if (i < jours.length - 1) out.print(", ");
                }
                %>
            ],
            backgroundColor: '#9c27b0',
            borderColor: '#7b1fa2',
            borderWidth: 2,
            borderRadius: 6
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            y: { beginAtZero: true }
        }
    }
});

// Graphique des médicaments par catégorie
const categoriesCtx = document.getElementById('categoriesChart').getContext('2d');
const categoriesChart = new Chart(categoriesCtx, {
    type: 'doughnut',
    data: {
        labels: [
            <% 
            int count = 0;
            for (String categorie : medicamentsParCategorie.keySet()) {
                out.print("'" + categorie + "'");
                count++;
                if (count < medicamentsParCategorie.size()) out.print(", ");
            }
            %>
        ],
        datasets: [{
            data: [
                <% 
                count = 0;
                for (Integer nombre : medicamentsParCategorie.values()) {
                    out.print(nombre);
                    count++;
                    if (count < medicamentsParCategorie.size()) out.print(", ");
                }
                %>
            ],
            backgroundColor: [
                '#9c27b0',
                '#7b1fa2',
                '#673ab7',
                '#3f51b5',
                '#2196f3'
            ],
            borderWidth: 2
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});
</script>
</body>
</html>