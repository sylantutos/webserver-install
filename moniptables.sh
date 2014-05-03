#!/bin/sh

### BEGIN INIT INFO
# Provides: Règles iptables
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Règles iptables lestutosdesylan.com
### END INIT INFO

# Mise à 0 des règles
iptables -t filter -F
iptables -t filter -X
echo "Mise à 0 des règles - Check"

# On bloque tout par défaut
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
echo "Tout bloqué par défaut - Check"

# On garde les connexions déjà établies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# On autorise localhost 127.0.0.1
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo "Localhost - Check"

# On désactive l'ipv6 (peu d'intérêt d'y passer)
echo '1' > /proc/sys/net/ipv6/conf/lo/disable_ipv6   
echo '1' > /proc/sys/net/ipv6/conf/all/disable_ipv6   
echo '1' > /proc/sys/net/ipv6/conf/default/disable_ipv6
echo "IPV6 - Check"

# On autorise la réponse aux ping (ICMP)
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo "Ping - Check"

# On autorise les accès SSH (entrant/sortant)
iptables -t filter -A INPUT -p tcp --dport 1337 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 1337 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 1337 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 1337 -j ACCEPT
echo "SSH - Check"

# On autorise le DNS
iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo "DNS - Check"

# On autorise le NTP
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
echo "NTP - check"

# On autorise les connexions HTTP et HTTPS entrantes
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT

# On autorise les connexions HTTP et HTTPS sortantes
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 8443 -j ACCEPT
echo "http(s) - Check"

# On autorise les accès FTP
iptables -t filter -A OUTPUT -p tcp --dport 2121 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 2121 -j ACCEPT
iptables -t filter -A INPUT -m state --state NEW -p tcp --dport 63990:64000 -j ACCEPT
echo "FTP - Check"

# On autorise les services mails (SMTP)
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
echo "SMTP - Check"

# On autorise les services mails (POP3)
iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
echo "POP3 - Check"

# On autorise les services mail (IMAP)
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
echo "IMAP - Check"

# On autorise les services mail (POP3S)
iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
echo "POP3S - Check"

echo "  + ======================== SCRIPT TERMINE! =================="
echo "  + Afficher la configuration de la table : 'iptables -L -n -v'"
echo "  + ==========================================================="
