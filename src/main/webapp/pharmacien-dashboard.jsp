<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"PHARMACIEN".equals(role)) {
        response.sendRedirect("access-denied.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Pharmacien</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #e8f8f5 0%, #d1f2eb 50%, #f8f9fa 100%);
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
                radial-gradient(circle at 25% 75%, rgba(22, 160, 133, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 75% 25%, rgba(26, 188, 156, 0.08) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 220px;
            height: 100%;
            background: linear-gradient(180deg, #0d7377 0%, #14a085 50%, #2d8659 100%);
            color: #fff;
            padding-top: 20px;
            box-shadow: 3px 0 20px rgba(13, 115, 119, 0.3);
            border-right: 3px solid #2d8659;
        }
        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="pills" patternUnits="userSpaceOnUse" width="25" height="25"><circle cx="12.5" cy="12.5" r="2" fill="%23ffffff" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23pills)"/></svg>');
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
            background-color: #0a5d61;
            color: #fff;
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
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            padding: 25px 20px;
            border-radius: 18px;
            box-shadow: 0 8px 25px rgba(19, 141, 117, 0.15), 0 3px 10px rgba(0,0,0,0.1);
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
            background: linear-gradient(90deg, #0d7377, #14a085, #2d8659);
        }
        .card:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 12px 30px rgba(19, 141, 117, 0.2), 0 5px 15px rgba(0,0,0,0.15);
            border-color: #2d8659;
        }

        .card i {
            font-size: 2.5em;
            background: linear-gradient(135deg, #0d7377, #14a085, #2d8659);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            filter: drop-shadow(0 2px 4px rgba(19, 141, 117, 0.3));
        }

        .card h3 {
            margin-top: 10px;
            font-size: 22px;
            color: #0d7377;
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
            box-shadow: 0 8px 25px rgba(19, 141, 117, 0.15), 0 3px 10px rgba(0,0,0,0.1);
            border-top: 4px solid #16a085;
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
        .card:nth-child(5) { animation-delay: 0.5s; }
        .card:nth-child(6) { animation-delay: 0.6s; }

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
    <h2><i class="fa-solid fa-user-doctor"></i> Pharmacien</h2>
    <a href="#"><i class="fa fa-home"></i> 🏠 Dashboard</a>
    <a href="liste-medicaments"><i class="fa-solid fa-capsules"></i> 💊 Médicaments</a>
    <a href="ventes?action=list"><i class="fa-solid fa-cash-register"></i> 💰 Ventes</a>
    <a href="ordonnances"><i class="fa-solid fa-prescription"></i> 📄 Ordonnances</a>
    <a href="alertes"><i class="fa fa-exclamation-triangle"></i> ⚠️ Alertes Stock</a>
    <a href="peremption"><i class="fa fa-calendar-times"></i> 📅 Péremptions</a>
    <a href="statistiques"><i class="fa fa-chart-bar"></i> 📊 Statistiques</a>
    <a href="logout" class="logout-btn" onclick="return confirm('Êtes-vous sûr de vouloir vous déconnecter ?');"><i class="fa fa-sign-out-alt"></i> Déconnexion</a>
</div>

<div class="main-content">
    <header>
        <div class="dashboard-title" style="font-size: 1.8em; font-weight: bold; color: #0d7377; text-shadow: 0 2px 4px rgba(13, 115, 119, 0.2);">👨‍⚕️ Bienvenue, <%= username %></div>
        <div style="color: #555; font-size: 1.2em; margin-top: 8px; padding: 8px 15px; background: rgba(13, 115, 119, 0.1); border-radius: 20px; display: inline-block;"><i class="fa fa-user-nurse" style="color: #14a085;"></i> Rôle : Pharmacien</div>
    </header>

    <div class="stats">
        <div class="card">
            <i class="fa-solid fa-capsules"></i>
            <h3>💊 132</h3>
            <p>Médicaments en stock</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-cash-register"></i>
            <h3>💰 78</h3>
            <p>Ventes aujourd'hui</p>
        </div>
        <div class="card">
            <i class="fa fa-exclamation-triangle"></i>
            <h3>⚠️ 5</h3>
            <p>Alertes stock faible</p>
        </div>
        <div class="card">
            <i class="fa fa-calendar-times"></i>
            <h3>📅 12</h3>
            <p>Expiration < 30j</p>
        </div>
        <div class="card">
            <i class="fa-solid fa-prescription"></i>
            <h3>📄 23</h3>
            <p>Ordonnances traitées</p>
        </div>
        <div class="card">
            <i class="fa fa-chart-line"></i>
            <h3>📈 +12%</h3>
            <p>Progression mensuelle</p>
        </div>
    </div>

    <canvas id="salesChart" height="100"></canvas>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('salesChart').getContext('2d');
    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Janv', 'Févr', 'Mars', 'Avr', 'Mai', 'Juin'],
            datasets: [{
                label: 'Ventes Mensuelles',
                data: [90, 120, 150, 180, 160, 190],
                backgroundColor: 'rgba(22, 160, 133, 0.2)',
                borderColor: '#14a085',
                borderWidth: 2,
                fill: true,
                tension: 0.3
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
