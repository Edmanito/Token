#!/bin/bash


start=$(date +%s)  ## on stock l'heure du depart dans start




                                            ##### Commande principale #####



#Verification de s'il n y a aucun argument.
if [ $# -lt 1 ]; then
    echo "Usage : $0 {histo max|src|real | leaks <ID_usine>}"
    exit 1
fi

cmd=$1   


                                            ##### PARTIE HISTOGRAMME #####

if [ "$cmd" = "histo" ]; then

    # On doit avoir 2 arguments : histo + (max/src/real)
    if [ $# -ne 2 ]; then
        echo "Erreur : histo nécessite un argument : max | src | real"
        exit 1
    fi

    mode=$2

    # Vérification du mode
    if [ "$mode" != "max" ] && [ "$mode" != "src" ] && [ "$mode" != "real" ]; then
        echo "Mode histo invalide"
        exit 1
    fi

    
    # FILTRAGE AVEC AWK
    # On récupère les lignes SOURCES->USINES
    
    awk -F';' '$1=="-" && $4!="-" && $5!="-" {print}' big.csv > data/sources.csv

    # On récupère les lignes USINES SEULES
    awk -F';' '$1=="-" && $3=="-" && $5=="-" {print}' big.csv > data/usines.csv

    
    # Compilation automatique du C
    
    if [ ! -f exe ]; then
        make
        if [ $? -ne 0 ]; then
            echo "Erreur : compilation échouée"
            exit 1
        fi
    fi

    
    # Appel au programme C
    
    ./exe histo "$mode" data/sources.csv data/usines.csv > data/histo_output.csv

    if [ $? -ne 0 ]; then
        echo "Erreur dans le programme C"
        exit 1
    fi

    echo "Histogramme CSV généré dans data/histo_output.csv"

fi


####
#                       PARTIE LEAKS
if [ "$cmd" = "leaks" ]; then

    if [ $# -ne 2 ]; then
        echo "Erreur : leaks nécessite un ID d'usine"
        exit 1
    fi

    usine="$2"

    # Filtrage : toutes les lignes où apparait l’usine
    grep "$usine" big.csv > data/reseau.csv

    if [ ! -f exe ]; then
        make
        if [ $? -ne 0 ]; then
            echo "Erreur compilation"
            exit 1
        fi
    fi

    # Appel du C
    ./exe leaks "$usine" data/reseau.csv > data/temp_fuites.txt

    valeur=$(cat data/temp_fuites.txt)

    echo "$usine ; $valeur" >> data/leaks.dat

    echo "Fuites calculées : $valeur M.m3"
fi


# Affichage de la durée totale
end=$(date +%s)
echo "Durée totale : $(($end - $start)) secondes"

exit 0
