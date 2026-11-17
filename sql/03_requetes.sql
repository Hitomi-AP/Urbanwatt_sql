-- Projet UrbanWatt - Requêtes SQL


-- Questions obligatoires


-- Question 01 : Clients ayant rechargé à la station ST-LIL.
SELECT DISTINCT c.nom, c.prenom
FROM clients c
JOIN vehicules v ON c.id_client = v.id_client
JOIN sessions_recharge s ON v.id_vehicule = s.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE st.code_station = 'ST-LIL';

-- Question 02 : Bornes de la station ST-TOU, classées par puissance.
SELECT b.code_borne, b.puissance_kw, b.connecteur, b.etat
FROM bornes b
JOIN stations st ON b.id_station = st.id_station
WHERE st.code_station = 'ST-TOU'
ORDER BY b.puissance_kw DESC;

-- Question 03 : Historique des sessions du véhicule ESSAI-0001.
SELECT s.debut_session, s.fin_session, b.code_borne, s.energie_kwh, s.cout_eur, s.statut
FROM sessions_recharge s
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
WHERE v.immatriculation = 'ESSAI-0001'
ORDER BY s.debut_session DESC;

-- Question 04 : Clients sans session annulée ou interrompue.
SELECT c.id_client, c.nom, c.prenom
FROM clients c
WHERE NOT EXISTS (
    SELECT 1
    FROM vehicules v
    JOIN sessions_recharge s ON v.id_vehicule = s.id_vehicule
    WHERE v.id_client = c.id_client
      AND s.statut IN ('annulee', 'interrompue')
);

-- Question 05 : Sessions terminées à la station ST-LYO.
SELECT s.id_session, v.immatriculation, b.code_borne, s.debut_session, s.fin_session, s.energie_kwh, s.cout_eur
FROM sessions_recharge s
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE st.code_station = 'ST-LYO'
  AND s.statut = 'terminee'
ORDER BY s.energie_kwh DESC;

-- Question 06 : Sessions du client numéro 10.
SELECT s.id_session, v.immatriculation, st.code_station, st.nom_station, s.debut_session, s.statut
FROM sessions_recharge s
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE v.id_client = 10
ORDER BY s.debut_session DESC;

-- Question 07 : Incidents de gravité haute.
SELECT b.code_borne, st.code_station, st.nom_station, i.categorie, i.date_signalement, i.statut AS etat_resolution
FROM incidents i
JOIN bornes b ON i.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE i.gravite = 'haute';

-- Question 08 : Incidents et interventions de la station ST-BOR.
SELECT i.id_incident, b.code_borne, i.date_signalement, i.categorie, i.gravite, i.statut AS statut_incident,
       intv.id_intervention, intv.date_debut, intv.date_fin, intv.statut AS statut_intervention, intv.compte_rendu
FROM incidents i
JOIN bornes b ON i.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
LEFT JOIN interventions intv ON i.id_incident = intv.id_incident
WHERE st.code_station = 'ST-BOR'
ORDER BY i.date_signalement DESC;

-- Question 09 : Sessions annulées ou interrompues à ST-NAN.
SELECT s.id_session, v.immatriculation, s.debut_session, s.statut
FROM sessions_recharge s
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE st.code_station = 'ST-NAN'
  AND s.statut IN ('annulee', 'interrompue');

-- Question 10 : Clients ayant effectué une recharge de plus de 30 kWh.
SELECT DISTINCT c.id_client, c.nom, c.prenom, c.email
FROM clients c
JOIN vehicules v ON c.id_client = v.id_client
JOIN sessions_recharge s ON v.id_vehicule = s.id_vehicule
WHERE s.statut = 'terminee'
  AND s.energie_kwh > 30;

-- Question 11 : Nombre de bornes selon leur état dans chaque station.
SELECT st.code_station, st.nom_station,
       COUNT(CASE WHEN b.etat = 'disponible' THEN 1 END) AS bornes_disponibles,
       COUNT(CASE WHEN b.etat = 'en_maintenance' THEN 1 END) AS bornes_en_maintenance,
       COUNT(CASE WHEN b.etat = 'hors_service' THEN 1 END) AS bornes_hors_service
FROM stations st
LEFT JOIN bornes b ON st.id_station = b.id_station
GROUP BY st.id_station, st.code_station, st.nom_station
ORDER BY st.code_station;

-- Question 12 : Session(s) avec le plus d'énergie à ST-LIL.
WITH sessions_st_lil AS (
    SELECT s.id_session, v.immatriculation, b.code_borne, s.debut_session, s.energie_kwh,
           RANK() OVER (ORDER BY s.energie_kwh DESC) AS rang
    FROM sessions_recharge s
    JOIN vehicules v ON s.id_vehicule = v.id_vehicule
    JOIN bornes b ON s.id_borne = b.id_borne
    JOIN stations st ON b.id_station = st.id_station
    WHERE st.code_station = 'ST-LIL'
      AND s.statut = 'terminee'
)
SELECT id_session, immatriculation, code_borne, debut_session, energie_kwh
FROM sessions_st_lil
WHERE rang = 1;

-- Question 13 : Nombre de véhicules ayant rechargé dans chaque station.
SELECT st.code_station, st.nom_station, COUNT(DISTINCT s.id_vehicule) AS nb_vehicules_distincts
FROM stations st
LEFT JOIN bornes b ON st.id_station = b.id_station
LEFT JOIN sessions_recharge s ON b.id_borne = s.id_borne AND s.statut = 'terminee'
GROUP BY st.id_station, st.code_station, st.nom_station
ORDER BY st.code_station;

-- Question 14 : Énergie moyenne par véhicule.
SELECT v.id_vehicule, v.immatriculation, v.marque, v.modele,
       COALESCE(ROUND(AVG(s.energie_kwh), 2), 0) AS energie_moyenne_kwh
FROM vehicules v
LEFT JOIN sessions_recharge s ON v.id_vehicule = s.id_vehicule AND s.statut = 'terminee'
GROUP BY v.id_vehicule, v.immatriculation, v.marque, v.modele
ORDER BY v.id_vehicule;

-- Question 15 : Plus grande recharge enregistrée dans chaque station.
WITH max_station AS (
    SELECT st.id_station, st.code_station, st.nom_station, b.code_borne, s.energie_kwh,
           RANK() OVER (PARTITION BY st.id_station ORDER BY s.energie_kwh DESC) AS rang
    FROM stations st
    JOIN bornes b ON st.id_station = b.id_station
    JOIN sessions_recharge s ON b.id_borne = s.id_borne
    WHERE s.statut = 'terminee'
)
SELECT DISTINCT code_station, nom_station, code_borne, energie_kwh AS max_energie_kwh
FROM max_station
WHERE rang = 1
ORDER BY code_station;


-- Questions au choix


-- Question 16 : Historique du véhicule ESSAI-0007.
SELECT st.ville, st.code_station, st.nom_station, b.code_borne, s.debut_session, s.fin_session, s.statut
FROM sessions_recharge s
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE v.immatriculation = 'ESSAI-0007'
ORDER BY s.debut_session ASC;

-- Question 18 : Bornes ayant au moins deux incidents.
SELECT b.code_borne, st.code_station, COUNT(i.id_incident) AS nb_incidents, MAX(i.date_signalement) AS dernier_incident
FROM bornes b
JOIN stations st ON b.id_station = st.id_station
JOIN incidents i ON b.id_borne = i.id_borne
GROUP BY b.id_borne, b.code_borne, st.code_station
HAVING COUNT(i.id_incident) >= 2
ORDER BY nb_incidents DESC, dernier_incident DESC;

-- Question 20 : Classement des clients selon l'énergie consommée.
SELECT c.id_client, c.nom, c.prenom,
       COUNT(s.id_session) AS nb_sessions,
       COALESCE(SUM(s.energie_kwh), 0) AS energie_totale_kwh,
       RANK() OVER (ORDER BY COALESCE(SUM(s.energie_kwh), 0) DESC) AS rang
FROM clients c
LEFT JOIN vehicules v ON c.id_client = v.id_client
LEFT JOIN sessions_recharge s ON v.id_vehicule = s.id_vehicule AND s.statut = 'terminee'
GROUP BY c.id_client, c.nom, c.prenom
ORDER BY rang;

-- Question 22 : Chiffre d'affaires par station.
SELECT st.code_station, st.nom_station,
       COALESCE(SUM(p.montant_eur), 0) AS chiffre_affaires_eur
FROM stations st
LEFT JOIN bornes b ON st.id_station = b.id_station
LEFT JOIN sessions_recharge s ON b.id_borne = s.id_borne
LEFT JOIN paiements p ON s.id_session = p.id_session AND p.statut = 'accepte'
GROUP BY st.id_station, st.code_station, st.nom_station
ORDER BY chiffre_affaires_eur DESC;

-- Question 24 : Les dix paiements acceptés les plus élevés.
SELECT s.id_session, p.montant_eur, c.nom, c.prenom, v.immatriculation, st.code_station, st.nom_station
FROM paiements p
JOIN sessions_recharge s ON p.id_session = s.id_session
JOIN vehicules v ON s.id_vehicule = v.id_vehicule
JOIN clients c ON v.id_client = c.id_client
JOIN bornes b ON s.id_borne = b.id_borne
JOIN stations st ON b.id_station = st.id_station
WHERE p.statut = 'accepte'
ORDER BY p.montant_eur DESC
LIMIT 10;


-- Question d'approfondissement


-- Question 25 : Bornes sans incident signalé.
SELECT b.id_borne, b.code_borne, st.code_station, st.nom_station, b.puissance_kw, b.etat
FROM bornes b
JOIN stations st ON b.id_station = st.id_station
WHERE NOT EXISTS (
    SELECT 1
    FROM incidents i
    WHERE i.id_borne = b.id_borne
)
ORDER BY st.code_station, b.code_borne;
