#On va installer proftpd en tant que service ftp
apt-get install -y proftpd

###################################################
###################################################
##                                                #
##  IL FAUT CHOISIR INDEPENDANT LORS DU CHOIX     #
##                                                #
###################################################
###################################################

$ServerName="toto"
sed -i 's|"Debian"|"Mon Serveur FTP"|' /etc/proftpd/proftpd.conf
sed -i 's|# DefaultRoot|DefaultRoot|' /etc/proftpd/proftpd.conf
sed -i 's|21|2121|' /etc/proftpd/proftpd.conf
sed -i 's|# PassivePorts|PassivePorts|' /etc/proftpd/proftpd.conf
sed -i 's|49152 65534|63990 64000|' /etc/proftpd/proftpd.conf

#Il faut savoir qu’en autorisant les ports 63990 a 64000 pour le ftp, cela permet 5 utilisateurs
#On redémarre tout ça
service proftpd restart
