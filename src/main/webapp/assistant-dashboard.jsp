<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"ASSISTANT".equals(role)) {
        response.sendRedirect("access-denied.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Assistant</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #e8f6f3 0%, #d5f4e6 50%, #f4f6f8 100%);
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 30% 70%, rgba(39, 174, 96, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 70% 30%, rgba(46, 204, 113, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 220px;
            height: 100%;
            background: linear-gradient(180deg, #229954 0%, #27ae60 50%, #2ecc71 100%);
            color: #fff;
            padding-top: 20px;
            box-shadow: 3px 0 20px rgba(34, 153, 84, 0.3);
            border-right: 3px solid #2ecc71;
        }
        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="medical" patternUnits="userSpaceOnUse" width="20" height="20"><path d="M10,5 L10,15 M5,10 L15,10" stroke="%23ffffff" stroke-width="1" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23medical)"/></svg>');
            pointer-events: none;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 22px;
            color: #fff;
            background: rgba(255,255,255,0.15);
            padding: 15px 10px;
            margin: 0 10px 30px 10px;
            border-radius: 12px;
            border: 2px solid rgba(255,255,255,0.2);
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: #dfe6e9;
            text-decoration: none;
            transition: background 0.3s;
        }

        .sidebar a:hover {
            background: linear-gradient(90deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.2) 100%);
            color: #fff;
            border-radius: 8px 0 0 8px;
            transform: translateX(5px);
        }

        .main-content {
            margin-left: 220px;
            padding: 30px;
        }

        header {
            background-color: #ffffff;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dashboard-title {
            font-size: 24px;
            font-weight: bold;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .card {
            background: linear-gradient(145deg, #ffffff 0%, #f8fbff 100%);
            padding: 25px 20px;
            border-radius: 18px;
            box-shadow: 0 8px 25px rgba(36, 113, 163, 0.15), 0 3px 10px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 2px solid transparent;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #229954, #27ae60, #2ecc71);
        }
        .card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 30px rgba(34, 153, 84, 0.2), 0 5px 15px rgba(0,0,0,0.15);
            border-color: #2ecc71;
        }

        .card i {
            font-size: 2.5em;
            background: linear-gradient(135deg, #229954, #27ae60, #2ecc71);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            filter: drop-shadow(0 2px 4px rgba(34, 153, 84, 0.3));
        }

        .card h3 {
            margin-top: 10px;
            font-size: 22px;
            color: #229954;
            font-weight: bold;
        }

        .card p {
            font-size: 16px;
            color: #5d6d7e;
            margin-bottom: 15px;
        }

        canvas {
            margin-top: 40px;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(34, 153, 84, 0.15), 0 3px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #27ae60;
        }
        
        /* Animations */
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
        
        .card {
            animation: fadeInUp 0.6s ease-out;
        }
        
        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }

        .logout-btn {
            color: #e74c3c;
            font-weight: bold;
            text-decoration: none;
        }

        .logout-btn:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2><i class="fa-solid fa-user-nurse"></i> Assistant</h2>
    <a href="#"><i class="fa fa-home"></i> 🏠 Dashboard</a>
    <a href="liste-medicaments"><i class="fa-solid fa-capsules"></i> 💊 Médicaments</a>
    <a href="ventes?action=list"><i class="fa-solid fa-cash-register"></i> 💳 Nouvelle Vente</a>
    <a href="ventes?action=history"><i class="fa fa-history"></i> 📅 Historique</a>
    <a href="alertes"><i class="fa fa-exclamation-triangle"></i> ⚠️ Alertes</a>
    <a href="statistiques"><i class="fa fa-chart-bar"></i> 📊 Statistiques</a>
    <a href="logout" class="logout-btn" onclick="return confirm('Êtes-vous sûr de vouloir vous déconnecter ?');"><i class="fa fa-sign-out-alt"></i> Déconnexion</a>
</div>

<div class="main-content">
    <header>
        <div class="dashboard-title" style="font-size: 1.8em; font-weight: bold; color: #229954; text-shadow: 0 2px 4px rgba(34, 153, 84, 0.2);">👩‍⚕️ Bienvenue, <%= username %></div>
        <div style="color: #555; font-size: 1.2em; margin-top: 8px; padding: 8px 15px; background: rgba(34, 153, 84, 0.1); border-radius: 20px; display: inline-block;"><i class="fa fa-user-nurse" style="color: #27ae60;"></i> Rôle : Assistant</div>
    </header>

    <div class="stats">
        <div class="card">
            <i class="fa-solid fa-capsules"></i>
            <h3>💊 120</h3>
            <p>Médicaments consultés</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-cash-register"></i>
            <h3>💳 62</h3>
            <p>Ventes enregistrées</p>
        </div>
        <div class="card">
            <i class="fa fa-history"></i>
            <h3>📅 180</h3>
            <p>Historique des ventes</p>
        </div>
        <div class="card">
            <i class="fa fa-exclamation-triangle"></i>
            <h3>⚠️ 3</h3>
            <p>Alertes en attente</p>
        </div>
    </div>

    <canvas id="venteChart" height="100"></canvas>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('venteChart').getContext('2d');
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
            datasets: [{
                label: 'Ventes quotidiennes',
                data: [12, 19, 14, 17, 20, 23],
                backgroundColor: '#27ae60',
                borderColor: '#1e8449',
                borderWidth: 2,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>

</body>
</html>
