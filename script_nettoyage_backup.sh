#!/bin/bash

#le repertoire ci-dessous est celui  contenant les sauvegardes differentielles en locales 

diff_backup_dir="/home/agent1/sauvegarde_diff/"

#le contenu de la variable DATE suivante contient la date a la quelle le nettoyage se fait

DATE=$(date + "%Y-%m-%d")

#il s'agit ici du chemin vers le repertoire contenant les logs generes lors de la sauvedare

log_nettoyage="/var/log/nettoyage_backup.log"

#la variable suivante contient le chemin vers le repertoire du serveur S2 distant
#contenant les sauvegardes differentielles

remote_diff_dir="/home/opennms/Bureau/sauvegarde/"

#suppression des repertoires et/ou fichiers anciens en local
#contenues dans le repertoire /home/agent1/sauvegarde_diff

find "$diff_backup_dir" -type f -mtime +7 -exec rm {} \; >> "$log_nettoyage" 2>&1

find "$full_backup_dir" -type f -mtime +28 -exec rm {} \; >> "$log_nettoyage" 2>&1

find "$full_backup_dir" -type f -mtime +180 -exec rm {} \;>> "$log_nettoyage" 2>&1

#supression des fichiers ou repertoires dans le repertoire distant contenant les sauvegardes differentielles

#les lignes ci-dessous permettent de se connecter au serveur distant S1 via une connexion ssh
#et d'effectuer les  suppressions dans le repertoir contenant les sauvegardes diff en utilisant la commande find
#la suppression concerne uniquement les repertoire ayant ete modifier il ya plus de 7jours, 1 mois et 6 mois

ssh opennms@192.168.1.101 "find '$remote_diff_dir' -type f -mtime +7 -exec rm {} \;" 


ssh opennms@192.168.1.101 "find '$remote_diff_dir' -type f -mtime +28 -exec rm {} \;"


ssh opennms@192.168.1.101 "find '$remote_diff_dir' -type f -mtime +180 -exec rm {} \;" 


#messages de fin

echo "nettoyage local et distant effectue le '$DATE'" 

