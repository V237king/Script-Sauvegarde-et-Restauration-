#!/bin/bash

#variables

#la variable suivante contient le chemin absolu du repertoire R1 dans le serveur locale S1
 
source="/home/agent1/R1/"

#la variable suivante contient le chemin absolu du repertoire R2 dans le serveur distant S2 
#l'acces a S2 se fait via une connexion ssh

dest="opennms@192.168.1.101:/home/opennms/Bureau/R2/"

#la variable suivante contient le chemin vers le repertoire du serveur S2 distant
#contenant les sauvegardes differentielles

dest_backup="opennms@192.168.1.101:/home/opennms/Bureau/sauvegarde"

#le repertoire ci-dessous est celui  contenant les sauvegardes differentielles en locales 

backup_diff="/home/agent1/sauvegarde_diff/"

#date des sauvegardes differentielles

date=$(date +"%d-%m-%Y")

#logs sur les suavegardes differentielles qui seront conrtnue dans des repertoires differents 
#selon la date a  la quelle la sauvegarde differentielle a ete effectuee

log_file_diff="/var/log/sauvegarde_diff_${date}.log"

#repertoire qui contiendra les log sur la sauvegarde

log_stdout_diff="/var/log/backup_diff_${date}.log" 

# repertoire qui contiendra les erreurs qui pourraient surgir lors de la sauvegarde

log_stderr_diff="/var/log/error_backup_diff_${date}.log"

#la commande suivante creera une variable  nommee modifications dans la quelle sera stockee 
#les fichiers et/repertoires qui ont ete modifiers en effectuant une comparaison entre le contenu
#du repertoire distant et celui du repertoire source 
 
modifications=$(rsync -av --dry-run --compare-dest="$dest" "$source" "$backup_diff" | grep -v "sending incremental file list" | grep -v "^$")

#ici on verifi si le contenu de la variable modifications a change: si oui, on copie le fichier ou repertoire 
#concerner dans le repertoire contenant les sauvegardes differentielle dans le serveur distant S2
#sinon, on envoie juete le message pour informe qu'aucune sauvegarde na ete faite.
 
  if [ -z "$modifications" ]; then

echo "Aucune modification detectee. Sauvegarde non necessaire. " 
exit 0 

   fi


#sauvegarde differentielle du repertoire R1 en local avant transfert

rsync -av --compare-dest="$dest" "$source" "$backup_diff"  > "$log_stdout_diff" 2> "$log_stderr_diff"

#transfert du repertoire contenant la sauvegarde differentielle effectuee

rsync -av "$backup_diff" "$dest_backup" > "$log_stdout_diff" 2> "$log_stderr_diff"

 
echo "sauvegarde differentielle effectuee avec succes"




