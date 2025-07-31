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
    <title>Gestion des Ordonnances - Pharmacie</title>
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
            max-width: 1200px;
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
        .ordonnances-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .ordonnance-card {
            background: linear-gradient(145deg, #ffffff 0%, #fff8e1 100%);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(255, 152, 0, 0.1);
            border-left: 5px solid #ff9800;
            transition: all 0.3s ease;
        }
        .ordonnance-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(255, 152, 0, 0.2);
        }
        .ordonnance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .ordonnance-numero {
            font-weight: bold;
            color: #ff9800;
            font-size: 1.2em;
        }
        .status-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
            color: white;
        }
        .status-attente { background: #ff9800; }
        .status-traitee { background: #4caf50; }
        .status-livree { background: #2196f3; }
        .patient-info {
            margin-bottom: 15px;
        }
        .patient-nom {
            font-weight: bold;
            color: #333;
            font-size: 1.1em;
        }
        .medecin-nom {
            color: #666;
            font-size: 0.9em;
        }
        .medicaments-list {
            background: rgba(255, 152, 0, 0.05);
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
        }
        .medicament-item {
            padding: 8px 0;
            border-bottom: 1px solid rgba(255, 152, 0, 0.1);
        }
        .medicament-item:last-child {
            border-bottom: none;
        }
        .actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        .btn-action {
            padding: 8px 15px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }
        .btn-traiter {
            background: #4caf50;
            color: white;
        }
        .btn-livrer {
            background: #2196f3;
            color: white;
        }
        .btn-voir {
            background: #ff9800;
            color: white;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .btn-retour {
            display: block;
            width: fit-content;
            margin: 30px auto 0;
            background: linear-gradient(145deg, #ffffff 0%, #f8fffe 100%);
            color: #ff9800;
            border: 3px solid #ff9800;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-retour:hover {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: #fff;
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
<div class="container">
    <h1><i class="fa fa-prescription"></i> 📄 Gestion des Ordonnances</h1>
    
    <div class="ordonnances-grid">
        <!-- Ordonnance 1 -->
        <div class="ordonnance-card">
            <div class="ordonnance-header">
                <div class="ordonnance-numero">📋 ORD-2024-001</div>
                <span class="status-badge status-attente">⏳ En attente</span>
            </div>
            <div class="patient-info">
                <div class="patient-nom">👤 Aminata DIALLO</div>
                <div class="medecin-nom">👨‍⚕️ Dr. Mamadou FALL</div>
            </div>
            <div class="medicaments-list">
                <div class="medicament-item">
                    <strong>💊 Amoxicilline 500mg</strong><br>
                    <small>1 comprimé 3 fois/jour - 7 jours</small>
                </div>
                <div class="medicament-item">
                    <strong>💊 Paracétamol 1000mg</strong><br>
                    <small>Si douleur, max 3/jour</small>
                </div>
            </div>
            <div class="actions">
                <a href="#" class="btn-action btn-traiter">✅ Traiter</a>
                <a href="#" class="btn-action btn-voir">👁️ Voir</a>
            </div>
        </div>

        <!-- Ordonnance 2 -->
        <div class="ordonnance-card">
            <div class="ordonnance-header">
                <div class="ordonnance-numero">📋 ORD-2024-002</div>
                <span class="status-badge status-traitee">✅ Traitée</span>
            </div>
            <div class="patient-info">
                <div class="patient-nom">👤 Ousmane NDIAYE</div>
                <div class="medecin-nom">👨‍⚕️ Dr. Fatou SECK</div>
            </div>
            <div class="medicaments-list">
                <div class="medicament-item">
                    <strong>💊 Ibuprofène 400mg</strong><br>
                    <small>1 comprimé 2 fois/jour après repas</small>
                </div>
            </div>
            <div class="actions">
                <a href="#" class="btn-action btn-livrer">🚚 Livrer</a>
                <a href="#" class="btn-action btn-voir">👁️ Voir</a>
            </div>
        </div>

        <!-- Ordonnance 3 -->
        <div class="ordonnance-card">
            <div class="ordonnance-header">
                <div class="ordonnance-numero">📋 ORD-2024-003</div>
                <span class="status-badge status-livree">🚚 Livrée</span>
            </div>
            <div class="patient-info">
                <div class="patient-nom">👤 Khady KANE</div>
                <div class="medecin-nom">👨‍⚕️ Dr. Ibrahima BA</div>
            </div>
            <div class="medicaments-list">
                <div class="medicament-item">
                    <strong>💊 Oméprazole 20mg</strong><br>
                    <small>1 comprimé le matin à jeun</small>
                </div>
            </div>
            <div class="actions">
                <a href="#" class="btn-action btn-voir">👁️ Voir</a>
            </div>
        </div>

        <!-- Ordonnance 4 -->
        <div class="ordonnance-card">
            <div class="ordonnance-header">
                <div class="ordonnance-numero">📋 ORD-2024-004</div>
                <span class="status-badge status-attente">⏳ En attente</span>
            </div>
            <div class="patient-info">
                <div class="patient-nom">👤 Moussa SARR</div>
                <div class="medecin-nom">👨‍⚕️ Dr. Aïssatou DIOP</div>
            </div>
            <div class="medicaments-list">
                <div class="medicament-item">
                    <strong>💊 Vitamine C 1000mg</strong><br>
                    <small>1 comprimé/jour pendant 30 jours</small>
                </div>
                <div class="medicament-item">
                    <strong>💊 Aspirine 500mg</strong><br>
                    <small>1/2 comprimé si fièvre</small>
                </div>
            </div>
            <div class="actions">
                <a href="#" class="btn-action btn-traiter">✅ Traiter</a>
                <a href="#" class="btn-action btn-voir">👁️ Voir</a>
            </div>
        </div>
    </div>

    <a class="btn-retour" href="pharmacien-dashboard.jsp">
        <i class="fa fa-arrow-left"></i> 🔙 Retour Dashboard Pharmacien
    </a>
</div>
</body>
</html>