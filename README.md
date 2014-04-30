postinstalldebian.sh
====================

Configuration d'un serveur à partir d'une install propre de Debian 7.5
Pour modifier l'utilisateur à créer : 
modifiez "sylan" par le nom que vous voulez dans le script (lignes 6,7,8,9)


moniptables.sh
==============

Pour règler automatiquement iptables. 
Les ports ouverts correspondent aux ports modifiés dans les différents scripts.
A adapter suivant votre configuration.


nginx-php5-fpm.sh
==============

Pour installer automatiquement nginx et php5-fpm et configurer un vhost.
A noter que votre nom de domaine (example.org) doit être configuré pour pointer vers l'ip de votre serveur.


/!\ A venir /!\
Proftpd / Mysql / Phpmyadmin
