CREATE TABLE "stations" (
  "id_station" integer PRIMARY KEY,
  "code_station" varchar UNIQUE,
  "nom_station" varchar,
  "ville" varchar,
  "adresse" varchar,
  "date_ouverture" date
);

CREATE TABLE "bornes" (
  "id_borne" integer PRIMARY KEY,
  "id_station" integer,
  "code_borne" varchar UNIQUE,
  "puissance_kw" integer,
  "connecteur" varchar,
  "etat" varchar
);

CREATE TABLE "clients" (
  "id_client" integer PRIMARY KEY,
  "prenom" varchar,
  "nom" varchar,
  "email" varchar UNIQUE,
  "ville" varchar,
  "date_inscription" date
);

CREATE TABLE "vehicules" (
  "id_vehicule" integer PRIMARY KEY,
  "id_client" integer,
  "immatriculation" varchar UNIQUE,
  "marque" varchar,
  "modele" varchar,
  "capacite_batterie_kwh" integer
);

CREATE TABLE "sessions_recharge" (
  "id_session" integer PRIMARY KEY,
  "id_borne" integer,
  "id_vehicule" integer,
  "debut_session" timestamp,
  "fin_session" timestamp,
  "energie_kwh" decimal,
  "cout_eur" decimal,
  "statut" varchar
);

CREATE TABLE "paiements" (
  "id_paiement" integer PRIMARY KEY,
  "id_session" integer,
  "date_paiement" timestamp,
  "montant_eur" decimal,
  "mode_paiement" varchar,
  "statut" varchar
);

CREATE TABLE "incidents" (
  "id_incident" integer PRIMARY KEY,
  "id_borne" integer,
  "date_signalement" timestamp,
  "date_resolution" timestamp,
  "categorie" varchar,
  "gravite" varchar,
  "statut" varchar,
  "description" text
);

CREATE TABLE "techniciens" (
  "id_technicien" integer PRIMARY KEY,
  "prenom" varchar,
  "nom" varchar,
  "email" varchar UNIQUE
);

CREATE TABLE "interventions" (
  "id_intervention" integer PRIMARY KEY,
  "id_incident" integer,
  "id_technicien" integer,
  "date_debut" timestamp,
  "date_fin" timestamp,
  "statut" varchar,
  "compte_rendu" text
);

ALTER TABLE "bornes" ADD FOREIGN KEY ("id_station") REFERENCES "stations" ("id_station") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "vehicules" ADD FOREIGN KEY ("id_client") REFERENCES "clients" ("id_client") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "sessions_recharge" ADD FOREIGN KEY ("id_borne") REFERENCES "bornes" ("id_borne") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "sessions_recharge" ADD FOREIGN KEY ("id_vehicule") REFERENCES "vehicules" ("id_vehicule") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "paiements" ADD FOREIGN KEY ("id_session") REFERENCES "sessions_recharge" ("id_session") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "incidents" ADD FOREIGN KEY ("id_borne") REFERENCES "bornes" ("id_borne") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "interventions" ADD FOREIGN KEY ("id_incident") REFERENCES "incidents" ("id_incident") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "interventions" ADD FOREIGN KEY ("id_technicien") REFERENCES "techniciens" ("id_technicien") DEFERRABLE INITIALLY IMMEDIATE;
