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

@WebServlet("/alertes")
public class AlerteServlet extends HttpServlet {
    private MedicamentDAO medicamentDAO;

    @Override
    public void init() {
        medicamentDAO = new MedicamentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Medicament> alertes = medicamentDAO.getMedicamentsAlertes();
            request.setAttribute("alertes", alertes);
            request.getRequestDispatcher("/alertes/liste-alertes.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des alertes", e);
        }
    }
}