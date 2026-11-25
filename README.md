# pfb-homey-automation

Automatisation des tests de l'application Homey avec Robot Framework
(Projet de fin de bloc B).

## Périmètre

| User Story | Fichier de test | État |
|---|---|---|
| US-01 : Réaliser une recherche simple | `tests/US01_recherche_simple.robot` | Scénarios 1 à 4, 5a, 5b et 5c automatisés |

## Prérequis

- Python 3.8 ou supérieur
- Firefox (le pilote geckodriver est téléchargé automatiquement par Selenium Manager)
- Git
- Accès à l'application : http://livraison3.testacademy.fr/

## Installation

```
git clone git@github.com:jihanemoufak/pfb-homey-automation.git
cd pfb-homey-automation
pip install -r requirements.txt
```

## Exécution des tests

Tous les tests :

```
python -m robot -d results tests
```

Une seule User Story :

```
python -m robot -d results tests/US01_recherche_simple.robot
```

Un seul cas de test :

```
python -m robot -d results -t "US01-S1*" tests/US01_recherche_simple.robot
```

Les rapports (`log.html`, `report.html`, `output.xml`) sont générés dans le
dossier `results/`, qui n'est pas versionné.

## Structure du projet

```
pfb-homey-automation/
├── tests/            # un fichier par User Story
├── resources/
│   ├── keywords.resource    # mots-clés, regroupés par scénario
│   └── variables.resource   # variables et localisateurs
├── results/          # rapports d'exécution (ignoré par Git)
├── Jenkinsfile       # pipeline CI/CD
├── requirements.txt  # dépendances
└── README.md
```

## Défauts connus

L'application ne respecte pas la spécification sur plusieurs critères non valides
(US-01, scénario 5). Les cas de test correspondants suivent la spécification : ils
échouent tant que le défaut n'est pas corrigé. Ils portent le tag `defaut-connu`.

| Cas de test | Spécification (US-01, scénario 5) | Comportement observé |
|---|---|---|
| US01-S5a | Une date de début antérieure à aujourd'hui est refusée : pas de page de résultats, message « critère non valide » | La page de résultats s'ouvre sans message d'erreur (208 annonces avec `2026-10-10`, 0 avec `2026-11-15`) |
| US01-S5b | Une destination de plus de 20 caractères est refusée : pas de page de résultats, message « critère non valide » | La recherche part avec `city` vide et la page de résultats affiche les 223 annonces, sans message |
| US01-S5c | La date de fin ne peut pas être antérieure à la date de début : pas de page de résultats, message « critère non valide » | La page de résultats s'ouvre sans message d'erreur et affiche les 223 annonces (début `2026-12-03`, fin `2026-11-27`) |

Exécution complète (les défauts apparaissent en échec) :

```
python -m robot -d results tests
```

## Limites connues des oracles

- US01-S1 : l'oracle ne vérifie pas que toutes les annonces publiées sont
  retournées (le total évolue avec la création d'annonces) ; il contrôle le
  compteur, la liste et la pagination.
- US01-S4 : le jeu de données (Amsterdam, dates à +420 jours) suppose
  qu'aucune annonce n'y soit créée par une autre US.
- Les dates sont calculées dynamiquement (aujourd'hui + N jours).![alt text](image.png)![![alt text](image-2.png)](image-1.png)