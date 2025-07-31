package com.gestionpharmacie.servlet;

import com.gestionpharmacie.dao.MedicamentDAO;
import com.gestionpharmacie.model.Medicament;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/liste-medicaments")
public class ListeMedicamentsServlet extends HttpServlet {
    private MedicamentDAO medicamentDAO;

    @Override
    public void init() {
        medicamentDAO = new MedicamentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            int page = 1;
            int itemsPerPage = 10;
            
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
            
            List<Medicament> allMedicaments;
            if (search != null && !search.trim().isEmpty()) {
                allMedicaments = medicamentDAO.rechercherMedicaments(search.trim());
            } else {
                allMedicaments = medicamentDAO.listerMedicaments();
            }
            
            // Pagination
            int totalItems = allMedicaments.size();
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            int startIndex = (page - 1) * itemsPerPage;
            int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
            
            List<Medicament> medicaments = allMedicaments.subList(startIndex, endIndex);
            
            request.setAttribute("medicaments", medicaments);
            request.setAttribute("search", search);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            
            request.getRequestDispatcher("/medicaments/liste-medicaments.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement de la liste des médicaments", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}