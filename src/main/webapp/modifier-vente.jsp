<%--
  Created by IntelliJ IDEA.
  User: Easy
  Date: 23/07/2025
  Time: 21:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.gestionpharmacie.model.Vente" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || (!"ADMIN".equals(role) && !"PHARMACIEN".equals(role))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Vente vente = (Vente) request.getAttribute("vente");
    List<String[]> medicaments = (List<String[]>) request.getAttribute("medicaments");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Modifier une Vente</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
        .container {
            width: 40%; margin: 50px auto; background: white; padding: 20px;
            box-shadow: 0 0 10px #ccc; border-radius: 8px;
        }
        h1 { color: #f39c12; text-align: center; }
        label { display: block; font-weight: bold; margin-top: 10px; }
        select, input[type="number"], input[type="date"] {
            width: 100%; padding: 8px; margin-top: 5px; margin-bottom: 15px;
            border: 1px solid #ccc; border-radius: 5px;
        }
        button {
            background-color: #f39c12; color: white;
            padding: 10px; border: none; border-radius: 5px;
            width: 100%; font-size: 16px;
        }
        button:hover { background-color: #d88d0a; }
        a { display: block; margin-top: 10px; text-align: center; color: #2980b9; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <h1>✏️ Modifier une Vente</h1>
    <form method="get" action="ventes">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= vente.getId() %>">

        <label for="medicament_id">Médicament :</label>
        <select id="medicament_id" name="medicament_id" required>
            <option value="">-- Sélectionner un médicament --</option>
            <%
                if (medicaments != null) {
                    for (String[] m : medicaments) {
                        String selected = (Integer.parseInt(m[0]) == vente.getMedicamentId()) ? "selected" : "";
            %>
            <option value="<%= m[0] %>" <%= selected %>><%= m[1] %></option>
            <%
                    }
                }
            %>
        </select>

        <label for="quantite">Quantité :</label>
        <input type="number" id="quantite" name="quantite" min="1" required value="<%= vente.getQuantite() %>">

        <label for="date_vente">Date de Vente :</label>
        <input type="date" id="date_vente" name="date_vente" required value="<%= vente.getDateVente() %>">

        <button type="submit">Modifier</button>
    </form>
    <a href="ventes">⬅ Retour à la liste</a>
</div>
</body>
</html>
