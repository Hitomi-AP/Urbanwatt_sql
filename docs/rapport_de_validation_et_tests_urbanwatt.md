# Rapport de Validation et Stratégie de Tests — Projet URBANWATT

Ce document présente la stratégie de validation mise en œuvre pour vérifier le bon fonctionnement de l'architecture **URBANWATT** (base de données PostgreSQL, API backend, portail web d'exploitation et procédures de sécurité).

---

## 1. Tableau des Scénarios de Test

| N° | Scénario & Action réalisée | Résultat attendu | Résultat obtenu | Statut |
| :--- | :--- | :--- | :--- | :--- |
| **T1** | **Connexion base & cohérence imports :** Exécution du script `sql/02_verifications.sql` sur PostgreSQL. | Toutes les tables importées (120 stations, 250 000 sessions, etc.) et 0 anomalie de clé étrangère. | 120 stations et 250 000 sessions vérifiées, 0 orphelin détecté. | **Succès** |
| **T2** | **Consultation du portail :** Ouverture de l'interface web et sélection d'une station  | Affichage fluide de la liste des stations puis des bornes associées via l'API. | Liste affichée en moins de 1s, bornes  visibles avec leur état. | **Succès** |
| **T3** | **Gestion réponse API inconnue :** Appel de `GET /api/stations/99999/bornes` (ou station inexistante). | L'API renvoie un code HTTP `404` et l'interface web affiche un message d'erreur clair sans planter. | Code `404` retourné, message « Station introuvable » affiché à l'écran. | **Succès** |
| **T4** | **Restauration des données :** Sauvegarde avec `pg_dump` et restauration dans une base de test distincte. | Nombre de lignes strictement identique entre la base principale et la base de test. | intégralité des tables confirmées  | **Succès** |
| T5 | Contrôle sécurité 1 (Accès DB) : Vérification des privilèges du rôle applicatif api_reader sur public.vehicules via has_table_privilege. | Le rôle dispose uniquement du droit SELECT (true) et n'a aucun droit d'écriture ou suppression (insert, update, delete à false). | Résultat obtenu : select = true, insert = false, update = false, delete = false sur public.vehicules. | Succès |
| T6 | Contrôle sécurité 2 (Secrets & SQLi) : Vérification de l'exclusion de infra/.env via .gitignore et test d'injection SQL (1 OR 1=1) sur GET /api/stations/{id}/bornes. | infra/.env ignoré hors dépôt Git et charge d'injection bloquée sans exécution SQL. | infra/.env ignoré par Git (infra/.env.example conservé) ; saisie 1 OR 1=1 rejetée (Value must be an integer.). | Succès |

---

## 2. Analyse des Risques Techniques

- **Risque identifié :** Lenteur des requêtes sur les tables volumineuses (notamment `sessions_recharge` avec 250 000 lignes), perte de données en cas d'incident sur PostgreSQL, ou exposition de secrets / accès non autorisés.
- **Mesures de limitation appliquées :**
  - **Performance :** Création d'index métiers ciblés (`idx_sessions_vehicule` et `idx_incidents_borne`) pour limiter le balayage séquentiel.
  - **Sauvegarde et persistance :** Sauvegardes `pg_dump` validées par restauration sur `db_backup` et vérification de la persistance au redémarrage.
  - **Sécurité :** Rôle `api_reader` limité à la lecture (`SELECT`), exclusion de `infra/.env` via `.gitignore` (avec `infra/.env.example`), et validation stricte des paramètres d'entrée sur l'API.

---

## 3. Bilan de Validation

- **Statut global :** **RÉUSSITE** (6/6 scénarios validés : T1 à T6).
- **Détail des corrections appliquées :** Ajout de la vérification d'existence de la station et de la gestion d'erreur (`404` au lieu de `500`) sur `GET /api/stations/{id}/bornes`, ainsi que la mise à jour de `.gitignore` pour couvrir `infra/.env` tout en conservant `infra/.env.example`.
