postinstalldebian.sh
====================

Configuration d'un serveur à partir d'une install propre de Debian 7.5


moniptables.sh
==============

Pour règler automatiquement iptables. 
Les ports ouverts correspondent aux ports modifiés dans les différents scripts.
A adapter suivant votre configuration.


nginx-php5-fpm.sh
==============

Pour installer automatiquement nginx et php5-fpm et configurer un domaine.
A noter que votre nom de domaine (example.org) doit être configuré pour pointer vers l'ip de votre serveur.


proftpd.sh
==============

Pour installer automatiquement proftpd et le configurer.


mysql-phpmyadmin.sh
==============

Pour installer automatiquement mysql, l'interface web phpmyadmin.
Pour configurer phpmyadmin avec nginx pour y accéder depuis un sous-domaine.
A noter que votre sous-domaine (phpmyadmin.example.org) doit être configuré pour pointer vers l'ip de votre serveur.
Ajout d'une authentification par mot de passe pour l'accès a phpmyadmin.
