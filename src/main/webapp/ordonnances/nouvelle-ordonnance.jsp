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
    <title>Nouvelle Ordonnance - Pharmacie</title>
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
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #27ae60;
            border-radius: 8px;
            font-size: 16px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
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
    <h1><i class="fa fa-file-medical"></i> Nouvelle Ordonnance</h1>

    <form method="post" action="ordonnances?action=create" id="ordonnanceForm">
        <div class="form-group">
            <label for="patientNom">Nom du Patient :</label>
            <input type="text" id="patientNom" name="patientNom" required>
        </div>

        <div class="form-group">
            <label for="medecinNom">Nom du Médecin :</label>
            <input type="text" id="medecinNom" name="medecinNom" required>
        </div>

        <div class="form-group">
            <label for="notes">Notes :</label>
            <textarea id="notes" name="notes" placeholder="Notes sur l'ordonnance..."></textarea>
        </div>

        <h3>Médicaments prescrits :</h3>
        <button type="button" class="btn-add" onclick="ajouterMedicament()">
            <i class="fa fa-plus"></i> Ajouter un médicament
        </button>

        <div id="medicaments-container">
            <div class="medicament-row">
                <div style="flex: 2;">
                    <label>Médicament :</label>
                    <select name="medicament" required>
                        <option value="">-- Sélectionner --</option>
                        <% if (medicaments != null) {
                            for (Medicament med : medicaments) { %>
                        <option value="<%= med.getId() %>">
                            <%= med.getNom() %> - <%= med.getPrix() %> FCFA
                        </option>
                        <% } } %>
                    </select>
                </div>
                <div style="flex: 1;">
                    <label>Quantité :</label>
                    <input type="number" name="quantite" min="1" required>
                </div>
                <div style="flex: 2;">
                    <label>Durée du traitement :</label>
                    <input type="text" name="duree" placeholder="Ex: 7 jours, 2 semaines...">
                </div>
                <div>
                    <button type="button" class="btn-remove" onclick="supprimerMedicament(this)">
                        <i class="fa fa-trash"></i>
                    </button>
                </div>
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fa fa-save"></i> Créer l'Ordonnance
        </button>
    </form>

    <a class="back-link" href="ordonnances">Retour Liste Ordonnances</a>
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
    }
}
</script>
</body>
</html>