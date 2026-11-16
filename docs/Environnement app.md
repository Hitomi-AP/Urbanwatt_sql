# Gestion des dépendances Python

Pour le projet **URBANWATT**, nous utilisons **uv** pour gérer les dépendances et l'environnement Python.

Ce choix repose sur plusieurs avantages :

- **Rapidité :** installation rapide des bibliothèques.
- **Reproductibilité :** `uv.lock` conserve les versions exactes des dépendances.
- **Simplicité :** gestion des dépendances et de l'environnement virtuel (`.venv`) avec un seul outil.
- **Organisation :** les dépendances sont centralisées dans `pyproject.toml`.
- **Docker :** facilite l'installation des dépendances lors du déploiement.

## Structure du projet

```text
Urbanwatt_sql/
├── app/
│   ├── main.py
│   ├── database.py
│   └── routes/
├── docs/
├── infra/
├── sql/
├── sauvegardes/
├── .venv/
├── .python-version
├── pyproject.toml
├── uv.lock
└── README.md
```

## Commandes principales

Toutes les commandes sont exécutées depuis la racine du projet.

```bash
# Initialiser le projet (une seule fois)
uv init

# Installer les dépendances
uv add "fastapi[standard]" "psycopg[binary]"

# Synchroniser l'environnement
uv sync

# Lancer l'application
uv run fastapi dev main.py
```

## Conclusion

uv permet de maintenir un environnement Python organisé et reproductible. La configuration reste à la racine du projet, tandis que le code de l'application est regroupé dans `app/`.
