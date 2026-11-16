
-- 1. Index pour retrouver rapidement les sessions d'un véhicule
CREATE INDEX idx_sessions_vehicule ON sessions_recharge(id_vehicule);

-- 2. Index pour identifier rapidement les incidents par borne
CREATE INDEX idx_incidents_borne ON incidents(id_borne);
