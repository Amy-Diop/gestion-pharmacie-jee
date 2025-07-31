<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.gestionpharmacie.model.Medicament" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("../access-denied.jsp");
        return;
    }
    List<Medicament> medicaments = (List<Medicament>) request.getAttribute("medicaments");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouvelle Vente - Pharmacie</title>
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
            max-width: 1000px;
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #27ae60;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .medicament-row {
            display: flex;
            gap: 15px;
            align-items: end;
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .btn-add {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .total-section {
            background: #e8f8f5;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .btn-submit {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.4);
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
    <h1><i class="fa fa-cash-register"></i> 💳 Nouvelle Vente</h1>

    <form method="post" action="ventes?action=create" id="venteForm">
        <div class="form-group">
            <label for="clientNom">Nom du Client (optionnel) :</label>
            <input type="text" id="clientNom" name="clientNom" placeholder="Nom du client ou laisser vide pour 'Client anonyme'">
        </div>

        <div class="form-group">
            <label for="modePaiement">Mode de Paiement :</label>
            <select id="modePaiement" name="modePaiement" required>
                <option value="">-- Sélectionner --</option>
                <option value="ESPECES">Espèces</option>
                <option value="CARTE">Carte bancaire</option>
                <option value="MOBILE">Paiement mobile</option>
                <option value="CHEQUE">Chèque</option>
            </select>
        </div>

        <h3>Médicaments :</h3>
        <button type="button" class="btn-add" onclick="ajouterMedicament()">
            <i class="fa fa-plus"></i> Ajouter un médicament
        </button>

        <div id="medicaments-container">
            <div class="medicament-row">
                <div style="flex: 2;">
                    <label>Médicament :</label>
                    <select name="medicament" required onchange="updatePrix(this)">
                        <option value="">-- Sélectionner --</option>
                        <% if (medicaments != null) {
                            for (Medicament med : medicaments) { %>
                        <option value="<%= med.getId() %>" data-prix="<%= med.getPrix() %>" data-stock="<%= med.getStock() %>">
                            <%= med.getNom() %> - <%= med.getPrix() %> FCFA (Stock: <%= med.getStock() %>)
                        </option>
                        <% } } %>
                    </select>
                </div>
                <div style="flex: 1;">
                    <label>Quantité :</label>
                    <input type="number" name="quantite" min="1" required onchange="calculerTotal()">
                </div>
                <div style="flex: 1;">
                    <label>Prix unitaire :</label>
                    <input type="number" class="prix-unitaire" readonly>
                </div>
                <div style="flex: 1;">
                    <label>Sous-total :</label>
                    <input type="number" class="sous-total" readonly>
                </div>
                <div>
                    <button type="button" class="btn-remove" onclick="supprimerMedicament(this)">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="total-section">
            <h3>Récapitulatif :</h3>
            <p><strong>Total à payer : <span id="montantTotal">0</span> FCFA</strong></p>
            
            <div class="form-group">
                <label for="montantRecu">Montant reçu :</label>
                <input type="number" id="montantRecu" name="montantRecu" min="0" step="0.01" required onchange="calculerMonnaie()">
            </div>
            
            <p><strong>Monnaie à rendre : <span id="monnaie">0</span> FCFA</strong></p>
        </div>

        <input type="hidden" id="montantTotalHidden" name="montantTotal" value="0">
        <input type="hidden" id="monnaieHidden" name="monnaie" value="0">

        <button type="submit" class="btn-submit">
            <i class="fa fa-check"></i> Finaliser la Vente
        </button>
    </form>

    <% if ("ADMIN".equals(role)) { %>
        <a class="back-link" href="admin-dashboard.jsp">🔙 Retour Dashboard Admin</a>
    <% } else if ("PHARMACIEN".equals(role)) { %>
        <a class="back-link" href="pharmacien-dashboard.jsp">🔙 Retour Dashboard Pharmacien</a>
    <% } else { %>
        <a class="back-link" href="assistant-dashboard.jsp">🔙 Retour Dashboard Assistant</a>
    <% } %>
</div>

<script>
function ajouterMedicament() {
    const container = document.getElementById('medicaments-container');
    const newRow = container.firstElementChild.cloneNode(true);
    
    // Reset values
    newRow.querySelectorAll('input, select').forEach(input => {
        input.value = '';
    });
    
    container.appendChild(newRow);
}

function supprimerMedicament(button) {
    const container = document.getElementById('medicaments-container');
    if (container.children.length > 1) {
        button.closest('.medicament-row').remove();
        calculerTotal();
    }
}

function updatePrix(select) {
    const row = select.closest('.medicament-row');
    const prixInput = row.querySelector('.prix-unitaire');
    const selectedOption = select.options[select.selectedIndex];
    
    if (selectedOption.value) {
        prixInput.value = selectedOption.dataset.prix;
    } else {
        prixInput.value = '';
    }
    calculerTotal();
}

function calculerTotal() {
    let total = 0;
    const rows = document.querySelectorAll('.medicament-row');
    
    rows.forEach(row => {
        const select = row.querySelector('select[name="medicament"]');
        const quantite = row.querySelector('input[name="quantite"]').value;
        const sousTotal = row.querySelector('.sous-total');
        
        if (select.value && quantite) {
            const prix = parseFloat(select.options[select.selectedIndex].dataset.prix || 0);
            const sousT = prix * parseInt(quantite);
            sousTotal.value = sousT;
            total += sousT;
        } else {
            sousTotal.value = '';
        }
    });
    
    document.getElementById('montantTotal').textContent = total;
    document.getElementById('montantTotalHidden').value = total;
    calculerMonnaie();
}

function calculerMonnaie() {
    const total = parseFloat(document.getElementById('montantTotalHidden').value || 0);
    const recu = parseFloat(document.getElementById('montantRecu').value || 0);
    const monnaie = Math.max(0, recu - total);
    
    document.getElementById('monnaie').textContent = monnaie;
    document.getElementById('monnaieHidden').value = monnaie;
}
</script>
</body>
</html>