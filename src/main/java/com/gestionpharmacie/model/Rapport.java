package com.gestionpharmacie.model;

import java.util.Date;
import java.util.Map;

public class Rapport {
    private String type;
    private Date dateDebut;
    private Date dateFin;
    private Date dateGeneration;
    private String generePar;
    private Map<String, Object> donnees;

    // Constructeurs
    public Rapport() {
        this.dateGeneration = new Date();
    }

    public Rapport(String type, Date dateDebut, Date dateFin, String generePar) {
        this();
        this.type = type;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.generePar = generePar;
    }

    // Getters et Setters
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public Date getDateGeneration() {
        return dateGeneration;
    }

    public void setDateGeneration(Date dateGeneration) {
        this.dateGeneration = dateGeneration;
    }

    public String getGenerePar() {
        return generePar;
    }

    public void setGenerePar(String generePar) {
        this.generePar = generePar;
    }

    public Map<String, Object> getDonnees() {
        return donnees;
    }

    public void setDonnees(Map<String, Object> donnees) {
        this.donnees = donnees;
    }

    @Override
    public String toString() {
        return "Rapport{" +
                "type='" + type + '\'' +
                ", dateDebut=" + dateDebut +
                ", dateFin=" + dateFin +
                ", generePar='" + generePar + '\'' +
                '}';
    }
}