#!/bin/sh

# On installe mysql et l'extension php correspondante
apt-get install -y  mysql-server php5-mysql

###############################################
###############################################
##                                           ##
## METTEZ UN MOT DE PASSE POUR MYSQL         ##
##                                           ##
###############################################
###############################################

# Il serait bien de sécuriser tout ça... 
# Pour le prochain script, rentrez votre mot de passe de mysql définit juste avant
# Puis vous pouvez répondre non pour le changement de mot de passe (n)
# Repondez oui pour enlever les utilisateurs anonymes (y)
# Repondez oui ou non pour l'acces root à distance suivant vos besoins 
# Repondez oui a la suppression de la base de donnee test (y)
# Et pour finir oui au rechargement des tables (y)
mysql_secure_installation

#
