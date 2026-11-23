*** Settings ***
Library     SeleniumLibrary
Library     DateTime
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

Renseigner Destination
    [Arguments]      ${ville}
    Click Element    ${LISTE_DESTINATION}
    Click Element    link:${ville}

Verifier Url Contient Critere
    [Arguments]    ${valeur}
    ${url}=    Get Location
    Should Contain    ${url}    ${valeur}    ignore_case=True

Verifier Destination Rappelee
    [Arguments]    ${ville}
    Page Should Contain Element    xpath://*[contains(@class,'filter-option') and contains(.,'${ville}')]

Verifier Adresses Contiennent
    [Arguments]    ${ville}
    ${adresses}=    Get WebElements    ${ADRESSES_ANNONCES}
    Should Not Be Empty    ${adresses}
    FOR    ${adresse}    IN    @{adresses}
        ${texte}=    Get Element Attribute    ${adresse}    textContent
        Should Contain    ${texte}    ${ville}    ignore_case=True
    END

Calculer Date
    [Arguments]    ${jours}
    ${date}=    Get Current Date    increment=${jours} days    result_format=%Y-%m-%d
    RETURN    ${date}

Renseigner Dates
    [Arguments]    ${debut}    ${fin}
    Input Text    ${CHAMP_DEBUT}    ${debut}
    Input Text    ${CHAMP_FIN}    ${fin}

Renseigner Voyageurs Adultes
    [Arguments]    ${nombre}
    Click Element    ${CHAMP_VOYAGEURS}
    FOR    ${i}    IN RANGE    ${nombre}
        Click Element    ${BTN_ADULTE_PLUS}
    END
    Click Element    ${BTN_APPLIQUER}

Verifier Valeur Champ
    [Arguments]    ${localisateur}    ${attendu}
    ${valeur}=    Get Value    ${localisateur}
    Should Be Equal    ${valeur}    ${attendu}

Verifier Aucun Resultat
    Wait Until Page Contains Element    ${MESSAGE_AUCUN_RESULTAT}    timeout=10s
    Element Should Contain    ${MESSAGE_AUCUN_RESULTAT}    aucun résultat
    Page Should Not Contain Element    ${LISTE_ANNONCES}

Verifier Compteur Zero
    Wait Until Element Contains    ${COMPTEUR_RESULTATS}    0    timeout=10s
    ${texte}=    Get Text    ${COMPTEUR_RESULTATS}
    ${nombre}=    Evaluate    int(re.search(r'[0-9]+', $texte).group())    modules=re
    Should Be Equal As Integers    ${nombre}    0