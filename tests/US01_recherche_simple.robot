*** Settings ***
Documentation     US-01 : Réaliser une recherche simple
Resource          ../resources/keywords.resource
Test Setup        Ouvrir Homey
Test Teardown     Close All Browsers

*** Test Cases ***
US01-S1 Recherche Sans Critere
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il clique sur Chercher
    ...                sans renseigner de critère, ALORS la page de résultats s'affiche,
    ...                le compteur indique au moins un résultat et la liste est paginée.
    ...                Limite : l'oracle ne vérifie pas que TOUTES les annonces publiées sont
    ...                retournées (le total évolue avec la création d'annonces, cf. autre US).
    [Tags]    US-01    scenario-1    recherche
    Cliquer Sur Chercher
    Verifier Page Resultats Affichee
    Verifier Compteur Resultats
    Verifier Liste Annonces Non Vide
    Verifier Pagination Presente

US01-S2 Recherche Avec Un Seul Critere
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il renseigne
    ...                uniquement la destination, ALORS la page de résultats s'affiche
    ...                et la liste contient des annonces.
    ...                Oracle : URL, rappel de la destination et adresse de chaque annonce de la page 1 contiennent la ville.
    [Tags]    US-01    scenario-2    recherche
    Renseigner Destination    ${VILLE_RECHERCHEE}
    Cliquer Sur Chercher
    Verifier Page Resultats Affichee
    Verifier Compteur Resultats
    Verifier Liste Annonces Non Vide
    Verifier Url Contient Critere    city=${VILLE_RECHERCHEE}
    Verifier Destination Rappelee    ${VILLE_RECHERCHEE}
    Verifier Adresses Contiennent    ${VILLE_RECHERCHEE}

US01-S3 Recherche Avec Plusieurs Criteres
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il renseigne
    ...                la destination, les dates et le nombre de voyageurs, ALORS la page de
    ...                résultats s'affiche, rappelle les critères et ne liste que des annonces
    ...                de la destination.
    ...                Limite : la disponibilité sur la période et la capacité de chaque
    ...                annonce ne sont pas contrôlées.
    [Tags]    US-01    scenario-3    recherche
    ${debut}=    Calculer Date    21
    ${fin}=    Calculer Date    27
    Renseigner Destination    ${VILLE_RECHERCHEE}
    Renseigner Dates    ${debut}    ${fin}
    Renseigner Voyageurs Adultes    ${NB_ADULTES}
    Cliquer Sur Chercher
    Verifier Page Resultats Affichee
    Verifier Compteur Resultats
    Verifier Url Contient Critere    city=${VILLE_RECHERCHEE}
    Verifier Url Contient Critere    arrive=${debut}
    Verifier Url Contient Critere    depart=${fin}
    Verifier Url Contient Critere    adult_guest=${NB_ADULTES}
    Verifier Destination Rappelee    ${VILLE_RECHERCHEE}
    Verifier Valeur Champ    ${CHAMP_DEBUT}    ${debut}
    Verifier Valeur Champ    ${CHAMP_FIN}    ${fin}
    Verifier Valeur Champ    ${CHAMP_VOYAGEURS}    ${NB_ADULTES}
    Verifier Adresses Contiennent    ${VILLE_RECHERCHEE}


US01-S4 Recherche Sans Resultat
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il renseigne
    ...                des critères valides auxquels aucune annonce ne répond, ALORS la page
    ...                de résultats s'affiche et la liste est vide avec un message
    ...                « Nous n'avons trouvé aucun résultat ».
    ...                Limite : le jeu de données (Amsterdam, +420 jours) suppose qu'aucune
    ...                annonce n'y soit créée par une autre US.
    [Tags]    US-01    scenario-4    recherche
    ${debut}=    Calculer Date    420
    ${fin}=    Calculer Date    426
    Renseigner Destination    ${VILLE_SANS_RESULTAT}
    Renseigner Dates    ${debut}    ${fin}
    Renseigner Voyageurs Adultes    ${NB_ADULTES}
    Cliquer Sur Chercher
    Verifier Page Resultats Affichee
    Verifier Url Contient Critere    city=${VILLE_SANS_RESULTAT}
    Verifier Url Contient Critere    arrive=${debut}
    Verifier Compteur Zero
    Verifier Aucun Resultat

US01-S5a Critere Non Valide Date Debut Anterieure
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il saisit une
    ...                date de début antérieure à aujourd'hui (la veille), ALORS la page de
    ...                résultats ne s'affiche pas et un message indique que le critère n'est
    ...                pas valide.
    ...                Défaut connu : l'application ouvre la page de résultats sans message.
    [Tags]    US-01    scenario-5    recherche    defaut-connu
    ${debut}=    Calculer Date    -1
    ${fin}=    Calculer Date    5
    Renseigner Dates    ${debut}    ${fin}
    Cliquer Sur Chercher
    Verifier Page Resultats Non Affichee
    Verifier Message Critere Invalide

US01-S5b Critere Non Valide Destination Trop Longue
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il saisit une
    ...                destination de plus de 20 caractères, ALORS la page de résultats ne
    ...                s'affiche pas et un message indique que le critère n'est pas valide.
    ...                Défaut connu : la recherche est lancée avec city vide et renvoie
    ...                toutes les annonces, sans message d'erreur.
    [Tags]    US-01    scenario-5    recherche    defaut-connu
    Saisir Destination Libre    ${DESTINATION_TROP_LONGUE}
    Cliquer Sur Chercher
    Verifier Page Resultats Non Affichee
    Verifier Message Critere Invalide

US01-S5c Critere Non Valide Date Fin Anterieure Au Debut
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il saisit une
    ...                date de fin antérieure à la date de début (les deux dates étant
    ...                postérieures à aujourd'hui), ALORS la page de résultats ne s'affiche
    ...                pas et un message indique que le critère n'est pas valide.
    ...                Résultat observé à confirmer : à l'exécution manuelle, vérifier si
    ...                l'application refuse la saisie ou lance la recherche.
    [Tags]    US-01    scenario-5    recherche    defaut-connu
    ${debut}=    Calculer Date    10
    ${fin}=    Calculer Date    5
    Renseigner Dates    ${debut}    ${fin}
    Cliquer Sur Chercher
    Verifier Page Resultats Non Affichee
    Verifier Message Critere Invalide