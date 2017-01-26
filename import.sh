#!/bin/bash
NOW=$(date +'%Y%m%d%H%M%S')
sleep 1
echo "#########################################"
echo "# Script d'importation de configuration #"
echo "#         Service Virtualisation        #"
echo "#########################################"
sleep 1
if [[ $USER='root' ]]; then
echo "Le script doit être executé en ROOT, forcer l'execution quand même ? (oui/non)"
read Force_exec
if [[ $Force_exec != 'oui' ]]; then
exit 0
fi
echo "Voulez-vous envoyer vos fichiers sur le NAS virtu ?(Autorisation de la Virtualisation avant opération !)"
read FTP
fi
echo "Le nom de votre service ?"
read SERVICE
sleep 1
echo "Etape 1: repertoire de destination de la backup ? (default: /home/"$USER"/"$SERVICE"_BACKUP_$NOW)"
read PATHDEST
if [[ -z "$PATHDEST" ]]; then
PATHDEST=$(echo "/home/"$USER"/"$SERVICE"_BACKUP_"$NOW)
fi
echo "Directory to backup : "$PATHDEST
echo "Etape 2: Archive du /etc/ ..."
echo "Voulez-vous sauvegarder le dossier /etc ? (oui/non)"
read pass2
shift
echo "Etape 3: Archive du /var/ ..."
echo "Voulez-vous sauvegarder le dossier /var ? (oui/non)"
read pass3
shift
echo "Etape 3: Archive du /opt/ ..."
echo "Voulez-vous sauvegarder le dossier /opt ? (oui/non)"
read pass4
shift
sleep 1
echo "Etape 4: Création de la sauvegarde"
sleep 1
mkdir $PATHDEST
cd $PATHDEST
tar cvfT BACKUP_$NOW.tar /dev/null
if [[ $pass2 == 'oui' ]]; then
echo "Sauvegarde de /etc ... cela peut prendre du temps ..."
tar -rvf BACKUP_$NOW.tar /etc
fi

if [[ $pass3 == 'oui' ]]; then
echo "Sauvegarde de /var ... cela peut prendre du temps ..."
tar -rvf BACKUP_$NOW.tar /var
fi

if [[ $pass4 == 'oui' ]]; then
echo "Sauvegarde de /opt ... cela peut prendre du temps ..."
tar -rvf BACKUP_$NOW.tar /opt
fi
echo "Terminé avec succès, votre archive est dans $PATHDEST"
if [[ $FTP != 'oui' ]]; then
  exit 0
fi
echo "Etape 5: Envoi de l'archive ..."
sshpass -p 'isagoodboy' scp -r $PATHDEST johnny@10.2.0.250:$(echo "/home/johnny/"$SERVICE"_BACKUP_"$NOW"/BACKUP_"$NOW".tar")

#HOST='10.2.0.250'
#PORT='21'
#LOGIN='johnny'
#PASSWORD='isagoodboy'
#ftp -i -n $HOST $PORT
#quote USER $LOGIN
#quote PASS $PASSWORD
#mkdir $SERVICE
#cd $SERVICE
#put $PATHDEST/$SERVICE_BACKUP_$NOW.tar
#quit
