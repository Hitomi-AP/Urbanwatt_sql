# Dictionnaire de données

## 1. Table `stations` (120 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_station | INTEGER | PRIMARY KEY | Identifiant de la station. |
| code_station | VARCHAR(20) | UNIQUE, NOT NULL | Code unique de la station (ex : ST-LIL). |
| nom_station | VARCHAR(100) | NOT NULL | Nom de la station. |
| ville | VARCHAR(100) | NOT NULL | Ville où se trouve la station. |
| adresse | VARCHAR(255) | NOT NULL | Adresse complète de la station. |
| date_ouverture | DATE | NOT NULL | Date d'ouverture de la station. |

## 2. Table `bornes` (600 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_borne | INTEGER | PRIMARY KEY | Identifiant de la borne. |
| id_station | INTEGER | FOREIGN KEY, NOT NULL | Identifiant de la station associée. |
| code_borne | VARCHAR(20) | UNIQUE, NOT NULL | Code unique de la borne (ex : BR-LIL-01). |
| puissance_kw | INTEGER | NOT NULL, CHECK (> 0) | Puissance de la borne en kW. |
| connecteur | VARCHAR(30) | NOT NULL | Type de prise (ex : Type2, CCS). |
| etat | VARCHAR(30) | NOT NULL | État de la borne (disponible, en_maintenance, hors_service). |

## 3. Table `clients` (15 000 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_client | INTEGER | PRIMARY KEY | Identifiant du client. |
| prenom | VARCHAR(100) | NOT NULL | Prénom du client. |
| nom | VARCHAR(100) | NOT NULL | Nom du client. |
| email | VARCHAR(150) | UNIQUE, NOT NULL | Adresse email unique du client. |
| ville | VARCHAR(100) | NOT NULL | Ville du client. |
| date_inscription | DATE | NOT NULL | Date d'inscription du client. |

## 4. Table `vehicules` (18 000 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_vehicule | INTEGER | PRIMARY KEY | Identifiant du véhicule. |
| id_client | INTEGER | FOREIGN KEY, NOT NULL | Identifiant du propriétaire. |
| immatriculation | VARCHAR(20) | UNIQUE, NOT NULL | Plaque d'immatriculation du véhicule (ex : ESSAI-0001). |
| marque | VARCHAR(50) | NOT NULL | Marque du véhicule (ex : Renault, Peugeot). |
| modele | VARCHAR(50) | NOT NULL | Modèle du véhicule (ex : Zoe, e-208). |
| capacite_batterie_kwh | INTEGER | NOT NULL, CHECK (> 0) | Capacité de la batterie en kWh. |

## 5. Table `sessions_recharge` (250 000 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_session | INTEGER | PRIMARY KEY | Identifiant de la session. |
| id_borne | INTEGER | FOREIGN KEY, NOT NULL | Identifiant de la borne utilisée. |
| id_vehicule | INTEGER | FOREIGN KEY, NOT NULL | Identifiant du véhicule rechargé. |
| debut_session | TIMESTAMP | NOT NULL | Date et heure du début de la recharge. |
| fin_session | TIMESTAMP | NULL | Date et heure de fin de la recharge. |
| energie_kwh | DECIMAL(8,2) | NULL | Quantité d'énergie délivrée en kWh. |
| cout_eur | DECIMAL(8,2) | NULL | Coût de la recharge en euros. |
| statut | VARCHAR(20) | NOT NULL | État de la session (terminee, interrompue, annulee). |

## 6. Table `paiements` (217 300 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_paiement | INTEGER | PRIMARY KEY | Identifiant du paiement. |
| id_session | INTEGER | FOREIGN KEY, NOT NULL | Identifiant de la session concernée. |
| date_paiement | TIMESTAMP | NOT NULL | Date et heure du paiement. |
| montant_eur | DECIMAL(8,2) | NOT NULL, CHECK (>= 0) | Montant du paiement en euros. |
| mode_paiement | VARCHAR(30) | NOT NULL | Moyen de paiement utilisé (abonnement, carte, etc.). |
| statut | VARCHAR(20) | NOT NULL | Résultat du paiement (accepte, refuse, en_attente). |

## 7. Table `incidents` (5 000 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_incident | INTEGER | PRIMARY KEY | Identifiant de l'incident. |
| id_borne | INTEGER | FOREIGN KEY, NOT NULL | Identifiant de la borne concernée. |
| date_signalement | TIMESTAMP | NOT NULL | Date et heure du signalement. |
| date_resolution | TIMESTAMP | NULL | Date et heure de résolution de l'incident. |
| categorie | VARCHAR(50) | NOT NULL | Type de panne (defaut_reseau, erreur_paiement, etc.). |
| gravite | VARCHAR(20) | NOT NULL | Niveau de gravité (faible, moyenne, haute). |
| statut | VARCHAR(20) | NOT NULL | État de l'incident (ouvert, resolu). |
| description | TEXT | NOT NULL | Description du problème. |

## 8. Table `techniciens` (120 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_technicien | INTEGER | PRIMARY KEY | Identifiant du technicien. |
| prenom | VARCHAR(100) | NOT NULL | Prénom du technicien. |
| nom | VARCHAR(100) | NOT NULL | Nom du technicien. |
| email | VARCHAR(150) | UNIQUE, NOT NULL | Adresse email professionnelle. |

## 9. Table `interventions` (4 162 lignes)

| Colonne | Type SQL | Contraintes | Description |
|---|---|---|---|
| id_intervention | INTEGER | PRIMARY KEY | Identifiant de l'intervention. |
| id_incident | INTEGER | FOREIGN KEY, NOT NULL | Identifiant de l'incident concerné. |
| id_technicien | INTEGER | FOREIGN KEY, NOT NULL | Identifiant du technicien responsable. |
| date_debut | TIMESTAMP | NOT NULL | Date et heure du début de l'intervention. |
| date_fin | TIMESTAMP | NULL | Date et heure de fin de l'intervention. |
| statut | VARCHAR(20) | NOT NULL | État de l'intervention (terminee, en_cours, etc.). |
| compte_rendu | TEXT | NOT NULL | Compte rendu du technicien après l'intervention. |
