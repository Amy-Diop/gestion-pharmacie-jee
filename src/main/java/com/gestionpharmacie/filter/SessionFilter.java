package com.gestionpharmacie.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebFilter(urlPatterns = {"/admin-dashboard.jsp", "/pharmacien-dashboard.jsp", "/assistant-dashboard.jsp"})
public class SessionFilter implements Filter {

    // Mapping des pages aux rôles autorisés
    private static final Map<String, String> PAGE_ROLE_MAP = new HashMap<>();

    static {
        PAGE_ROLE_MAP.put("/admin-dashboard.jsp", "ADMIN");
        PAGE_ROLE_MAP.put("/pharmacien-dashboard.jsp", "PHARMACIEN");
        PAGE_ROLE_MAP.put("/assistant-dashboard.jsp", "ASSISTANT");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String requestedPage = req.getServletPath();

        if (session == null || session.getAttribute("username") == null) {
            // Pas connecté
            resp.sendRedirect("login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("role");
        String requiredRole = PAGE_ROLE_MAP.get(requestedPage);

        if (requiredRole == null) {
            // Page non protégée dans ce filtre : continuer
            chain.doFilter(request, response);
            return;
        }

        if (!requiredRole.equals(userRole)) {
            // Rôle incorrect : accès refusé
            resp.sendRedirect("access-denied.jsp"); // Crée une page d’erreur "Accès refusé"
            return;
        }

        // Tout est ok, on continue la chaîne
        chain.doFilter(request, response);
    }
}
