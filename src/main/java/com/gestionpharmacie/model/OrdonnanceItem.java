package com.gestionpharmacie.model;

public class OrdonnanceItem {
    private int id;
    private int ordonnanceId;
    private String medicamentNom;
    private String dosage;
    private int quantite;
    private String posologie;
    private String dureeTraitement;
    private boolean disponible;

    // Constructeurs
    public OrdonnanceItem() {}

    public OrdonnanceItem(int ordonnanceId, String medicamentNom, String dosage, 
                         int quantite, String posologie, String dureeTraitement) {
        this.ordonnanceId = ordonnanceId;
        this.medicamentNom = medicamentNom;
        this.dosage = dosage;
        this.quantite = quantite;
        this.posologie = posologie;
        this.dureeTraitement = dureeTraitement;
        this.disponible = true;
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrdonnanceId() {
        return ordonnanceId;
    }

    public void setOrdonnanceId(int ordonnanceId) {
        this.ordonnanceId = ordonnanceId;
    }

    public String getMedicamentNom() {
        return medicamentNom;
    }

    public void setMedicamentNom(String medicamentNom) {
        this.medicamentNom = medicamentNom;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public String getPosologie() {
        return posologie;
    }

    public void setPosologie(String posologie) {
        this.posologie = posologie;
    }

    public String getDureeTraitement() {
        return dureeTraitement;
    }

    public void setDureeTraitement(String dureeTraitement) {
        this.dureeTraitement = dureeTraitement;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    @Override
    public String toString() {
        return "OrdonnanceItem{" +
                "id=" + id +
                ", medicamentNom='" + medicamentNom + '\'' +
                ", dosage='" + dosage + '\'' +
                ", quantite=" + quantite +
                ", disponible=" + disponible +
                '}';
    }
}