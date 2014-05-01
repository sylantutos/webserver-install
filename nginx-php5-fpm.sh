#!/bin/sh

# On va commencer par supprimer apache et tous ses composants
apt-get purge -y apache2*

# On installe nginx (prononcez EngineX)
apt-get install -y nginx
service nginx restart

# On installe php5-fpm
apt-get install -y php5-fpm
# On configure le listen sur le port 9000
sed -i 's|listen = /var/run/php5-fpm.sock|listen = 127.0.0.1:9000|' /etc/php5/fpm/pool.d/www.conf

# On supprime la configuration par défaut
rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default

# On demande le nom du site
echo -n "Quel est le nom de votre site web? (sous la forme example.org) : "
read SITE
# On créé notre propre fichier de configuration
echo "server {" >> /etc/nginx/sites-available/$SITE
echo "listen 80;" >> /etc/nginx/sites-available/$SITE
echo "server_name www.$SITE;" >> /etc/nginx/sites-available/$SITE
echo "rewrite ^/(.*) http://$SITE/\$1 permanent;" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "server {" >> /etc/nginx/sites-available/$SITE
echo "listen 80;" >> /etc/nginx/sites-available/$SITE
echo "server_name $SITE;" >> /etc/nginx/sites-available/$SITE
echo "access_log /var/log/nginx/$SITE.access_log;" >> /etc/nginx/sites-available/$SITE
echo "error_log /var/log/nginx/$SITE.error_log;" >> /etc/nginx/sites-available/$SITE
echo "root /var/www/$SITE;" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "#Après index, mettez la page par defaut à charger" >> /etc/nginx/sites-available/$SITE
echo "index index.php;" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "location / {" >> /etc/nginx/sites-available/$SITE
echo "try_files \$uri \$uri/ /index.php?\$args;" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "location ~* /(images|logs|tmp)/.*\.(php|pl|py|jsp|asp|sh|cgi)$ {" >> /etc/nginx/sites-available/$SITE
echo "return 403;" >> /etc/nginx/sites-available/$SITE
echo "error_page 403 /403_error.html;" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "location ~ \.php$ {" >> /etc/nginx/sites-available/$SITE
echo "fastcgi_pass 127.0.0.1:9000;" >> /etc/nginx/sites-available/$SITE
echo "fastcgi_index index.php;" >> /etc/nginx/sites-available/$SITE
echo "fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/sites-available/$SITE
echo "include /etc/nginx/fastcgi_params;" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "location ~* \.(js|css|png|jpg|jpeg|gif|ico|pdf|flv|swf|xml|txt)$ {" >> /etc/nginx/sites-available/$SITE
echo "expires max;" >> /etc/nginx/sites-available/$SITE
echo "log_not_found off;" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "" >> /etc/nginx/sites-available/$SITE
echo "}" >> /etc/nginx/sites-available/$SITE
echo "Fichier de configuration créé dans /etc/nginx/sites-available/$SITE"
ln -s /etc/nginx/sites-available/$SITE /etc/nginx/sites-enabled/$SITE
echo "Lien symbolique créé vers /etc/nginx/sites-enabled/$SITE"
echo "Vous pouvez désactiver votre site en enlevant le lien symbolique de /etc/nginx/sites-enabled/"
echo "et le réactiver en remettant le lien symbolique."
mkdir -p /var/www/$SITE
echo "<?php" >> /var/www/$SITE/index.php
echo "phpinfo();" >> /var/www/$SITE/index.php
echo "?>" >> /var/www/$SITE/index.php
# On met les droits sur le dossier
chown -R www-data:www-data /var/www/$SITE

# On redemarre le serveur nginx et php5-fpm
service php5-fpm restart
service nginx restart

echo "Vous pouvez mettre les fichiers de votre site dans /var/www/$SITE ."
echo "Nous avons créé un fichier index.php dans votre dossier /var/www/$SITE"
echo "Vous pouvez vérifier que tout fonctionne en vous rendant sur http://$SITE"
echo "Vous devriez voir apparaitre le resultat de phpinfo()"
