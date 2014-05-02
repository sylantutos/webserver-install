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

# On installe maintenant phpmyadmin qui sera notre interface web pour mysql
apt-get install -y phpmyadmin

###############################################
###############################################
##                                           ##
## Ne selectionnez rien pour le serveur web  ##
## Puis repondez non pour dbconfig-common    ##
###############################################
###############################################


# Passons maintenant à l'acces a phpmyadmin
# Pour plus de securite, on ne va pas utiliser l'habituel
# http://example.org/phpmyadmin un peu trop connu
# Mais http://phpmyadmin.example.org !
# Pensez donc a faire une redirection dans votre zone DNS
# De type A phpmyadmin.example.org qui pointe sur l'IP de votre serveur !

echo "##### Pour plus de securite, on ne va pas utiliser l'habituel http://example.org/phpmyadmin"
echo "##### Car un peu trop connu, mais http://phpmyadmin.example.org"
echo "##### Pensez a faire une redirection de type A dans votre zone DNS"
echo "##### Pour créer le sous-domaine correspondant pointant vers l'IP de votre serveur"

echo -n "##### Quel sous-domaine voulez vous utiliser pour acceder à phpmyadmin? : "
read subdomain
echo -n "##### Quel est votre nom de domaine a associer avec ce sous-domaine (format example.org)? : "
read domain
echo "##### Pour sécuriser un peu plus l'acces a cette page, il faudra s'identifier."
echo -n "##### Quel mot de passe voulez vous associer a l'utilisateur Admin? : "
read password
# On aura besoin d'apache2-utils pour la commande htpasswd
apt-get install -y apache2-utils
# On cree le fichier d’authentification
mkdir /etc/nginx/htpasswd
htpasswd -cb /etc/nginx/htpasswd/phpmyadmin Admin $password
# On créé notre propre fichier de configuration
echo "server {" >> /etc/nginx/sites-available/$subdomain.$domain
echo "listen 80;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "server_name $subdomain.$domain;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "access_log /var/log/nginx/$subdomain.$domain.access_log;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "error_log /var/log/nginx/$subdomain.$domain.error_log;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "root /usr/share/phpmyadmin/;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "#Après index, mettez la page par defaut à charger" >> /etc/nginx/sites-available/$subdomain.$domain
echo "index index.php;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "location / {" >> /etc/nginx/sites-available/$subdomain.$domain
echo "auth_basic \"Login\";" >> /etc/nginx/sites-available/$subdomain.$domain
echo "auth_basic_user_file /etc/nginx/htpasswd/phpmyadmin;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "try_files \$uri \$uri/ /index.php?\$args;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "}" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "location ~* /(images|logs|tmp)/.*\.(php|pl|py|jsp|asp|sh|cgi)$ {" >> /etc/nginx/sites-available/$subdomain.$domain
echo "return 403;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "error_page 403 /403_error.html;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "}" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "location ~ \.php$ {" >> /etc/nginx/sites-available/$subdomain.$domain
echo "fastcgi_pass 127.0.0.1:9000;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "fastcgi_index index.php;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "include /etc/nginx/fastcgi_params;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "}" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "location ~* \.(js|css|png|jpg|jpeg|gif|ico|pdf|flv|swf|xml|txt)$ {" >> /etc/nginx/sites-available/$subdomain.$domain
echo "expires max;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "log_not_found off;" >> /etc/nginx/sites-available/$subdomain.$domain
echo "}" >> /etc/nginx/sites-available/$subdomain.$domain
echo "" >> /etc/nginx/sites-available/$subdomain.$domain
echo "}" >> /etc/nginx/sites-available/$subdomain.$domain
echo "##### Fichier de configuration créé dans /etc/nginx/sites-available/$subdomain.$domain"
ln -s /etc/nginx/sites-available/$subdomain.$domain /etc/nginx/sites-enabled/$subdomain.$domain
echo "##### Lien symbolique créé vers /etc/nginx/sites-enabled/$subdomain.$domain"
echo "##### Vous pouvez désactiver ce sous-domaine en enlevant le lien symbolique de /etc/nginx/sites-enabled/"
echo "##### et le réactiver en remettant le lien symbolique."

# On redémarre le service pour que tout soit pris en compte
service nginx restart
