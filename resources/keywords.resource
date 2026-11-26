*** Settings ***
Library     SeleniumLibrary
Library     DateTime
Resource    variables.resource

*** Keywords ***
# =============================================================================
# MOTS-CLÉS COMMUNS : ACTIONS (utilisés par plusieurs US)
# =============================================================================

# Précondition : ouvre Homey dans le navigateur cible (US-01, US-02)
# Une nouvelle tentative est faite si le navigateur ne démarre pas (instabilité du pilote)
Ouvrir Homey
    Wait Until Keyword Succeeds    2x    3s    Open Browser    ${URL}    ${BROWSER}
    Set Window Size    1920    1032

# Lance la recherche avec les critères renseignés
Cliquer Sur Chercher
    Click Element    ${BTN_CHERCHER}

# Ouvre la liste déroulante et choisit une commune
Renseigner Destination
    [Arguments]      ${ville}
    Click Element    ${LISTE_DESTINATION}
    Click Element    link:${ville}

# Retourne la date du jour + N jours au format AAAA-MM-JJ
Calculer Date
    [Arguments]    ${jours}
    ${date}=    Get Current Date    increment=${jours} days    result_format=%Y-%m-%d
    RETURN    ${date}

# Saisit les dates de début et de fin au clavier
Renseigner Dates
    [Arguments]    ${debut}    ${fin}
    Input Text    ${CHAMP_DEBUT}    ${debut}
    Input Text    ${CHAMP_FIN}    ${fin}

# Ajoute N adultes dans le menu Voyageurs puis clique sur Appliquer
Renseigner Voyageurs Adultes
    [Arguments]    ${nombre}
    Click Element    ${CHAMP_VOYAGEURS}
    FOR    ${i}    IN RANGE    ${nombre}
        Click Element    ${BTN_ADULTE_PLUS}
    END
    Click Element    ${BTN_APPLIQUER}

# =============================================================================
# MOTS-CLÉS COMMUNS : VÉRIFICATIONS (utilisées par plusieurs US)
# =============================================================================

# L'URL contient le paramètre attendu, ex. city=bordeaux
Verifier Url Contient Critere
    [Arguments]    ${valeur}
    ${url}=    Get Location
    Should Contain    ${url}    ${valeur}    ignore_case=True

# Compare la valeur affichée dans un champ à la valeur attendue (rappel des critères)
Verifier Valeur Champ
    [Arguments]    ${localisateur}    ${attendu}
    ${valeur}=    Get Value    ${localisateur}
    Should Be Equal    ${valeur}    ${attendu}

# =============================================================================
# US-01 : Réaliser une recherche simple
# =============================================================================

# ----- Éléments communs aux scénarios de US-01 -----

# La page de résultats est affichée : conteneur présent (S1 à S4)
Verifier Page Resultats Affichee
    Wait Until Page Contains Element    ${CONTENEUR_RESULTATS}    timeout=10s

# Le compteur « N Location » indique au moins un résultat (S1, S2, S3)
Verifier Compteur Resultats
    Wait Until Page Contains Element    ${COMPTEUR_RESULTATS}    timeout=10s
    Wait Until Element Contains    ${COMPTEUR_RESULTATS}    Location    timeout=10s
    ${texte}=    Get Text    ${COMPTEUR_RESULTATS}
    Log    Texte lu : ${texte}
    ${nombre}=    Evaluate    int(re.search(r'[0-9]+', $texte).group())    modules=re
    Should Be True    ${nombre} > 0
    Log    Compteur affiché : ${nombre}

# Au moins une annonce est affichée sur la page courante (S1, S2)
Verifier Liste Annonces Non Vide
    Wait Until Page Contains Element    ${LISTE_ANNONCES}    timeout=10s
    ${nombre}=    Get Element Count    ${LISTE_ANNONCES}
    Should Be True    ${nombre} > 0
    Log    Nombre d'annonces affichées : ${nombre}

# ----- Scénario 1 : Recherche sans critère -----

# La liste est paginée : la pagination et le lien vers la page 2 sont présents
Verifier Pagination Presente
    Wait Until Page Contains Element    ${PAGINATION}    timeout=10s
    Page Should Contain Element    ${LIEN_PAGE_2}

# ----- Scénario 2 : Recherche avec un seul critère (aussi utilisés en S3) -----

# Le rappel des critères affiche la ville dans la barre de recherche
Verifier Destination Rappelee
    [Arguments]    ${ville}
    Page Should Contain Element    xpath://*[contains(@class,'filter-option') and contains(.,'${ville}')]

# Chaque annonce de la page contient la ville dans son adresse
Verifier Adresses Contiennent
    [Arguments]    ${ville}
    ${adresses}=    Get WebElements    ${ADRESSES_ANNONCES}
    Should Not Be Empty    ${adresses}
    FOR    ${adresse}    IN    @{adresses}
        ${texte}=    Get Element Attribute    ${adresse}    textContent
        Should Contain    ${texte}    ${ville}    ignore_case=True
    END

# ----- Scénario 4 : Aucun résultat trouvé -----

# Le message « aucun résultat » est affiché et aucune annonce n'est présente
Verifier Aucun Resultat
    Wait Until Page Contains Element    ${MESSAGE_AUCUN_RESULTAT}    timeout=10s
    Element Should Contain    ${MESSAGE_AUCUN_RESULTAT}    aucun résultat
    Page Should Not Contain Element    ${LISTE_ANNONCES}

# Le compteur vaut 0 (libellé « De location » ignoré, seul le nombre compte)
Verifier Compteur Zero
    Wait Until Element Contains    ${COMPTEUR_RESULTATS}    0    timeout=10s
    ${texte}=    Get Text    ${COMPTEUR_RESULTATS}
    ${nombre}=    Evaluate    int(re.search(r'[0-9]+', $texte).group())    modules=re
    Should Be Equal As Integers    ${nombre}    0

# ----- Scénario 5 : Critère non valide (oracles alignés sur la spécification) -----

# La page de résultats ne doit pas s'afficher (l'URL ne doit pas contenir search-results)
Verifier Page Resultats Non Affichee
    ${affichee}=    Run Keyword And Return Status
    ...    Wait Until Location Contains    search-results    timeout=5s
    Should Not Be True    ${affichee}    La page de résultats ne devrait pas s'afficher.

# Un message indique que le critère n'est pas valide
Verifier Message Critere Invalide
    Page Should Contain Element    xpath://*[contains(normalize-space(text()),'valide')]

# Ouvre la liste Destination et saisit un texte libre dans son champ de recherche
Saisir Destination Libre
    [Arguments]    ${texte}
    Click Element    ${LISTE_DESTINATION}
    Input Text    ${CHAMP_RECHERCHE_DESTINATION}    ${texte}

# =============================================================================
# US-02 : Faire une demande de réservation
# =============================================================================