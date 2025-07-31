package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.MedicamentDAO;
import com.gestionpharmacie.dao.CategorieDAO;
import com.gestionpharmacie.dao.FournisseurDAO;
import com.gestionpharmacie.model.Medicament;
import com.gestionpharmacie.model.Categorie;
import com.gestionpharmacie.model.Fournisseur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet({"/ajouter-medicament", "/modifier-medicament", "/supprimer-medicament"})
public class MedicamentServlet extends HttpServlet {
    private MedicamentDAO medicamentDAO;
    private CategorieDAO categorieDAO;
    private FournisseurDAO fournisseurDAO;

    @Override
    public void init() {
        medicamentDAO = new MedicamentDAO();
        categorieDAO = new CategorieDAO();
        fournisseurDAO = new FournisseurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/ajouter-medicament":
                    afficherFormulaireAjout(request, response);
                    break;
                case "/modifier-medicament":
                    afficherFormulaireModification(request, response);
                    break;
                case "/supprimer-medicament":
                    supprimerMedicament(request, response);
                    break;
                default:
                    response.sendRedirect("liste-medicaments");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            switch (path) {
                case "/ajouter-medicament":
                    ajouterMedicament(request, response);
                    break;
                case "/modifier-medicament":
                    modifierMedicament(request, response);
                    break;
                default:
                    response.sendRedirect("liste-medicaments");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement", e);
        }
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Categorie> categories = categorieDAO.listerCategories();
        List<Fournisseur> fournisseurs = fournisseurDAO.listerFournisseurs();
        request.setAttribute("categories", categories);
        request.setAttribute("fournisseurs", fournisseurs);
        request.getRequestDispatcher("/medicaments/ajouter-medicament.jsp").forward(request, response);
    }

    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicament medicament = medicamentDAO.getMedicamentById(id);
        List<Categorie> categories = categorieDAO.listerCategories();
        List<Fournisseur> fournisseurs = fournisseurDAO.listerFournisseurs();
        
        request.setAttribute("medicament", medicament);
        request.setAttribute("categories", categories);
        request.setAttribute("fournisseurs", fournisseurs);
        request.getRequestDispatcher("/medicaments/modifier-medicament.jsp").forward(request, response);
    }

    private void ajouterMedicament(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Medicament medicament = creerMedicamentDepuisRequest(request);
        medicamentDAO.ajouterMedicament(medicament);
        response.sendRedirect("liste-medicaments");
    }

    private void modifierMedicament(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicament medicament = creerMedicamentDepuisRequest(request);
        medicament.setId(id);
        medicamentDAO.modifierMedicament(medicament);
        response.sendRedirect("liste-medicaments");
    }

    private void supprimerMedicament(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        medicamentDAO.supprimerMedicament(id);
        response.sendRedirect("liste-medicaments");
    }

    private Medicament creerMedicamentDepuisRequest(HttpServletRequest request) {
        Medicament medicament = new Medicament();
        medicament.setNom(request.getParameter("nom"));
        medicament.setDescription(request.getParameter("description"));
        medicament.setPrix(Double.parseDouble(request.getParameter("prix")));
        medicament.setStock(Integer.parseInt(request.getParameter("stock")));
        medicament.setSeuilAlerte(Integer.parseInt(request.getParameter("seuilAlerte")));
        
        String dateExpiration = request.getParameter("dateExpiration");
        if (dateExpiration != null && !dateExpiration.trim().isEmpty()) {
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                medicament.setDateExpiration(dateFormat.parse(dateExpiration));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        
        String categorieId = request.getParameter("categorieId");
        if (categorieId != null && !categorieId.trim().isEmpty()) {
            medicament.setCategorieId(Integer.parseInt(categorieId));
        } else {
            medicament.setCategorieId(0);
        }
        
        String fournisseurId = request.getParameter("fournisseurId");
        if (fournisseurId != null && !fournisseurId.trim().isEmpty()) {
            medicament.setFournisseurId(Integer.parseInt(fournisseurId));
        } else {
            medicament.setFournisseurId(0);
        }
        medicament.setActif(true);
        
        return medicament;
    }
}