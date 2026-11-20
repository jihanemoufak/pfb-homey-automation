*** Settings ***
Documentation     US-01 : Réaliser une recherche simple
Resource          ../resources/keywords.resource
Test Setup        Ouvrir Homey
Test Teardown     Close All Browsers

*** Test Cases ***
US01-S1 Recherche Sans Critere
    [Documentation]    ÉTANT DONNÉ un utilisateur sur la page d'accueil, QUAND il clique sur Chercher
    ...                sans renseigner de critère, ALORS la page de résultats s'affiche
    ...                et la liste contient les annonces publiées.
    [Tags]    US-01    scenario-1    recherche
    Cliquer Sur Chercher
    Verifier Page Resultats Affichee
    Verifier Liste Annonces Non Vide