-- Créer la table fournisseurs
CREATE TABLE IF NOT EXISTS fournisseurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    adresse TEXT,
    telephone VARCHAR(20),
    email VARCHAR(255),
    produits_fournis TEXT,
    numero_immatriculation VARCHAR(100),
    conditions_paiement TEXT,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insérer quelques fournisseurs d'exemple
INSERT INTO fournisseurs (nom, adresse, telephone, email, produits_fournis, numero_immatriculation, conditions_paiement) VALUES
('Pharma Distribution', '123 Rue de la Santé, Dakar', '+221 33 123 4567', 'contact@pharmadist.sn', 'Médicaments génériques, Antibiotiques', 'FRS001', '30 jours net'),
('MediSupply Sénégal', '456 Avenue Bourguiba, Dakar', '+221 33 987 6543', 'info@medisupply.sn', 'Matériel médical, Vitamines', 'FRS002', '45 jours net'),
('Global Health Partners', '789 Boulevard de la République, Dakar', '+221 33 555 0123', 'sales@ghp.sn', 'Médicaments spécialisés, Vaccins', 'FRS003', 'Paiement à la livraison');