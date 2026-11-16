
## 3.1. Cardinalités et relations entre les tables

Les relations entre les tables permettent de définir les liens entre les différentes données de la base.

### Station et Borne

- Une station peut posséder plusieurs bornes.
- Une borne est rattachée à une seule station.

**Cardinalité :** Station (1,N) — Borne 

### Client et Véhicule

- Un client peut enregistrer plusieurs véhicules.
- Un véhicule appartient à un seul client.

**Cardinalité :** Client (1,N) — Véhicule

### Borne et Session de recharge

- Une borne peut être utilisée dans plusieurs sessions.
- Une session utilise une seule borne.

**Cardinalité :** Borne (0-1,N) — Session 

### Véhicule et Session de recharge

- Un véhicule peut participer à plusieurs sessions de recharge.
- Une session concerne un seul véhicule.

**Cardinalité :** Véhicule (0-1,N) — Session 

### Session et Paiement

- Une session annulée ne génère pas de paiement.
- Un paiement est associé à une seule session.

**Cardinalité :** Session (0-1,1) — Paiement 

### Incident et Intervention

- Un incident peut nécessiter plusieurs interventions.
- Chaque intervention concerne un seul incident.

**Cardinalité :** Incident (0,N) — Intervention 

### Technicien et Intervention

- Un technicien peut réaliser plusieurs interventions.
- Chaque intervention est réalisée par un seul technicien.

**Cardinalité :** Technicien (0-1,N) — Intervention 

## 3.2. Normalisation de la base de données

La base de données est organisée selon les principes de la troisième forme normale (3FN).

Les choix suivants ont été faits :

- **Clés primaires :** Chaque table possède un identifiant unique (`id_*`) pour distinguer chaque enregistrement.
- **Clés étrangères :** Elles permettent de relier les tables entre elles et de garantir la cohérence des données.
- **Éviter les doublons :** Les informations des clients sont enregistrées uniquement dans la table `clients`.
- **Relations entre les données :** La table `vehicules` utilise `id_client` pour retrouver son propriétaire. La table `sessions_recharge` utilise `id_vehicule` pour retrouver le véhicule concerné.
