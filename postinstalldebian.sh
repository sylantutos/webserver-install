#On change le password root
passwd root

#On ajoute un utilisateur
useradd -G root -s /bin/bash -d /home/sylan -m sylan
passwd sylan
adduser sylan adm

#On va mettre à jour le serveur
#Et on ajoute les sources du projet DotDeb pour avoir les derniers patchs de sécurité
echo "deb http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
wget http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | sudo apt-key add -
#Et on met à jour
apt-get update
apt-get upgrade -y

#On installe bash-completion
apt-get install -y bash-completion
#On modifie le .bashrc de root pour en profiter, c'est automatique pour les autres users
echo "if [ -f /etc/bash_completion ]; then" >> /root/.bashrc
echo ". /etc/bash_completion" >> /root/.bashrc
echo "fi" >> /root/.bashrc

#On ajoute des alias pour ls et les couleurs auto dans le .bashrc de root
echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc
echo "alias ls='ls $LS_OPTIONS -h'" >> /root/.bashrc
echo "alias ll='ls $LS_OPTIONS -lah'" >> /root/.bashrc
echo "alias l='ls $LS_OPTIONS -lAh'" >> /root/.bashrc
#Et de tous les autres utilisateurs
echo "export LS_OPTIONS='--color=auto'" >> /etc/bash.bashrc
echo "alias ls='ls $LS_OPTIONS -h'" >> /etc/bash.bashrc
echo "alias ll='ls $LS_OPTIONS -lah'" >> /etc/bash.bashrc
echo "alias l='ls $LS_OPTIONS -lAh'" >> /etc/bash.bashrc

#On installe sudo
apt-get install -y sudo
#Et on le configure pour autoriser les membres du groupe root à pouvoir utiliser sudo
echo "%root ALL=(ALL) PASSWD: ALL" >> /etc/sudoers
#Et petit bonus avec des étoiles lors d'une demande de mot de passe
sed -i 's|env_reset|env_reset,pwfeedback|' /etc/sudoers

#Sécurisons un peu ssh avec remplacement du port et interdiction de se connecter en root 
#Il faudra utiliser notre nouvel utilisateur
sed -i 's|Port 22|Port 1337|' /etc/ssh/sshd_config
sed -i 's|PermitRootLogin yes|PermitRootLogin no|' /etc/ssh/sshd_config
/etc/init.d/ssh restart

#On sécurise le serveur avec iptables
cd /etc/init.d/
wget --no-check-certificate https://raw.githubusercontent.com/sylantutos/webserver-install/master/moniptables.sh
chmod +x moniptables.sh
service moniptables.sh start
update-rc.d moniptables.sh defaults
cd

#On install MOTDstat
apt-get install -y make
wget http://www.gelogic.net/wp-content/uploads/2013/02/MOTDstat-0.0.3.tar.gz
tar xzf MOTDstat-0.0.3.tar.gz
cd MOTDstat-0.0.3
make install
motdstat --generate
echo "nginx" >> /etc/motdstat/process
echo "php5-fpm" >> /etc/motdstat/process
echo "mysqld" >> /etc/motdstat/process
#On mets à jour le Message Of The Day toutes les 5mn
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/motdstat --generate") | crontab -
#Et on configure tout ça
echo "/                               80      90" >> /etc/motdstat/fstab_limits
echo "/var                               80      90" >> /etc/motdstat/fstab_limits


#Let's fun
rm /etc/motd.orig
echo " ____        _               ____                           " >> /etc/motd.orig
echo "/ ___| _   _| | __ _ _ __   / ___|  ___ _ ____   _____ _ __ " >> /etc/motd.orig
echo "\___ \| | | | |/ _\` | '_ \  \___ \ / _ \ '__\ \ / / _ \ '__|" >> /etc/motd.orig
echo " ___) | |_| | | (_| | | | |  ___) |  __/ |   \ V /  __/ |   " >> /etc/motd.orig
echo "|____/ \__, |_|\__,_|_| |_| |____/ \___|_|    \_/ \___|_|   " >> /etc/motd.orig
echo "       |___/                                                " >> /etc/motd.orig
