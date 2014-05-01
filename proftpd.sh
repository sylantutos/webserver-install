#!/bin/sh
# On va installer proftpd en tant que service ftp
apt-get install -y proftpd

###################################################
###################################################
##                                                #
##  IL FAUT CHOISIR INDEPENDANT LORS DU CHOIX     #
##                                                #
###################################################
###################################################

# On renomme le serveur ftp par Mon Serveur FTP
# Vous pouvez le modifier par ce qu'il vous plaira
sed -i 's|"Debian"|"Mon Serveur FTP"|' /etc/proftpd/proftpd.conf
# On confine les utilisateurs dans leur dossier personnel par défaut
sed -i 's|# DefaultRoot|DefaultRoot|' /etc/proftpd/proftpd.conf
# On modifie le port de connexion par 2121
sed -i 's|21|2121|' /etc/proftpd/proftpd.conf
# Il faut savoir qu’en autorisant les ports 63990 a 64000 pour le ftp, cela permet 5 utilisateurs
sed -i 's|# PassivePorts|PassivePorts|' /etc/proftpd/proftpd.conf
sed -i 's|49152 65534|63990 64000|' /etc/proftpd/proftpd.conf

# On redémarre tout ça
service proftpd restart

echo "Votre serveur FTP est à présent fonctionnel"
echo "Vous pouvez vous y connecter avec votre couple user/pass habituel, sur le port 2121"
echo "N'importe quel utilisateur créé sur votre serveur pourra s'y connecter en FTP"
