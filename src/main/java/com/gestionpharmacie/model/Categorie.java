package com.gestionpharmacie.model;

public class Categorie {
    private int id;
    private String nom;
    private String description;
    private int nombreMedicaments;

    public Categorie() {}

    public Categorie(String nom, String description) {
        this.nom = nom;
        this.description = description;
    }

    public Categorie(int id, String nom, String description) {
        this.id = id;
        this.nom = nom;
        this.description = description;
    }

    public Categorie(int id, String nom, String description, Object dateCreation) {
        this.id = id;
        this.nom = nom;
        this.description = description;
        // dateCreation ignoré car pas dans le modèle actuel
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getNombreMedicaments() {
        return nombreMedicaments;
    }

    public void setNombreMedicaments(int nombreMedicaments) {
        this.nombreMedicaments = nombreMedicaments;
    }

    @Override
    public String toString() {
        return "Categorie{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                '}';
    }
}