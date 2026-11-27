# Rapport de Validation et Stratégie de Tests — Projet URBANWATT

Ce document présente la stratégie de validation mise en œuvre pour vérifier le bon fonctionnement de l'architecture **URBANWATT** (base de données PostgreSQL, API backend, portail web d'exploitation et procédures de sécurité).

---

## 1. Tableau des Scénarios de Test

| N° | Scénario & Action réalisée | Résultat attendu | Résultat obtenu | Statut |
| :--- | :--- | :--- | :--- | :--- |
| **T1** | **Connexion base & cohérence imports :** Exécution du script `sql/02_verifications.sql` sur PostgreSQL. | Toutes les tables importées (120 stations, 250 000 sessions, etc.) et 0 anomalie de clé étrangère. | 120 stations et 250 000 sessions vérifiées, 0 orphelin détecté. | **Succès** |
| **T2** | **Consultation du portail :** Ouverture de l'interface web et sélection d'une station (ex: `ST-LIL`). | Affichage fluide de la liste des stations puis des bornes associées via l'API. | Liste affichée en moins de 1s, bornes de `ST-LIL` visibles avec leur état. | **Succès** |
| **T3** | **Gestion réponse API inconnue :** Appel de `GET /api/stations/99999/bornes` (ou station inexistante). | L'API renvoie un code HTTP `404` et l'interface web affiche un message d'erreur clair sans planter. | Code `404` retourné, message « Station introuvable » affiché à l'écran. | **Succès** |
| **T4** | **Restauration des données :** Sauvegarde avec `pg_dump` et restauration dans une base de test distincte. | Nombre de lignes strictement identique entre la base principale et la base de test. | 250 000 sessions et intégralité des tables confirmées avant et après restauration. | **Succès** |
| **T5** | **Contrôle sécurité 1 (Accès DB) :** Connexion avec le rôle applicatif pour tenter un `DROP TABLE stations`. | Action bloquée par PostgreSQL (`permission denied`) car le rôle ne dispose que des droits nécessaires. | Erreur PostgreSQL : `permission refusée pour la relation stations`. | **Succès** |
| **T6** | **Contrôle sécurité 2 (Secrets & SQLi) :** Vérification du `.gitignore` et test d'injection SQL dans l'URL de l'API. | Le fichier `.env` est absent du dépôt Git et les requêtes paramétrées bloquent l'injection. | Fichier `.env` ignoré par Git ; paramètre malveillant traité comme simple chaîne. | **Succès** |

---

## 2. Analyse des Risques Techniques

* **Risque identifié :** Saturation ou lenteur des requêtes de l'API lors de l'affichage de l'historique sur la table `sessions_recharge` (250 000 lignes) ou perte de données suite à une panne brutale du serveur hébergeant PostgreSQL.
* **Mesures de limitation appliquées :**
  * **Optimisation des performances :** Création d'index métiers ciblés (`idx_sessions_vehicule` et `idx_incidents_borne`) pour éviter le balayage séquentiel complet des tables volumineuses.
  * **Sécurité et résilience :** Mise en place de sauvegardes régulières via `pg_dump` et vérification systématique de la persistance des volumes de données au redémarrage des services.

---

## 3. Bilan de Validation

* **Statut global :** **RÉUSSITE** (6/6 scénarios validés).
* **Détail des corrections appliquées :** Ajout d'une gestion d'erreur explicite (`try/except` et vérification d'existence) sur la route `GET /api/stations/{id}/bornes` afin de retourner proprement un code HTTP `404` (au lieu d'une erreur serveur `500`) lorsqu'un identifiant de station inexistant est sollicité.