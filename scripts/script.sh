#!/bin/bash


#Verification de si le nombre d'arguments n'est pas égale à 2.
if [$# -ne 2 ]; then 
    echo "Usage : $0 <input.csv> <output.csv>"
    exit 1
fi

# ===============================
# Filtrage du CSV
# Objectif :
#   - Supprimer les lignes inutiles
#   - Garder seulement les relations exploitables
#   - Tout mettre dans le fichier propre data.csv 
# ===============================


INPUT="$1"          # data.csv
OUTPUT="$2"         # clean.csv


 