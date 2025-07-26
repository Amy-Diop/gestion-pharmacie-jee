package com.gestionpharmacie.model;

import java.sql.Date;

public class Vente {
    private int id;
    private int medicamentId;
    private int quantite;
    private double total;
    private Date dateVente;

    public Vente() {}

    public Vente(int id, int medicamentId, int quantite, double total, Date dateVente) {
        this.id = id;
        this.medicamentId = medicamentId;
        this.quantite = quantite;
        this.total = total;
        this.dateVente = dateVente;
    }

    // Getters & setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMedicamentId() { return medicamentId; }
    public void setMedicamentId(int medicamentId) { this.medicamentId = medicamentId; }

    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public Date getDateVente() { return dateVente; }
    public void setDateVente(Date dateVente) { this.dateVente = dateVente; }
}
