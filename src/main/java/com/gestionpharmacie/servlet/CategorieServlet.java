package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.CategorieDAO;
import com.gestionpharmacie.model.Categorie;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/categories")
public class CategorieServlet extends HttpServlet {
    private CategorieDAO categorieDAO;

    @Override
    public void init() {
        categorieDAO = new CategorieDAO();
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
                    supprimerCategorie(request, response);
                    break;
                default:
                    listerCategories(request, response);
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
                    insererCategorie(request, response);
                    break;
                case "update":
                    mettreAJourCategorie(request, response);
                    break;
                default:
                    response.sendRedirect("categories?action=list");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du traitement de l'action POST", e);
        }
    }

    private void listerCategories(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String search = request.getParameter("search");
        List<Categorie> listeCategories;
        
        if (search != null && !search.trim().isEmpty()) {
            listeCategories = categorieDAO.rechercherCategories(search.trim());
        } else {
            listeCategories = categorieDAO.listerCategoriesAvecNombreMedicaments();
        }
        
        request.setAttribute("listeCategories", listeCategories);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/categories/liste-categories.jsp").forward(request, response);
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("categorie", null);
        request.getRequestDispatcher("/categories/form-categorie.jsp").forward(request, response);
    }

    private void afficherFormulaireEdition(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Categorie categorie = categorieDAO.getCategorieById(id);
        request.setAttribute("categorie", categorie);
        request.getRequestDispatcher("/categories/form-categorie.jsp").forward(request, response);
    }

    private void insererCategorie(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");

        if (nom != null && !nom.trim().isEmpty()) {
            Categorie categorie = new Categorie(nom, description);
            categorieDAO.ajouterCategorie(categorie);
            System.out.println("Catégorie ajoutée avec succès: " + nom);
        }

        response.sendRedirect("categories?action=list");
    }

    private void mettreAJourCategorie(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");

        if (nom != null && !nom.trim().isEmpty()) {
            Categorie categorie = new Categorie(id, nom, description, null);
            categorieDAO.modifierCategorie(categorie);
            System.out.println("Catégorie modifiée avec succès: ID=" + id + ", Nom=" + nom);
        }

        response.sendRedirect("categories?action=list");
    }

    private void supprimerCategorie(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        categorieDAO.supprimerCategorie(id);
        System.out.println("Catégorie supprimée avec succès: ID=" + id);
        response.sendRedirect("categories?action=list");
    }
}