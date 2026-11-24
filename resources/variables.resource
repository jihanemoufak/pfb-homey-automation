*** Variables ***
# =============================================================================
# CONFIGURATION GÉNÉRALE
# =============================================================================
${URL}                    http://livraison3.testacademy.fr/
${BROWSER}                firefox

# =============================================================================
# PAGE D'ACCUEIL : barre de recherche (S1 à S5)
# =============================================================================
${BTN_CHERCHER}           xpath://button[contains(.,'Chercher')]
${LISTE_DESTINATION}      css:.banner-caption .filter-option
${CHAMP_DEBUT}            name:arrive
${CHAMP_FIN}              name:depart
${CHAMP_VOYAGEURS}        name:guest
${BTN_ADULTE_PLUS}        css:.banner-caption .search_adult_plus > .fa
${BTN_APPLIQUER}          css:.banner-caption .guest-apply-btn > .btn

# =============================================================================
# PAGE DE RÉSULTATS : éléments communs (S1 à S4)
# =============================================================================
${CONTENEUR_RESULTATS}    id:homey_halfmap_listings_container
${LISTE_ANNONCES}         xpath://*[@id='homey_halfmap_listings_container']//*[contains(@class,'item-wrap')]
${COMPTEUR_RESULTATS}     id:listings_found

# =============================================================================
# SCÉNARIO 1 : Recherche sans critère
# =============================================================================
${PAGINATION}             css:nav.half_map_ajax_pagi ul.pagination
${LIEN_PAGE_2}            css:ul.pagination a[data-homeypagi='2']

# =============================================================================
# SCÉNARIO 2 : Recherche avec un seul critère
# =============================================================================
${VILLE_RECHERCHEE}       Bordeaux
${ADRESSES_ANNONCES}      css:#homey_halfmap_listings_container .item-address

# =============================================================================
# SCÉNARIO 3 : Recherche avec plusieurs critères
# =============================================================================
${NB_ADULTES}             2

# =============================================================================
# SCÉNARIO 4 : Aucun résultat trouvé
# =============================================================================
${VILLE_SANS_RESULTAT}    Amsterdam
${MESSAGE_AUCUN_RESULTAT}    css:#homey_halfmap_listings_container .map-notfound

# =============================================================================
# SCÉNARIO 5 : Critère non valide
# (aucune variable spécifique pour l'instant, S5b ajoutera le champ de saisie
#  de la destination)
# =============================================================================