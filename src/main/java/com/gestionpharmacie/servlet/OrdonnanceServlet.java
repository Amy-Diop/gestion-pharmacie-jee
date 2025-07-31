package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.OrdonnanceDAO;
import com.gestionpharmacie.dao.MedicamentDAO;
import com.gestionpharmacie.model.Ordonnance;
import com.gestionpharmacie.model.Medicament;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ordonnances")
public class OrdonnanceServlet extends HttpServlet {
    private OrdonnanceDAO ordonnanceDAO;
    private MedicamentDAO medicamentDAO;

    @Override
    public void init() {
        ordonnanceDAO = new OrdonnanceDAO();
        medicamentDAO = new MedicamentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    afficherFormulaireAjout(request, response);
                    break;
                case "validate":
                    validerOrdonnance(request, response);
                    break;
                default:
                    listerOrdonnances(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement des ordonnances", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    creerOrdonnance(request, response);
                    break;
                default:
                    response.sendRedirect("ordonnances");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la création de l'ordonnance", e);
        }
    }

    private void listerOrdonnances(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Ordonnance> ordonnances = ordonnanceDAO.listerOrdonnances();
        request.setAttribute("ordonnances", ordonnances);
        request.getRequestDispatcher("/ordonnances/liste-ordonnances.jsp").forward(request, response);
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Medicament> medicaments = medicamentDAO.listerMedicaments();
        request.setAttribute("medicaments", medicaments);
        request.getRequestDispatcher("/ordonnances/nouvelle-ordonnance.jsp").forward(request, response);
    }

    private void creerOrdonnance(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        String pharmacien = (String) session.getAttribute("username");
        
        // Récupérer les données du formulaire
        String patientNom = request.getParameter("patientNom");
        String medecinNom = request.getParameter("medecinNom");
        String notes = request.getParameter("notes");
        
        // Récupérer les médicaments prescrits
        String[] medicamentIds = request.getParameterValues("medicament");
        String[] quantites = request.getParameterValues("quantite");
        String[] durees = request.getParameterValues("duree");
        
        if (medicamentIds != null && quantites != null) {
            // Créer l'ordonnance
            Ordonnance ordonnance = new Ordonnance();
            ordonnance.setPatientNom(patientNom);
            ordonnance.setMedecinNom(medecinNom);
            ordonnance.setNotes(notes);
            ordonnance.setPharmacien(pharmacien);
            ordonnance.setStatut("EN_ATTENTE");
            
            // Enregistrer l'ordonnance
            int ordonnanceId = ordonnanceDAO.ajouterOrdonnance(ordonnance);
            
            // Enregistrer les détails des médicaments prescrits
            for (int i = 0; i < medicamentIds.length; i++) {
                if (medicamentIds[i] != null && !medicamentIds[i].isEmpty()) {
                    int medicamentId = Integer.parseInt(medicamentIds[i]);
                    int quantite = Integer.parseInt(quantites[i]);
                    String duree = durees[i];
                    
                    ordonnanceDAO.ajouterDetailOrdonnance(ordonnanceId, medicamentId, quantite, duree);
                }
            }
            
            System.out.println("Ordonnance créée avec succès: ID=" + ordonnanceId);
        }
        
        response.sendRedirect("ordonnances");
    }

    private void validerOrdonnance(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ordonnanceDAO.validerOrdonnance(id);
        response.sendRedirect("ordonnances");
    }
}