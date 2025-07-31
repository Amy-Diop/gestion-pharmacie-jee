package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.MedicamentDAO;
import com.gestionpharmacie.dao.VenteDAO;
import com.gestionpharmacie.model.Medicament;
import com.gestionpharmacie.model.Vente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/ventes")
public class VenteServlet extends HttpServlet {
    private VenteDAO venteDAO;
    private MedicamentDAO medicamentDAO;

    @Override
    public void init() {
        venteDAO = new VenteDAO();
        medicamentDAO = new MedicamentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    afficherNouvelleVente(request, response);
                    break;
                case "history":
                    afficherHistorique(request, response);
                    break;
                default:
                    afficherNouvelleVente(request, response);
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
                case "create":
                    creerVente(request, response);
                    break;
                default:
                    response.sendRedirect("ventes?action=list");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la création de la vente", e);
        }
    }

    private void afficherNouvelleVente(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Medicament> medicaments = medicamentDAO.listerMedicaments();
        request.setAttribute("medicaments", medicaments);
        request.getRequestDispatcher("/ventes/nouvelle-vente.jsp").forward(request, response);
    }

    private void afficherHistorique(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Vente> ventes = venteDAO.listerVentes();
        request.setAttribute("ventes", ventes);
        request.getRequestDispatcher("/ventes/historique-ventes.jsp").forward(request, response);
    }

    private void creerVente(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        HttpSession session = request.getSession();
        String vendeur = (String) session.getAttribute("username");
        
        // Récupérer les données du formulaire
        String clientNom = request.getParameter("clientNom");
        String modePaiement = request.getParameter("modePaiement");
        double montantTotal = Double.parseDouble(request.getParameter("montantTotal"));
        double montantRecu = Double.parseDouble(request.getParameter("montantRecu"));
        double monnaie = Double.parseDouble(request.getParameter("monnaie"));
        
        // Récupérer les médicaments
        String[] medicamentIds = request.getParameterValues("medicament");
        String[] quantites = request.getParameterValues("quantite");
        
        if (medicamentIds != null && quantites != null) {
            // Créer la vente
            Vente vente = new Vente();
            vente.setClientNom(clientNom != null && !clientNom.trim().isEmpty() ? clientNom : "Client anonyme");
            vente.setVendeur(vendeur);
            vente.setMontantTotal(montantTotal);
            vente.setMontantRecu(montantRecu);
            vente.setMonnaie(monnaie);
            vente.setModePaiement(modePaiement);
            vente.setStatut("PAYEE");
            
            // Enregistrer la vente
            int venteId = venteDAO.ajouterVente(vente);
            
            // Enregistrer les détails et mettre à jour le stock
            for (int i = 0; i < medicamentIds.length; i++) {
                if (medicamentIds[i] != null && !medicamentIds[i].isEmpty()) {
                    int medicamentId = Integer.parseInt(medicamentIds[i]);
                    int quantite = Integer.parseInt(quantites[i]);
                    
                    // Récupérer le médicament pour le prix
                    Medicament medicament = medicamentDAO.getMedicamentById(medicamentId);
                    if (medicament != null) {
                        double prixUnitaire = medicament.getPrix();
                        double sousTotal = prixUnitaire * quantite;
                        
                        // Ajouter le détail de vente
                        venteDAO.ajouterDetailVente(venteId, medicamentId, quantite, prixUnitaire, sousTotal);
                        
                        // Mettre à jour le stock
                        int nouveauStock = medicament.getStock() - quantite;
                        medicamentDAO.mettreAJourStock(medicamentId, nouveauStock);
                    }
                }
            }
            
            System.out.println("Vente créée avec succès: ID=" + venteId + ", Montant=" + montantTotal);
        }
        
        response.sendRedirect("ventes?action=history");
    }
}