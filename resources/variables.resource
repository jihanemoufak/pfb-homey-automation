*** Variables ***
${URL}                    http://livraison3.testacademy.fr/
${BROWSER}                firefox
${BTN_CHERCHER}           xpath://button[contains(.,'Chercher')]
${CONTENEUR_RESULTATS}    id:homey_halfmap_listings_container
${LISTE_ANNONCES}         xpath://*[@id='homey_halfmap_listings_container']//*[contains(@class,'item-wrap')]