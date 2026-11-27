# Sauvegardes

## Persistance de la base

Dans le fichier compose.yaml pour mettre docker,on permet de mettre des volumes pour le serveur de base de données et pgadmin qui seront gérer par docker.

![1795445773303](Sauvegardes/1795445773303.png)

## Sauvergardes et restauration

Pour vérifier si les sauvegardes marchent, on créé une sauvegarde de la base de donnée *db* puis on fait une base de données de test pour vérifier que les données sont bien implémenter dans la base de secours *db_backup*. Les tests sont un succès.

![1795445538027](Sauvegardes/1795445538027.png)

## Vérifications des données

Pour vérifier les données,on fait la requête sql suivante pour chaque table sur les deux bases et on vérifie si les données sont identiques.

```SQL
SELECT COUNT(*) from <table>
```

Résultats de *db* :

| table_name        | total  |
| ----------------- | ------ |
| techniciens       | 120    |
| stations          | 120    |
| bornes            | 600    |
| interventions     | 4162   |
| incidents         | 5000   |
| clients           | 15000  |
| vehicules         | 18000  |
| paiements         | 217300 |
| sessions_recharge | 250000 |

Résulats de *db_backup* :

| table_name        | total  |
| ----------------- | ------ |
| techniciens       | 120    |
| stations          | 120    |
| bornes            | 600    |
| interventions     | 4162   |
| incidents         | 5000   |
| clients           | 15000  |
| vehicules         | 18000  |
| paiements         | 217300 |
| sessions_recharge | 250000 |

Les résulats sont identiques donc les données sont bien implémenter après réstauration.
