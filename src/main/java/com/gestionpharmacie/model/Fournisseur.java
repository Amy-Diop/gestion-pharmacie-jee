package com.gestionpharmacie.model;

public class Fournisseur {
    private int id;
    private String nom;
    private String adresse;
    private String telephone;
    private String email;
    private java.sql.Timestamp dateAjout;
    private String produitsFournis;
    private String numeroImmatriculation;
    private String conditionsPaiement;

    public Fournisseur() {}

    public Fournisseur(String nom) {
        this.nom = nom;
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

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public java.sql.Timestamp getDateAjout() {
        return dateAjout;
    }

    public void setDateAjout(java.sql.Timestamp dateAjout) {
        this.dateAjout = dateAjout;
    }

    public String getProduitsFournis() {
        return produitsFournis;
    }

    public void setProduitsFournis(String produitsFournis) {
        this.produitsFournis = produitsFournis;
    }

    public String getNumeroImmatriculation() {
        return numeroImmatriculation;
    }

    public void setNumeroImmatriculation(String numeroImmatriculation) {
        this.numeroImmatriculation = numeroImmatriculation;
    }

    public String getConditionsPaiement() {
        return conditionsPaiement;
    }

    public void setConditionsPaiement(String conditionsPaiement) {
        this.conditionsPaiement = conditionsPaiement;
    }

    @Override
    public String toString() {
        return "Fournisseur{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                '}';
    }
}