-- verifications urbanwatt

-- nombre de lignes par table
select count(*) from stations;
select count(*) from bornes;
select count(*) from clients;
select count(*) from vehicules;
select count(*) from sessions_recharge;
select count(*) from incidents;
select count(*) from interventions;
select count(*) from paiements;

-- orphelins (doivent tous donner 0)
select count(*) from bornes
where id_station not in (select id_station from stations);

select count(*) from vehicules
where id_client not in (select id_client from clients);

select count(*) from sessions_recharge
where id_borne not in (select id_borne from bornes)
   or id_vehicule not in (select id_vehicule from vehicules);

-- statuts des sessions
select statut, count(*) from sessions_recharge group by statut;

-- index
create index idx_sessions_vehicule on sessions_recharge(id_vehicule);
create index idx_incidents_borne on incidents(id_borne);
