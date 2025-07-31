package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.UtilisateurDAO;
import com.gestionpharmacie.model.Utilisateur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {
    private UtilisateurDAO utilisateurDAO;

    @Override
    public void init() {
        utilisateurDAO = new UtilisateurDAO();
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
                    supprimerUtilisateur(request, response);
                    break;
                default:
                    listerUtilisateurs(request, response);
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
                    insererUtilisateur(request, response);
                    break;
                case "update":
                    mettreAJourUtilisateur(request, response);
                    break;
                default:
                    response.sendRedirect("utilisateurs?action=list");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la sauvegarde de l'utilisateur", e);
        }
    }

    private void listerUtilisateurs(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String search = request.getParameter("search");
        int page = 1;
        int itemsPerPage = 10;
        
        try {
            page = Integer.parseInt(request.getParameter("page"));
            if (page < 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        List<Utilisateur> allUtilisateurs;
        if (search != null && !search.trim().isEmpty()) {
            allUtilisateurs = utilisateurDAO.rechercherUtilisateurs(search.trim());
        } else {
            allUtilisateurs = utilisateurDAO.listerUtilisateurs();
        }
        
        // Pagination
        int totalItems = allUtilisateurs.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        List<Utilisateur> utilisateurs = allUtilisateurs.subList(startIndex, endIndex);
        
        request.setAttribute("listeUtilisateurs", utilisateurs);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("itemsPerPage", itemsPerPage);
        
        request.getRequestDispatcher("/utilisateurs/liste-utilisateurs.jsp").forward(request, response);
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("utilisateur", null);
        request.getRequestDispatcher("/utilisateurs/form-utilisateur.jsp").forward(request, response);
    }

    private void afficherFormulaireEdition(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Utilisateur utilisateur = utilisateurDAO.getUtilisateurById(id);
        request.setAttribute("utilisateur", utilisateur);
        request.getRequestDispatcher("/utilisateurs/form-utilisateur.jsp").forward(request, response);
    }

    private void insererUtilisateur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Vérifier si le username existe déjà
        if (utilisateurDAO.usernameExiste(username, 0)) {
            request.setAttribute("error", "Ce nom d'utilisateur existe déjà !");
            request.setAttribute("utilisateur", new Utilisateur(username, password, role));
            try {
                request.getRequestDispatcher("/utilisateurs/form-utilisateur.jsp").forward(request, response);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        Utilisateur utilisateur = new Utilisateur(username, password, role);
        utilisateurDAO.ajouterUtilisateur(utilisateur);
        System.out.println("Utilisateur ajouté avec succès: " + username);
        response.sendRedirect("utilisateurs?action=list");
    }

    private void mettreAJourUtilisateur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Vérifier si le username existe déjà (excluant l'utilisateur actuel)
        if (utilisateurDAO.usernameExiste(username, id)) {
            request.setAttribute("error", "Ce nom d'utilisateur existe déjà !");
            Utilisateur utilisateur = new Utilisateur(username, password, role);
            utilisateur.setId(id);
            request.setAttribute("utilisateur", utilisateur);
            try {
                request.getRequestDispatcher("/utilisateurs/form-utilisateur.jsp").forward(request, response);
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return;
        }

        Utilisateur utilisateur = new Utilisateur(username, password, role);
        utilisateur.setId(id);
        utilisateurDAO.modifierUtilisateur(utilisateur);
        System.out.println("Utilisateur modifié avec succès: ID=" + id + ", Username=" + username);
        response.sendRedirect("utilisateurs?action=list");
    }

    private void supprimerUtilisateur(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        utilisateurDAO.supprimerUtilisateur(id);
        System.out.println("Utilisateur supprimé avec succès: ID=" + id);
        response.sendRedirect("utilisateurs?action=list");
    }
}