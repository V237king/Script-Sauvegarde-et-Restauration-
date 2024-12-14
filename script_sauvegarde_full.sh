#!/bin/bash

echo "bonjour, nous allons effectuer la sauvegarde complete du repertoire R1 vers le repertoire R2"

# variables
#la variable suivante contient le chemin absolu du repertoire R1 dans le serveur locale S1

repertoire_local="/home/agent1/R1/"

#la variable suivante contient le chemin absolu du repertoire R2 dans le serveur distant S2 
#l'acces a S2 se fait via une connexion ssh

repertoire_distant="opennms@192.168.1.101:/home/opennms/Bureau/R2/"

#le contenu de la variable date suivante contient la date a la quelle la sauvegarde complete se fait

date=$(date +"%Y-%m-%d")

#repertoire suivant contient les logs de la sortie stdout durant la sauvegarde 

log_stdout="/var/log/full_backup_${date}.log" 

#le repertoire suivant contiendra les erreurs qui pourraient surgir lors de la sauvegarde

log_stderr="/var/log/full_backup1_${date}.log"

#commande rsync permettant de faire la sauvegarde du repertoire R1 du serveur s1 vers le repertoire R2 de S2

rsync -avz "$repertoire_local"  "$repertoire_distant" > "$log_stdout" 2> "$log_stderr"

echo "sauvegarde complete effectuee avec succes."



