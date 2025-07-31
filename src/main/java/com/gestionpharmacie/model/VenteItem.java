package com.gestionpharmacie.model;

public class VenteItem {
    private int id;
    private int venteId;
    private int medicamentId;
    private String medicamentNom;
    private int quantite;
    private double prixUnitaire;
    private double sousTotal;

    // Constructeurs
    public VenteItem() {}

    public VenteItem(int venteId, int medicamentId, String medicamentNom, 
                     int quantite, double prixUnitaire) {
        this.venteId = venteId;
        this.medicamentId = medicamentId;
        this.medicamentNom = medicamentNom;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        this.sousTotal = quantite * prixUnitaire;
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getVenteId() {
        return venteId;
    }

    public void setVenteId(int venteId) {
        this.venteId = venteId;
    }

    public int getMedicamentId() {
        return medicamentId;
    }

    public void setMedicamentId(int medicamentId) {
        this.medicamentId = medicamentId;
    }

    public String getMedicamentNom() {
        return medicamentNom;
    }

    public void setMedicamentNom(String medicamentNom) {
        this.medicamentNom = medicamentNom;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
        this.sousTotal = quantite * prixUnitaire;
    }

    public double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
        this.sousTotal = quantite * prixUnitaire;
    }

    public double getSousTotal() {
        return sousTotal;
    }

    public void setSousTotal(double sousTotal) {
        this.sousTotal = sousTotal;
    }

    @Override
    public String toString() {
        return "VenteItem{" +
                "id=" + id +
                ", medicamentNom='" + medicamentNom + '\'' +
                ", quantite=" + quantite +
                ", prixUnitaire=" + prixUnitaire +
                ", sousTotal=" + sousTotal +
                '}';
    }
}