-- Créer la table des ventes
CREATE TABLE IF NOT EXISTS ventes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_nom VARCHAR(255),
    vendeur VARCHAR(100) NOT NULL,
    montant_total DECIMAL(10,2) NOT NULL,
    montant_recu DECIMAL(10,2) NOT NULL,
    monnaie DECIMAL(10,2) NOT NULL,
    mode_paiement VARCHAR(50) NOT NULL,
    statut VARCHAR(20) DEFAULT 'PAYEE',
    date_vente TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Créer la table des détails de vente
CREATE TABLE IF NOT EXISTS vente_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vente_id INT NOT NULL,
    medicament_id INT NOT NULL,
    quantite INT NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    sous_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (vente_id) REFERENCES ventes(id),
    FOREIGN KEY (medicament_id) REFERENCES medicaments(id)
);

-- Insérer quelques ventes d'exemple
INSERT INTO ventes (client_nom, vendeur, montant_total, montant_recu, monnaie, mode_paiement, statut) VALUES
('Client Anonyme', 'admin', 15000.00, 15000.00, 0.00, 'ESPECES', 'PAYEE'),
('Marie Diop', 'pharmacien', 8500.00, 10000.00, 1500.00, 'ESPECES', 'PAYEE'),
('Amadou Ba', 'assistant', 12000.00, 12000.00, 0.00, 'CARTE', 'PAYEE');