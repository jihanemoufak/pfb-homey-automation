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

Verifier Compteur Resultats
    Wait Until Page Contains Element    ${COMPTEUR_RESULTATS}    timeout=10s
    Wait Until Element Contains    ${COMPTEUR_RESULTATS}    Location    timeout=10s
    ${texte}=    Get Text    ${COMPTEUR_RESULTATS}
    Log    Texte lu : ${texte}
    ${nombre}=    Evaluate    int(re.search(r'[0-9]+', $texte).group())    modules=re
    Should Be True    ${nombre} > 0
    Log    Compteur affiché : ${nombre}

Verifier Pagination Presente
    Wait Until Page Contains Element    ${PAGINATION}    timeout=10s
    Page Should Contain Element    ${LIEN_PAGE_2}