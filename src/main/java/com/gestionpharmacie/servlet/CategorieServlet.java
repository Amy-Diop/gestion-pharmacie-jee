package com.gestionpharmacie.servlet;

import com.gestionpharmacie.model.Categorie;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/categories")
public class CategorieServlet extends HttpServlet {

    private final String jdbcURL = "jdbc:mysql://localhost:3306/pharmacie_db";
    private final String jdbcUsername = "root";
    private final String jdbcPassword = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) action = "list";

            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "insert":
                    insertCategorie(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "update":
                    updateCategorie(request, response);
                    break;
                case "delete":
                    deleteCategorie(request, response);
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Pour que les formulaires POST fonctionnent
        doGet(request, response);
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Categorie> categories = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM categories")) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String nom = rs.getString("nom");
                categories.add(new Categorie(id, nom));
            }
        }
        request.setAttribute("categories", categories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("liste-categories.jsp");
        dispatcher.forward(request, response);
    }

    private void insertCategorie(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String nom = request.getParameter("nom");

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO categories (nom) VALUES (?)")) {
            stmt.setString(1, nom);
            stmt.executeUpdate();
        }
        response.sendRedirect("categories");
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("ajouter-categorie.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Categorie categorie = null;

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM categories WHERE id=?")) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String nom = rs.getString("nom");
                categorie = new Categorie(id, nom);
            }
        }
        request.setAttribute("categorie", categorie);
        RequestDispatcher dispatcher = request.getRequestDispatcher("modifier-categorie.jsp");
        dispatcher.forward(request, response);
    }

    private void updateCategorie(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nom = request.getParameter("nom");

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("UPDATE categories SET nom=? WHERE id=?")) {
            stmt.setString(1, nom);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        }
        response.sendRedirect("categories");
    }

    private void deleteCategorie(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM categories WHERE id=?")) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
        response.sendRedirect("categories");
    }
}
