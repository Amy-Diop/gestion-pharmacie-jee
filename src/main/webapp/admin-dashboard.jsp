<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");
  if (username == null || !"ADMIN".equals(role)) {
    response.sendRedirect("access-denied.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Dashboard Admin - Gestion Pharmacie</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #e8f8f5 0%, #d5f4e6 50%, #fafafa 100%);
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
        radial-gradient(circle at 20% 80%, rgba(39, 174, 96, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 80% 20%, rgba(46, 204, 113, 0.1) 0%, transparent 50%);
      pointer-events: none;
      z-index: -1;
    }
    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      width: 220px;
      height: 100%;
      background: linear-gradient(180deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
      color: #fff;
      padding-top: 20px;
      box-shadow: 2px 0 20px rgba(30, 132, 73, 0.3);
      border-right: 3px solid #2ecc71;
    }
    .sidebar::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="cross" patternUnits="userSpaceOnUse" width="20" height="20"><path d="M10,2 L10,18 M2,10 L18,10" stroke="%23ffffff" stroke-width="0.5" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23cross)"/></svg>');
      opacity: 0.3;
      pointer-events: none;
    }
    .sidebar h2 {
      text-align: center;
      margin-bottom: 30px;
      font-size: 22px;
      color: #fff;
      letter-spacing: 1px;
      font-weight: bold;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      background: rgba(255,255,255,0.1);
      padding: 15px 10px;
      margin: 0 10px 30px 10px;
      border-radius: 12px;
      border: 2px solid rgba(255,255,255,0.2);
      text-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }
    .sidebar a {
      display: block;
      padding: 12px 20px;
      color: #eafaf1;
      text-decoration: none;
      transition: background 0.3s, color 0.3s;
      font-size: 1.08em;
      border-radius: 8px 0 0 8px;
      margin-bottom: 4px;
    }
    .sidebar a:hover, .sidebar a.active {
      background: #219150;
      color: #fff;
    }
    .main-content {
      margin-left: 220px;
      padding: 30px;
    }
    .card {
      background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
      border-radius: 20px;
      box-shadow: 0 8px 25px rgba(30, 132, 73, 0.15), 0 3px 10px rgba(0,0,0,0.1);
      padding: 28px 24px 20px 24px;
      margin: 18px 18px 18px 0;
      display: inline-block;
      vertical-align: top;
      width: 260px;
      min-height: 170px;
      text-align: center;
      transition: all 0.3s ease;
      position: relative;
      border: 3px solid transparent;
      background-clip: padding-box;
      overflow: hidden;
    }
    .card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, #1e8449, #27ae60, #2ecc71);
    }
    .card::after {
      content: '';
      position: absolute;
      top: 10px;
      right: 10px;
      width: 30px;
      height: 30px;
      background: radial-gradient(circle, rgba(46, 204, 113, 0.1) 0%, transparent 70%);
      border-radius: 50%;
    }
    .card i {
      font-size: 2.8em;
      background: linear-gradient(135deg, #1e8449, #27ae60, #2ecc71);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 15px;
      filter: drop-shadow(0 2px 4px rgba(30, 132, 73, 0.3));
    }
    .card h3 {
      margin: 10px 0 8px 0;
      color: #219150;
      font-size: 1.3em;
    }
    .card p {
      color: #555;
      font-size: 1em;
      margin-bottom: 18px;
    }
    .card a {
      display: inline-block;
      padding: 10px 25px;
      background: linear-gradient(135deg, #1e8449 0%, #27ae60 50%, #2ecc71 100%);
      color: #fff;
      border-radius: 25px;
      text-decoration: none;
      font-weight: bold;
      font-size: 1.08em;
      margin-top: 15px;
      transition: all 0.3s ease;
      border: 2px solid transparent;
      box-shadow: 0 4px 15px rgba(30, 132, 73, 0.3);
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .card a:hover {
      background: linear-gradient(135deg, #2ecc71 0%, #27ae60 50%, #1e8449 100%);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(30, 132, 73, 0.4);
      border-color: rgba(255,255,255,0.3);
    }
    .card:hover {
      transform: translateY(-8px) scale(1.02);
      box-shadow: 0 15px 35px rgba(30, 132, 73, 0.25), 0 5px 15px rgba(0,0,0,0.15);
      border-color: #2ecc71;
    }
    @media (max-width: 900px) {
      .main-content { padding: 10px; }
      .card { width: 98%; margin: 10px 0; }
    }
    canvas {
      margin-top: 40px;
      background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
      padding: 25px;
      border-radius: 20px;
      box-shadow: 0 8px 25px rgba(30, 132, 73, 0.15), 0 3px 10px rgba(0,0,0,0.1);
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
    .card:nth-child(5) { animation-delay: 0.5s; }
    .card:nth-child(6) { animation-delay: 0.6s; }
  </style>
  <script>
    function confirmLogout() {
      return confirm("Voulez-vous vraiment vous déconnecter ?");
    }
  </script>
</head>
<body>

<div class="sidebar">
  <h2><i class="fa-solid fa-user-md"></i> Admin Pharmacie</h2>
  <a href="admin-dashboard.jsp"><i class="fa fa-home"></i> Dashboard</a>
  <a href="liste-medicaments"><i class="fa fa-pills"></i> Médicaments</a>
  <a href="utilisateurs?action=list"><i class="fa fa-user"></i> Utilisateurs</a>
  <a href="fournisseurs"><i class="fa fa-truck"></i> Fournisseurs</a>
  <a href="categories"><i class="fa fa-tags"></i> Catégories</a>
  <a href="ventes?action=list"><i class="fa fa-cash-register"></i> Ventes</a>
  <a href="statistiques.jsp"><i class="fa fa-chart-bar"></i> Statistiques</a>
  <a href="logout" onclick="return confirmLogout();" class="logout"><i class="fa fa-sign-out-alt"></i> Déconnexion</a>
</div>

<div class="main-content">
  <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px;">
    <div style="text-align: left;">
      <div class="dashboard-title" style="font-size: 1.8em; font-weight: bold; color: #1e8449; text-shadow: 0 2px 4px rgba(30, 132, 73, 0.2);">🏥 Bienvenue, <%= username %></div>
    </div>
    <div style="text-align: right;">
      <div style="color: #555; font-size: 1.2em; padding: 8px 15px; background: rgba(30, 132, 73, 0.1); border-radius: 20px; display: inline-block;"><i class="fa fa-user-shield" style="color: #27ae60;"></i> Rôle : Administrateur</div>
    </div>
  </header>

  <div class="stats">
    <div style="display: flex; flex-wrap: wrap; justify-content: flex-start; column-gap: 70px; row-gap: 18px;">
      <!-- Ligne 1 -->
      <div class="card">
        <i class="fa-solid fa-capsules"></i>
        <h3>💊 Médicaments</h3>
        <p>Gérer les stocks et les infos médicaments</p>
        <a href="liste-medicaments">📋 Gérer</a>
      </div>
      <div class="card">
        <i class="fa-solid fa-user-nurse"></i>
        <h3>👥 Utilisateurs</h3>
        <p>Pharmaciens, assistants et admins</p>
        <a href="utilisateurs?action=list">👤 Gérer</a>
      </div>
      <div class="card">
        <i class="fa-solid fa-truck-medical"></i>
        <h3>🚛 Fournisseurs</h3>
        <p>Laboratoires et distributeurs</p>
        <a href="fournisseurs">🏭 Gérer</a>
      </div>
      <div class="card">
        <i class="fa-solid fa-layer-group"></i>
        <h3>🏷️ Catégories</h3>
        <p>Classification pharmaceutique</p>
        <a href="categories">📂 Gérer</a>
      </div>
    </div>
    <div style="display: flex; flex-wrap: wrap; justify-content: flex-start; column-gap: 70px; row-gap: 18px; margin-top: 10px;">
      <!-- Ligne 2 -->
      <div class="card">
        <i class="fa-solid fa-receipt"></i>
        <h3>💰 Ventes</h3>
        <p>Transactions et ordonnances</p>
        <a href="ventes?action=list">💳 Consulter</a>
      </div>
      <div class="card">
        <i class="fa-solid fa-chart-pie"></i>
        <h3>📊 Statistiques</h3>
        <p>Analyses et rapports</p>
        <a href="statistiques.jsp">📈 Analyser</a>
      </div>
    </div>
  </div>

  <canvas id="salesChart" height="100"></canvas>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
  const ctx = document.getElementById('salesChart').getContext('2d');
  const chart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['Janv', 'Févr', 'Mars', 'Avr', 'Mai', 'Juin'],
      datasets: [{
        label: 'Ventes Mensuelles',
        data: [120, 190, 300, 250, 180, 220],
        backgroundColor: '#27ae60'
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
