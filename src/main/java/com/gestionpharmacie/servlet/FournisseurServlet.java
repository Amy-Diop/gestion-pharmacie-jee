package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.FournisseurDAO;
import com.gestionpharmacie.model.Fournisseur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/fournisseurs")
public class FournisseurServlet extends HttpServlet {
    private FournisseurDAO fournisseurDAO;

    @Override
    public void init() {
        fournisseurDAO = new FournisseurDAO();
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
                case "edit":
                    afficherFormulaireEdition(request, response);
                    break;
                case "delete":
                    supprimerFournisseur(request, response);
                    break;
                default:
                    listerFournisseurs(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement de l'action GET", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "insert":
                    insererFournisseur(request, response);
                    break;
                case "update":
                    mettreAJourFournisseur(request, response);
                    break;
                default:
                    response.sendRedirect("fournisseurs?action=list");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la sauvegarde du fournisseur", e);
        }
    }

    private void listerFournisseurs(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String search = request.getParameter("search");
        int page = 1;
        int itemsPerPage = 10;
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        List<Fournisseur> allFournisseurs;
        if (search != null && !search.trim().isEmpty()) {
            allFournisseurs = fournisseurDAO.rechercherFournisseurs(search.trim());
        } else {
            allFournisseurs = fournisseurDAO.listerFournisseurs();
        }
        
        // Pagination
        int totalItems = allFournisseurs.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        List<Fournisseur> fournisseurs = allFournisseurs.subList(startIndex, endIndex);
        
        request.setAttribute("fournisseurs", fournisseurs);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        
        request.getRequestDispatcher("/fournisseurs/liste-fournisseurs.jsp").forward(request, response);
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("fournisseur", null);
        request.getRequestDispatcher("/fournisseurs/form-fournisseur.jsp").forward(request, response);
    }

    private void afficherFormulaireEdition(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Fournisseur fournisseur = fournisseurDAO.getFournisseurById(id);
        request.setAttribute("fournisseur", fournisseur);
        request.getRequestDispatcher("/fournisseurs/form-fournisseur.jsp").forward(request, response);
    }

    private void insererFournisseur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Fournisseur fournisseur = extraireFournisseurFromRequest(request);
        
        if (fournisseur.getNom() != null && !fournisseur.getNom().trim().isEmpty()) {
            fournisseurDAO.ajouterFournisseur(fournisseur);
            System.out.println("Fournisseur ajouté avec succès: " + fournisseur.getNom());
        }

        response.sendRedirect("fournisseurs?action=list");
    }

    private void mettreAJourFournisseur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Fournisseur fournisseur = extraireFournisseurFromRequest(request);
        int id = Integer.parseInt(request.getParameter("id"));
        fournisseur.setId(id);

        if (fournisseur.getNom() != null && !fournisseur.getNom().trim().isEmpty()) {
            fournisseurDAO.modifierFournisseur(fournisseur);
            System.out.println("Fournisseur modifié avec succès: ID=" + id + ", Nom=" + fournisseur.getNom());
        }

        response.sendRedirect("fournisseurs?action=list");
    }

    private void supprimerFournisseur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        fournisseurDAO.supprimerFournisseur(id);
        System.out.println("Fournisseur supprimé avec succès: ID=" + id);
        response.sendRedirect("fournisseurs?action=list");
    }

    private Fournisseur extraireFournisseurFromRequest(HttpServletRequest request) {
        Fournisseur fournisseur = new Fournisseur();
        fournisseur.setNom(request.getParameter("nom"));
        fournisseur.setAdresse(request.getParameter("adresse"));
        fournisseur.setTelephone(request.getParameter("telephone"));
        fournisseur.setEmail(request.getParameter("email"));
        fournisseur.setProduitsFournis(request.getParameter("produitsFournis"));
        fournisseur.setNumeroImmatriculation(request.getParameter("numeroImmatriculation"));
        fournisseur.setConditionsPaiement(request.getParameter("conditionsPaiement"));
        return fournisseur;
    }
}