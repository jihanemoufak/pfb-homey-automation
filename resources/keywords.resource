*** Settings ***
Library     SeleniumLibrary
Resource    variables.resource

*** Keywords ***
Ouvrir Homey
    Open Browser    ${URL}    ${BROWSER}
    Set Window Size    1920    1032

Cliquer Sur Chercher
    Click Element    ${BTN_CHERCHER}

Verifier Page Resultats Affichee
    Wait Until Page Contains Element    ${CONTENEUR_RESULTATS}    timeout=10s

Verifier Liste Annonces Non Vide
    Wait Until Page Contains Element    ${LISTE_ANNONCES}    timeout=10s
    ${nombre}=    Get Element Count    ${LISTE_ANNONCES}
    Should Be True    ${nombre} > 0
    Log    Nombre d'annonces affichées : ${nombre}