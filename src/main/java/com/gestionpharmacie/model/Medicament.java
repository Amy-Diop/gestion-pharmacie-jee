package com.gestionpharmacie.model;

public class Medicament {
    private int id;
    private String nom;
    private double prix;
    private int stock;
    private String dateExpiration;
    private int categorieId;       // 🔥 la clé étrangère
    private String categorieNom;   // 🔥 nom de la catégorie (pour affichage)

    public Medicament() {}

    public Medicament(int id, String nom, double prix, int stock, String dateExpiration, int categorieId, String categorieNom) {
        this.id = id;
        this.nom = nom;
        this.prix = prix;
        this.stock = stock;
        this.dateExpiration = dateExpiration;
        this.categorieId = categorieId;
        this.categorieNom = categorieNom;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getDateExpiration() { return dateExpiration; }
    public void setDateExpiration(String dateExpiration) { this.dateExpiration = dateExpiration; }

    public int getCategorieId() { return categorieId; }
    public void setCategorieId(int categorieId) { this.categorieId = categorieId; }

    public String getCategorieNom() { return categorieNom; }
    public void setCategorieNom(String categorieNom) { this.categorieNom = categorieNom; }
}
