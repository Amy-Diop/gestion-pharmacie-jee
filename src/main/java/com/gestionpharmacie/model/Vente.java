package com.gestionpharmacie.model;

import java.sql.Timestamp;

public class Vente {
    private int id;
    private String clientNom;
    private String vendeur;
    private double montantTotal;
    private double montantRecu;
    private double monnaie;
    private String modePaiement;
    private String statut;
    private Timestamp dateVente;

    public Vente() {}

    public Vente(String clientNom, String vendeur, double montantTotal, double montantRecu, 
                 double monnaie, String modePaiement, String statut) {
        this.clientNom = clientNom;
        this.vendeur = vendeur;
        this.montantTotal = montantTotal;
        this.montantRecu = montantRecu;
        this.monnaie = monnaie;
        this.modePaiement = modePaiement;
        this.statut = statut;
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getClientNom() {
        return clientNom;
    }

    public void setClientNom(String clientNom) {
        this.clientNom = clientNom;
    }

    public String getVendeur() {
        return vendeur;
    }

    public void setVendeur(String vendeur) {
        this.vendeur = vendeur;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public double getMontantRecu() {
        return montantRecu;
    }

    public void setMontantRecu(double montantRecu) {
        this.montantRecu = montantRecu;
    }

    public double getMonnaie() {
        return monnaie;
    }

    public void setMonnaie(double monnaie) {
        this.monnaie = monnaie;
    }

    public String getModePaiement() {
        return modePaiement;
    }

    public void setModePaiement(String modePaiement) {
        this.modePaiement = modePaiement;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Timestamp getDateVente() {
        return dateVente;
    }

    public void setDateVente(Timestamp dateVente) {
        this.dateVente = dateVente;
    }
}