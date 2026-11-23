*** Variables ***
${URL}                    http://livraison3.testacademy.fr/
${BROWSER}                firefox
${BTN_CHERCHER}           xpath://button[contains(.,'Chercher')]
${CONTENEUR_RESULTATS}    id:homey_halfmap_listings_container
${LISTE_ANNONCES}         xpath://*[@id='homey_halfmap_listings_container']//*[contains(@class,'item-wrap')]
${COMPTEUR_RESULTATS}     id:listings_found
${PAGINATION}             css:nav.half_map_ajax_pagi ul.pagination
${LIEN_PAGE_2}            css:ul.pagination a[data-homeypagi='2']
${LISTE_DESTINATION}      css:.banner-caption .filter-option
${VILLE_RECHERCHEE}       Bordeaux
${ADRESSES_ANNONCES}      css:#homey_halfmap_listings_container .item-address