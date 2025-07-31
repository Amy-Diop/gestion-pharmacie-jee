package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.StatistiqueDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/statistiques")
public class StatistiqueServlet extends HttpServlet {
    private StatistiqueDAO statistiqueDAO;

    @Override
    public void init() {
        statistiqueDAO = new StatistiqueDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Statistiques générales
            int nombreMedicaments = statistiqueDAO.getNombreMedicaments();
            int nombreVentes = statistiqueDAO.getNombreVentes();
            int nombreCategories = statistiqueDAO.getNombreCategories();
            int nombreAlertes = statistiqueDAO.getNombreAlertes();
            int nombreFournisseurs = statistiqueDAO.getNombreFournisseurs();
            int nombreUtilisateurs = statistiqueDAO.getNombreUtilisateurs();
            
            // Métriques spécifiques pharmacie
            int medicamentsEnRupture = statistiqueDAO.getMedicamentsEnRupture();
            int medicamentsPerimes = statistiqueDAO.getMedicamentsPerimes();
            double chiffreAffaires = statistiqueDAO.getChiffreAffaires();
            double chiffreAffairesHebdo = statistiqueDAO.getChiffresAffairesHebdomadaire();
            double chiffreAffairesMensuel = statistiqueDAO.getChiffresAffairesMensuel();

            // Graphiques
            Map<String, Double> ventesParJour = statistiqueDAO.getVentesParJour();
            Map<String, Integer> medicamentsParCategorie = statistiqueDAO.getMedicamentsParCategorie();

            // Passer les données à la JSP
            request.setAttribute("nombreMedicaments", nombreMedicaments);
            request.setAttribute("nombreVentes", nombreVentes);
            request.setAttribute("nombreCategories", nombreCategories);
            request.setAttribute("medicamentsEnRupture", medicamentsEnRupture);
            request.setAttribute("medicamentsPerimes", medicamentsPerimes);
            request.setAttribute("chiffreAffairesHebdo", chiffreAffairesHebdo);
            request.setAttribute("chiffreAffairesMensuel", chiffreAffairesMensuel);
            request.setAttribute("nombreAlertes", nombreAlertes);
            request.setAttribute("chiffreAffaires", chiffreAffaires);
            request.setAttribute("nombreUtilisateurs", nombreUtilisateurs);
            request.setAttribute("nombreFournisseurs", nombreFournisseurs);
            request.setAttribute("ventesParJour", ventesParJour);
            request.setAttribute("medicamentsParCategorie", medicamentsParCategorie);

            request.getRequestDispatcher("/statistiques.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la récupération des statistiques", e);
        }
    }
}