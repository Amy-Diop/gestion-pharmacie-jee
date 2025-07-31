package com.gestionpharmacie.model;

import java.sql.Timestamp;

public class Ordonnance {
    private int id;
    private String numero;
    private String patientNom;
    private String medecinNom;
    private Timestamp dateOrdonnance;
    private String statut;
    private String notes;
    private String pharmacien;

    public Ordonnance() {}

    // Getters et Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getPatientNom() {
        return patientNom;
    }

    public void setPatientNom(String patientNom) {
        this.patientNom = patientNom;
    }

    public String getMedecinNom() {
        return medecinNom;
    }

    public void setMedecinNom(String medecinNom) {
        this.medecinNom = medecinNom;
    }

    public Timestamp getDateOrdonnance() {
        return dateOrdonnance;
    }

    public void setDateOrdonnance(Timestamp dateOrdonnance) {
        this.dateOrdonnance = dateOrdonnance;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPharmacien() {
        return pharmacien;
    }

    public void setPharmacien(String pharmacien) {
        this.pharmacien = pharmacien;
    }
}