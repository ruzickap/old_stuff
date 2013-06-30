#!/bin/bash

(
set -x

HOST_FILES=http://192.168.122.1/~ruzickap/my

#eth0 00:10:18:30:bd:66 - Tigon3 tg3 - NetXtreme BCM5751 Gigabit Ethernet PCI Express
LOCALNET_INTERFACE="eth0"
LOCALNET_INTERFACE_IP="192.168.0.0/24"
#eth1 00:10:5a:5b:ba:3c - 3c905B 100BaseTX [Cyclone] - 3Com Corporation
WIFI_INTERFACE="eth1"
WIFI_INTERFACE_IP=192.168.1.0/25
WIFI_INTERFACE_IP2="192.168.1.128/25"
# eth2 00:1f:c6:e9:f5:14 - forcedeth - NVIDIA Corporation
LOCALNET_INTERFACE_TV="eth2"
LOCALNET_INTERFACE_TV_IP="192.168.2.0/24"
# eth3 00:13:71:0d:94:89 - cdc_ether - USB Cable Modem - Broadcom Corporation - 0013710D9489
INTERNET_INTERFACE="eth3"

MYSQL_DBPASS="xxxx"
RUZICKAP_PASSWORD="xxxx"
TRANSMISSION_PASSWORD="xxxx"
TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS="admin@xvx.cz"

#CA_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
CA_PASSWORD="xxxxx"
VSFTPD_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
APACHE2_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})

WORDPRESS_WORDPRESS_XVX_CZ_ADMIN_PASSWORD="xxxx"
WORDPRESS_WORDPRESS_XVX_CZ_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
WORDPRESS_WORDPRESS_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

WORDPRESS_LINUX_XVX_CZ_ADMIN_PASSWORD="xxxx"
WORDPRESS_LINUX_XVX_CZ_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
WORDPRESS_LINUX_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

WORDPRESS_SVATBA_XVX_CZ_ADMIN_PASSWORD="xxxx"
WORDPRESS_SVATBA_XVX_CZ_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
WORDPRESS_SVATBA_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

WORDPRESS_CESTOVANI_XVX_CZ_ADMIN_PASSWORD="xxxx"
WORDPRESS_CESTOVANI_XVX_CZ_PRIVATE_KEY_PASSWORD=$(< /dev/urandom tr -dc [:alnum:] | head -c${1:-32})
WORDPRESS_CESTOVANI_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

FTP_XVX_CZ_PASSWORD="xxxx"
FTP_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
FTP_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS
FEDORA_XVX_CZ_PASSWORD="xxxx"
FEDORA_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
FEDORA_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS
DEBIAN_XVX_CZ_PASSWORD="xxxx"
DEBIAN_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
DEBIAN_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS
RUZICKOVABOZENA_XVX_CZ_PASSWORD="xxxx"
RUZICKOVABOZENA_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
RUZICKOVABOZENA_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

#Default password for user ruzicka for wikis a.xvx.cz, rh.xvx.cz, att.xvx.cz
MOIN_RUZICKAP_PASSWORD_FOR_PRIVATE_WIKIS="xxxx"

MOIN_MOIN_XVX_CZ_ADMIN_PASSWORD="xxxx"
MOIN_MOIN_XVX_CZ_USER_PASSWORD=$MOIN_MOIN_XVX_CZ_ADMIN_PASSWORD
MOIN_MOIN_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
MOIN_MOIN_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

MOIN_A_XVX_CZ_ADMIN_PASSWORD="xxxx"
MOIN_A_XVX_CZ_USER_PASSWORD=$MOIN_A_XVX_CZ_ADMIN_PASSWORD
MOIN_A_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
MOIN_A_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

MOIN_RH_XVX_CZ_ADMIN_PASSWORD="xxxx"
MOIN_RH_XVX_CZ_USER_PASSWORD=$MOIN_RH_XVX_CZ_ADMIN_PASSWORD
MOIN_RH_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
MOIN_RH_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

MOIN_ATT_XVX_CZ_ADMIN_PASSWORD="xxxx"
MOIN_ATT_XVX_CZ_USER_PASSWORD=$MOIN_ATT_XVX_CZ_ADMIN_PASSWORD
MOIN_ATT_XVX_CZ_PRIVATE_KEY_PASSWORD="xxxx"
MOIN_ATT_XVX_CZ_EMAIL=$TEMPORARY_NOTIFICATION_EMAIL_FOR_ALL_WEBS

MUNIN_MYSQL_USER_PLUGIN_PASSWORD="xxxx"

debconf-set-selections << EOF
  mysql-server-5.5 mysql-server/root_password password $MYSQL_DBPASS
  mysql-server-5.5 mysql-server/root_password_again password $MYSQL_DBPASS
  phpmyadmin phpmyadmin/app-password-confirm password
  phpmyadmin phpmyadmin/dbconfig-install boolean true
  phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_DBPASS
  phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_DBPASS
  phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2
  localepurge localepurge/nopurge multiselect en, en_US.UTF-8
  postfix postfix/main_mailer_type select Internet Site
  postfix postfix/mailname string gate.xvx.cz
  postfix postfix/root_address string ruzickap
  postfix postfix/destinations string gate.xvx.cz, gate, localhost.localdomain, localhost
  quota quota/mailfrom string root@gate.xvx.cz
  quota quota/subject string Over quota
  quota quota/signature string See you!|                     Your admin|
  quota quota/run_warnquota boolean true
  quota quota/cc string root@gate.xvx.cz
  quota quota/supportemail string root@gate.xvx.cz
  quota quota/message string Hello user of %i, I've noticed you use too much space on the disk.|Please delete your files...|
EOF

export DEBIAN_FRONTEND=noninteractive

aptitude update
aptitude upgrade -y

aptitude install -y --quiet apticron apt-listchanges awstats bash-completion bind9 bzip2 dnsmasq dnsutils fail2ban file less lftp libapache2-mod-evasive libapache2-mod-macro lm-sensors localepurge logwatch \
lsof nfs-kernel-server nmap noshell ntp mc munin munin-node munin-plugins-extra mutt mysql-server phpmyadmin postfix python-moinmoin quota quotatool \
rdiff-backup rpcbind rsync screen shorewall smartmontools ssl-cert-check sudo sysstat tcpdump telnet tmpreaper transmission-daemon unattended-upgrades unzip vsftpd wordpress-l10n


#############################
# networking + dnsmasq + dhclient
#############################
wget --no-verbose --no-proxy $HOST_FILES/files/my-dnsmasq.conf -P /etc/dnsmasq.d/
mkdir /srv/tftp
wget --no-verbose -P /srv/tftp/ http://static.netboot.me/gpxe/netbootme.kpxe
mkdir /root/bin
cat > /root/bin/dnsmasq-script.sh << \EOF 
#!/bin/sh

/bin/echo `/bin/date +"%F %T"` $* >> /var/log/dnsmasq.script.log

if [ "$1" == "add" ] && ! grep -iq $2 /etc/dnsmasq.d/my-dnsmasq.conf; then
  mail -s "New MAC on $HOSTNAME" root << EOF2
`/bin/date +"%F %T"` $*
EOF2
fi
EOF
chmod a+x /root/bin/dnsmasq-script.sh

sed -i 's/.*eth.*/#&/' /etc/network/interfaces
cat >> /etc/network/interfaces << EOF

#TV [Tigon3]
auto $LOCALNET_INTERFACE
iface $LOCALNET_INTERFACE inet static
    address 192.168.0.1
    netmask 255.255.255.0

#Wifi (private) [3Com]
auto $WIFI_INTERFACE
iface $WIFI_INTERFACE inet static
    address 192.168.1.1
    netmask 255.255.255.128

#Wifi (external)
auto ${WIFI_INTERFACE}.2
iface ${WIFI_INTERFACE}.2 inet static
    address 192.168.1.129
    netmask 255.255.255.128

#Onboard Gigabit NIC [Nvidia]
auto $LOCALNET_INTERFACE_TV
iface $LOCALNET_INTERFACE_TV inet static
    address 192.168.2.1
    netmask 255.255.255.0

#USB modem
auto $INTERNET_INTERFACE
iface $INTERNET_INTERFACE inet dhcp
EOF

sed -i 's/^#prepend \(domain-name-servers 127.0.0.1;\).*/supersede \1/;s/^#\(supersede domain-name\).*/\1 "xvx.cz";/' /etc/dhcp/dhclient.conf


#############################
# rcS + defaults + rsyslog + sysctl + lftp + motd + sysstat + my account + bash_completition
#############################
sed -i.orig 's/^TMPTIME=.*/TMPTIME=7/;s/^FSCKFIX=no/FSCKFIX=yes/' /etc/default/rcS

cat >> /etc/default/smartmontools << EOF
enable_smart="/dev/sda /dev/sdb /dev/sdc"
start_smartd=yes
EOF

echo -e "\n:msg, contains, \"DHCPREQUEST on $INTERNET_INTERFACE to 0.0.0.0 port 67\"	~\n" >> /etc/rsyslog.d/filter.conf

cat >> /etc/sysctl.d/local.conf << EOF
kernel.panic = 10
dev.raid.speed_limit_min=30000
dev.raid.speed_limit_max=35000
EOF

sed -i.orig 's/exit 0//' /etc/rc.local

cat >> /etc/rc.local << EOF
echo -n "Restart: \`hostname -f\` (\`ifconfig $INTERNET_INTERFACE | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}'\`)\n\n\`date\`\n\n\`uptime\`\n\n\`uname -a\`\n\n" | mail -s "Server restart: `hostname -f`" petr.ruzicka@gmail.com
exit 0
EOF

sed -i.orig 's/^#\(set prompt\)/\1/' /etc/lftp.conf

cat > /etc/motd.tail << EOF
[1;34m
  ___   ___ ____    ____ ___   ___
  \  \ /  / \   \  /   / \  \ /  /
   \  V  /   \   \/   /   \  V  /  [0;31m       ___  ____  [1;34m
    >   <     \      /     >   <   [0;31m      / __)(__  ) [1;34m
   /  .  \     \    /     /  .  \  [0;31m  _  ( (__  / _/  [1;34m
  /__/ \__\     \__/     /__/ \__\ [0;31m (_)  \___)(____) [1;34m

[0m
EOF

sed -i.orig 's/^ENABLED.*/ENABLED="true"/' /etc/default/sysstat

PASS=$(perl -e 'print crypt($ARGV[0], "password")' "$RUZICKAP_PASSWORD")
useradd --comment "Petr Ruzicka" --create-home --password $PASS --shell /bin/bash --groups cdrom,audio,video,plugdev,sudo ruzickap

mkdir /home/ruzickap/bin
chown -R ruzickap:ruzickap /home/ruzickap/bin
echo "PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '" >> /home/ruzickap/.bashrc
echo "PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '" >> /root/.bashrc
sed -i -e '/-f.*bash_completion/,/fi/s/^#//' /etc/bash.bashrc
echo "alias sar='LANG=C sar'" >> /etc/bashrc

sed -i.orig 's/^set compatible/set nocompatible/' /etc/vim/vimrc.tiny

sed -i.orig "s@/home\s*ext4\s*defaults@&,errors=remount-ro,nosuid,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0@" /etc/fstab
mount -o remount /home
quotacheck -vagum
quotaon -avug

cat > /etc/cron.weekly/repquota << EOF
repquota -a -s -t
EOF

setquota --edit-period 1 1 --all
sed -i 's@/usr/sbin/warnquota@& --human-readable #--no-details@' /etc/cron.daily/quota

cat >> /etc/screenrc << EOF

defscrollback 10000

startup_message off

termcapinfo xterm ti@:te@
# From http://www4.informatik.uni-erlangen.de/~jnweiger/screen-faq.html
# Q: My xterm scrollbar does not work with screen.
# A: The problem is that xterm will not allow scrolling if the alternate text buffer is selected. The standard definitions of the termcap initialize capabilities ti and te switch to and from the alternat

hardstatus alwayslastline '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %d/%m %{W}%c %{g}]'

vbell off
EOF

sed -i.orig 's/# set bell-style none/set bell-style none/' /etc/inputrc

#############################
# openssl / certificate authority
#############################
sed 's/365/3650/;s@\./demoCA@/etc/ssl/CA@;s/AU/CZ/;s/Some-State/Czech Republic/;s/Internet Widgits Pty Ltd/xvx.cz/;s/^#\(organizationalUnitName_default\).*/\1\t= XVX.CZ/;s/^\(crl.*\)crl.pem/\1my-ca.crl/;s/^\(private_key.*\)cakey.pem/\1myca.key/;s/^\(certificate.*\)cacert.pem/\1my-ca.crt/;s/^# \(req_extensions.*\)/\1/;s/^# \(copy_extensions.*\)/\1/;/^commonName_max/a commonName_default\t\t= www.xvx.cz;' /etc/ssl/openssl.cnf > /etc/ssl/openssl-my.cnf
sed -i '/^localityName\t\t\t= Locality Name/a localityName_default\t\t= Brno' /etc/ssl/openssl-my.cnf
sed -i '/^emailAddress_max/a emailAddress_default\t\t= petr.ruzicka@xvx.cz' /etc/ssl/openssl-my.cnf
sed -i '/^\[ v3_req \]/a subjectAltName = $ENV::SUBJECTALTNAME' /etc/ssl/openssl-my.cnf

rm /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/certs/*

mkdir -p /etc/ssl/CA/{private,certs,newcerts,crl}
chmod -R 700 /etc/ssl/CA
touch /etc/ssl/CA/index.txt
echo 00 > /etc/ssl/CA/serial
echo 00 > /etc/ssl/CA/crlnumber


(
  umask 077
  openssl genrsa -des3 -passout pass:${CA_PASSWORD} -out /etc/ssl/CA/private/myca.key 2048
)

SUBJ="
C=CZ
ST=Czech Republic
O=xvx.cz
OU=XVX.CZ
L=Brno
CN=www.xvx.cz
emailAddress=root@xvx.cz
"
SUBJECTALTNAME="DNS:*.xvx.cz" openssl req -config /etc/ssl/openssl-my.cnf -passin pass:${CA_PASSWORD} -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -new -x509 -key /etc/ssl/CA/private/myca.key -days 3650 -out /etc/ssl/CA/my-ca.crt
openssl x509 -noout -text -in /etc/ssl/CA/my-ca.crt > /etc/ssl/CA/my-ca.crt.text
cp /etc/ssl/CA/my-ca.crt /var/www/
cp /etc/ssl/CA/my-ca.crt /etc/ssl/certs/
cp /etc/ssl/CA/private/myca.key /etc/ssl/private/


#############################
# fremebuffer + grub parameters
#############################
sed -i.orig 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/;s/^\(GRUB_CMDLINE_LINUX_DEFAULT\)=.*/\1=""/' /etc/default/grub
sed -i '/set gfxmode=${GRUB_GFXMODE}/a\
\ \ set gfxpayload=keep' /etc/grub.d/00_header
cat >> /etc/default/grub << EOF
GRUB_GFXMODE=1600x1200
EOF
update-grub2
# install grub to both raid disks
grub-install /dev/sdb
e2label /dev/md0 boot
e2label /dev/mapper/vg00-root root
e2label /dev/mapper/vg00-tmp tmp
e2label /dev/mapper/vg00-var var
e2label /dev/mapper/vg00-usr usr
e2label /dev/mapper/vg00-home home
e2label /dev/sdb3 data


#############################
# Console
#############################
sed -i.orig 's/^BLANK_DPMS=.*/BLANK_DPMS=on/;s/=30$/=10/;s/^#\(LEDS=+num\)/\1/' /etc/kbd/config


#############################
# Midnight Commander
#############################
mkdir -p /etc/skel/.config/mc/
chmod 700 /etc/skel/.config/mc /etc/skel/.config
cat > /etc/skel/.config/mc/ini << EOF
[Midnight-Commander]
auto_save_setup=0
drop_menus=1
use_internal_edit=1
confirm_exit=0

[Layout]
menubar_visible=0
message_visible=0
EOF
cp -r /etc/skel/.config /root/

test -f /usr/share/mc/bin/mc-wrapper.sh && \
cat > /etc/profile.d/mc-wrapper.sh << EOF
# Midnight Commander chdir enhancement"
if [ -f /usr/share/mc/bin/mc-wrapper.sh ]; then alias mc='. /usr/share/mc/bin/mc-wrapper.sh --nomouse'
fi
EOF

update-alternatives --quiet --set editor /usr/bin/mcedit


#############################
# munin
#############################
sed -i.orig 's@localhost 127.0.0.0/8 ::1@all@;s@ /munin-cgi@ /myadmin/munin-cgi@;s@^#\(Alias /myadmin/munin-cgi/static.*\)@\1@;s/^ScriptAlias.*/#&/;s@^#\(ScriptAlias /myadmin/munin-cgi .*\)@\1@;/^ScriptAlias \/myadmin\/munin-cgi /i ScriptAlias /myadmin/munin-cgi/munin-cgi-graph /usr/lib/munin/cgi/munin-cgi-graph' /etc/munin/apache.conf

sed -i.orig '/^#graph_strategy/a graph_strategy cgi' /etc/munin/munin.conf
sed -i '/^#html_strategy/a html_strategy cgi' /etc/munin/munin.conf
sed -i '/^#cgiurl_graph/a cgiurl_graph /myadmin/munin-cgi/munin-cgi-graph' /etc/munin/munin.conf

sed -i.orig '/use_node_name yes/a \
\ \ \ \ df._dev_sda1.warning 90\
\ \ \ \ df._dev_sda1.critical 95\
\ \ \ \ df._dev_sdb1.warning 97\
\ \ \ \ df._dev_sdb1.critical 99\
\ \ \ \ df._dev_mapper_gate_home.warning 90\
\ \ \ \ df._dev_mapper_gate_home.critical 95\
\ \ \ \ df._dev_mapper_gate_root.warning 90\
\ \ \ \ df._dev_mapper_gate_root.critical 95\
\ \ \ \ df._dev_mapper_gate_tmp.warning 90\
\ \ \ \ df._dev_mapper_gate_tmp.critical 95\
\ \ \ \ df._dev_mapper_gate_usr.warning 90\
\ \ \ \ df._dev_mapper_gate_usr.critical 95\
\ \ \ \ df._dev_mapper_gate_var.warning 90\
\ \ \ \ df._dev_mapper_gate_var.critical 95\
' /etc/munin/munin.conf

cat >> /etc/munin/munin.conf << EOF
contact.me.command mail -s "Munin notification \${var:host} [\${var:graph_category}] \${var:graph_title} [\${var:label}] [\${var:value}] [\${var:extinfo}]" root
EOF

sed -i 's/daily/weekly/' /etc/logrotate.d/munin /etc/logrotate.d/rsyslog

aptitude install -y --quiet libwww-perl
ln -s /usr/share/munin/plugins/apache_accesses /etc/munin/plugins/
ln -s /usr/share/munin/plugins/apache_processes /etc/munin/plugins/
ln -s /usr/share/munin/plugins/apache_volume /etc/munin/plugins/
cat > /etc/munin/plugin-conf.d/apache << EOF
[apache_*]
env.url   http://127.0.0.1:%d/server-status?auto
env.ports 80
env.showfree 1
EOF

ln -s /usr/share/munin/plugins/buddyinfo /etc/munin/plugins/buddyinfo

ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_latency_sda
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_throughput_sda
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_iops_sda

ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_latency_sdb
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_throughput_sdb
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_iops_sdb

ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_latency_sdc
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_throughput_sdc
ln -s /usr/share/munin/plugins/diskstat_ /etc/munin/plugins/diskstat_iops_sdc

ln -s /usr/share/munin/plugins/multips_memory /etc/munin/plugins/multips_memory_rss
ln -s /usr/share/munin/plugins/multips_memory /etc/munin/plugins/multips_memory_vsize
cat > /etc/munin/plugin-conf.d/multips_memory << EOF
[multips_memory*]
env.names apache2 mysqld named

[multips_memory_rss]
env.monitor rss

[multips_memory_vsize]
env.monitor vsize
EOF

cat > /etc/munin/plugin-conf.d/diskstat << EOF
[diskstat_*]
user root
EOF

ln -s /usr/share/munin/plugins/fw_conntrack /etc/munin/plugins/
ln -s /usr/share/munin/plugins/fw_forwarded_local /etc/munin/plugins/
cat > /etc/munin/plugin-conf.d/fw << EOF
[fw_*]
user root
EOF

cat > /etc/munin/plugin-conf.d/fail2ban << EOF
[fail2ban]
user root
EOF

cat > /etc/munin/plugin-conf.d/hddtemp << EOF
[hddtemp*]
env.drives sda sdb sdc
EOF

ln -s /usr/share/munin/plugins/iostat* /etc/munin/plugins/
ln -s /usr/share/munin/plugins/meminfo /etc/munin/plugins/meminfo

ln -s /usr/share/munin/plugins/mysql_* /etc/munin/plugins/
rm /etc/munin/plugins/mysql_isam_space_
rm /etc/munin/plugins/mysql_
rm /etc/munin/plugins/mysql_innodb

mysql --defaults-file=/etc/mysql/debian.cnf << EOF
CREATE USER 'munin'@'localhost' IDENTIFIED BY '$MUNIN_MYSQL_USER_PLUGIN_PASSWORD';
GRANT SUPER ON *.* TO 'munin'@'localhost';
FLUSH PRIVILEGES;
EOF

cat > /etc/munin/plugin-conf.d/mysql << EOF
[mysql*]
user root
env.mysqlopts --defaults-file=/etc/mysql/debian.cnf
env.mysqluser munin
env.warning 0
env.critical 0
EOF

ln -s /usr/share/munin/plugins/netstat* /etc/munin/plugins/

ln -s /usr/share/munin/plugins/port_ /etc/munin/plugins/port_80
ln -s /usr/share/munin/plugins/port_ /etc/munin/plugins/port_443
ln -s /usr/share/munin/plugins/port_ /etc/munin/plugins/port_22
ln -s /usr/share/munin/plugins/ps_ /etc/munin/plugins/ps_apache2
ln -s /usr/share/munin/plugins/postfix_mailstats /etc/munin/plugins/
cat > /etc/munin/plugin-conf.d/postfix << EOF
[postfix*]
env.logdir /var/log
env.logfile mail.log
EOF

ln -s /usr/share/munin/plugins/ping_ /etc/munin/plugins/ping_www.google.cz

ln -s /usr/share/munin/plugins/tcp /etc/munin/plugins/

cat > /etc/munin/plugin-conf.d/hddtemp_smartctl << EOF
[hddtemp_smartctl]
user root
EOF

cat > /etc/munin/plugin-conf.d/bind << EOF
[bind*]
user root
env.querystats      /var/cache/bind/named.stats
env.logfile         /var/log/named/queries.log
EOF

ln -s /usr/share/munin/plugins/bind9* /etc/munin/plugins/
touch /var/cache/bind/named.stats
chown bind:bind /var/cache/bind/named.stats

ln -s /usr/share/munin/plugins/vlan_ /etc/munin/plugins/vlan_${WIFI_INTERFACE}_2


#############################
# tmpreaper
#############################
sed -i.orig 's/SHOWWARNING=.*/SHOWWARNING=false/' /etc/tmpreaper.conf


#############################
# SSHd + noshell
#############################
# change "yes" to "without-password"
sed -i.orig 's/^PermitRootLogin.*/PermitRootLogin yes/;s/^Port 22/Port 2222/;s/^X11Forwarding yes/#&/' /etc/ssh/sshd_config
groupadd --system sites
cat >> /etc/ssh/sshd_config << EOF

UseDNS no
AddressFamily inet
ClientAliveInterval 30
ClientAliveCountMax 5

Match Group sites
        X11Forwarding no
        AllowAgentForwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp
        ChrootDirectory %h
EOF
echo "/sbin/noshell" >> /etc/shells


#############################
# Cron auto upgrades: unattended-upgrades + apticron + apt + cron
#############################
sed -i '/Unattended-Upgrade::Origins-Pattern/ a\
\ \ \ \ \ \ "o=Debian,a=stable";\
\ \ \ \ \ \ "o=Debian,a=stable-updates";\
\ \ \ \ \ \ "o=Debian,a=proposed-updates";'  /etc/apt/apt.conf.d/50unattended-upgrades

cat > /etc/apt/apt.conf.d/02periodic << \EOF
// Enable the update/upgrade script (0=disable)
APT::Periodic::Enable "1";

// Do "apt-get update" automatically every n-days (0=disable)
APT::Periodic::Update-Package-Lists "1";

// Do "apt-get upgrade --download-only" every n-days (0=disable)
APT::Periodic::Download-Upgradeable-Packages "1";

// Run the "unattended-upgrade" security upgrade script
// every n-days (0=disabled)
// Requires the package "unattended-upgrades" and will write
// a log in /var/log/unattended-upgrades
APT::Periodic::Unattended-Upgrade "1";

// Do "apt-get autoclean" every n-days (0=disable)
APT::Periodic::AutocleanInterval "7";
EOF

cp /etc/cron.daily/00logwatch /etc/cron.weekly/
sed -i 's@^/usr/sbin/logwatch --output mail@#&@' /etc/cron.daily/00logwatch

sed -i 's@^\([0-9][0-9]\) \*\(.*\)@\1 1\2@' /etc/cron.d/apticron

wget --no-proxy --no-verbose -P /etc/cron.monthly/ $HOST_FILES/files/configure_check

wget --no-proxy --no-verbose -P /root/bin/ $HOST_FILES/files/certificate_check 
chmod a+x /root/bin/certificate_check
cat > /etc/cron.weekly/certificate_check << EOF
#!/bin/bash

/root/bin/certificate_check
EOF
chmod a+x /etc/cron.weekly/certificate_check

sed -i.orig 's/6/2/' /etc/crontab


#############################
# vsftpd
#############################
# http://www.howtoforge.com/virtual-hosting-with-vsftpd-and-mysql-on-debian-squeeze
wget --no-proxy --no-verbose -P /etc/cron.hourly/ $HOST_FILES/files/ftp_file_upload_monitor
cat >> /etc/vsftpd.conf << EOF

anon_umask=077
anon_mkdir_write_enable=yes
anon_upload_enable=yes
dual_log_enable=YES
local_enable=yes
local_umask=022
#chown_uploads=yes
#chown_username=ftp
chroot_list_enable=yes
chroot_list_file=/etc/vsftpd.chroot_list
hide_ids=yes
local_enable=yes
passwd_chroot_enable=yes
# Turn on SSL
ssl_enable=yes
# All non-anonymous logins are forced to use a secure SSL connection in order to send the password.
force_local_logins_ssl=yes
# Permit TLS v1 protocol connections. TLS v1 connections are preferred
ssl_tlsv1=YES
# Permit SSL v2 protocol connections. TLS v1 connections are preferred
ssl_sslv2=NO
# permit SSL v3 protocol connections. TLS v1 connections are preferred
ssl_sslv3=NO
ssl_ciphers=HIGH
use_localtime=yes
write_enable=yes
#userlist_enable=yes
xferlog_enable=yes
require_ssl_reuse=no
EOF


mkdir /etc/ssl/vsftpd

SUBJ="
C=CZ
ST=Czech Republic
O=xvx.cz
OU=XVX.CZ
L=Brno
CN=ftp.xvx.cz
emailAddress=webmaster@xvx.cz
"

(
  umask 077;
## Create RSA private key
  openssl genrsa -passout pass:${VSFTPD_PRIVATE_KEY_PASSWORD} -des3 -out /etc/ssl/vsftpd/my-vsftpd.key 2048
  openssl rsa -passin pass:${VSFTPD_PRIVATE_KEY_PASSWORD} -in /etc/ssl/vsftpd/my-vsftpd.key -out /etc/ssl/vsftpd/my-vsftpd.key.decrypted
## Create Certificate Signing Request with the server RSA private key:
  SUBJECTALTNAME="DNS:xvx.cz, DNS:ftp.xvx.cz, DNS:*.xvx.cz" openssl req -config /etc/ssl/openssl-my.cnf -passin pass:${VSFTPD_PRIVATE_KEY_PASSWORD} -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -days 3650 -key /etc/ssl/vsftpd/my-vsftpd.key -out /etc/ssl/vsftpd/my-vsftpd.csr
  openssl req -text -in /etc/ssl/vsftpd/my-vsftpd.csr -out /etc/ssl/vsftpd/my-vsftpd.csr.text
## Use CA to sign the server's certificate
  SUBJECTALTNAME="DNS:xvx.cz, DNS:ftp.xvx.cz, DNS:*.xvx.cz" openssl ca -config /etc/ssl/openssl-my.cnf -passin pass:${CA_PASSWORD} -batch -in /etc/ssl/vsftpd/my-vsftpd.csr -out /etc/ssl/vsftpd/my-vsftpd.crt
  openssl x509 -text -in /etc/ssl/vsftpd/my-vsftpd.crt -out /etc/ssl/vsftpd/my-vsftpd.crt.text
)

cat /etc/ssl/vsftpd/my-vsftpd.key.decrypted > /etc/ssl/vsftpd/my-vsftpd.pem
echo "" >> /etc/ssl/vsftpd/my-vsftpd.pem
cat /etc/ssl/vsftpd/my-vsftpd.crt >> /etc/ssl/vsftpd/my-vsftpd.pem
chmod 600 /etc/ssl/vsftpd/my-vsftpd.pem
ln -s /etc/ssl/vsftpd/my-vsftpd.pem /etc/ssl/private/vsftpd.pem

mkdir /srv/ftp/{pub,incoming}
chmod 300 /srv/ftp/incoming
chown -R ftp:ftp /srv/ftp/*


#############################
# MySQL
#############################
sed -i 's/#log_slow_queries/log_slow_queries/g' /etc/mysql/my.cnf
sed -i 's/#long_query_time/long_query_time/g' /etc/mysql/my.cnf
cat > /etc/mysql/conf.d/my.cnf << EOF
[mysqld]
character-set-server=utf8
#Log all SQL queries
#log = /var/log/mysql/mysql.log
query_cache_size = 268435456
query_cache_type=1
query_cache_limit=1048576

[client]
default-character-set=utf8
EOF

mysql --password=$MYSQL_DBPASS --user=root << EOF
#Taken from /usr/bin/mysql_secure_installation
#Remove anonymous users
DELETE FROM mysql.user WHERE User='';
#Disallow remote root login
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
#Remove test database
DROP DATABASE test;
EOF


#############################
# sensors
#############################
cat >> /etc/modules << EOF
it87
k8temp
EOF
yes | sensors-detect > /dev/null


#############################
# Postfix
#############################
cat >> /etc/aliases << EOF
webmaster:	root
abuse:		root
info:		root
EOF
newaliases


#############################
# DNS / named / bind
#############################
sed -i 's/^};//' /etc/bind/named.conf.options
mkdir /var/log/named
chown bind:root /var/log/named
cat >> /etc/bind/named.conf.options << EOF
        coresize 0;
        allow-query { $LOCALNET_INTERFACE_IP; $WIFI_INTERFACE_IP; $WIFI_INTERFACE_IP2; $LOCALNET_INTERFACE_TV_IP; localhost; };
        allow-recursion { $LOCALNET_INTERFACE_IP; $WIFI_INTERFACE_IP; $WIFI_INTERFACE_IP2; $LOCALNET_INTERFACE_TV_IP; localhost; };
        allow-transfer { none; };
        version "Undisclosed";
        zone-statistics yes;
        statistics-file "/var/cache/bind/named.stats";
        max-ncache-ttl 0;
};

logging {
    channel default_debug {
            file "/var/log/named/named.run";
            severity dynamic;
    };


    channel security_file {
        file "/var/log/named/security.log" versions 1 size 100m;
        severity dynamic;
        print-time yes;
    };
    category security { security_file; };
    category update-security { security_file; };


    channel "querylog" {
        file "/var/log/named/queries.log" versions 2 size 10m;
    };
    category queries { querylog; };


    channel lame-servers_file {
        file "/var/log/named/lame-servers.log" versions 1 size 100m;
        severity dynamic;
        print-time yes;
    };
    category lame-servers { lame-servers_file; };


    channel dnssec_log {             // a DNSSEC log channel
        file "/var/log/named/dnssec.log" versions 1 size 100m;
        print-time yes;        // timestamp the entries
        print-category yes;    // add category name to entries
        print-severity yes;    // add severity level to entries
        severity debug 3;      // print debug message <= 3 t
    };
    category dnssec { dnssec_log; };
};

controls {
   inet 127.0.0.1 port 953 allow { 127.0.0.1; } keys { "rndc-key"; };
};

EOF

cat > /etc/bind/rndc.key << EOF
key "rndc-key" {
   algorithm hmac-md5;
   secret "cuE2XSpzfseSQ20Yg7L2Lw==";
};
EOF

cat /etc/bind/rndc.key >> /etc/bind/named.conf.options


#############################
# transmission
#############################
mkdir -p /home/data/torrents/{incomplete,downloads,watch}
sed -i.orig 's/^#\(START_STOP_OPTIONS.*\)/\1/' /etc/default/transmission-daemon
sed -i.orig "
s@blocklist-enabled\".*@blocklist-enabled\": true,@;
s@blocklist-url\".*@blocklist-url\": \"http://list.iblocklist.com/?list=bt_level1\&fileformat=p2p\&archiveformat=gz\",@;
s@download-dir\".*@download-dir\": \"/home/data/torrents/downloads/\",@;
s@incomplete-dir\".*@incomplete-dir\": \"/home/data/torrents/incomplete/\",@;
s@incomplete-dir-enabled\".*@incomplete-dir-enabled\": true,@;
s@speed-limit-down\".*@speed-limit-down\": 300,@;
s@speed-limit-down-enabled\".*@speed-limit-down-enabled\": true,@;
s@speed-limit-up\".*@speed-limit-up\": 50,@;
s@speed-limit-up-enabled\".*@speed-limit-up-enabled\": true,@;
s@trash-original-torrent-files\".*@trash-original-torrent-files\": true,@;
s@rpc-port\".*@rpc-port\": 9090@;
s@rpc-url\".*@rpc-url\": \"/mytransmission/\",@;
s@rpc-username\".*@rpc-username\": \"transmission-user\",@
s@rpc-password\".*@rpc-password\": \"$TRANSMISSION_PASSWORD\",@;
s@script-torrent-done-enabled\".*@script-torrent-done-enabled\": true,@
s@script-torrent-done-filename\".*@script-torrent-done-filename\": \"/home/ruzickap/bin/torrent_done.sh\",@
/^}/i \
\ \ \ \ \"watch-dir-enabled\": true,\
\ \ \ \ \"watch-dir\": \"/home/data/torrents/watch/\",\
" /etc/transmission-daemon/settings.json

cat > /home/ruzickap/bin/torrent_done.sh << \EOF2
#/bin/bash

#Remove torrent after finishing it: https://gist.github.com/791609
cat << EOF | mail petr.ruzicka@gmail.com
Subject: Torrent done: $TR_TORRENT_NAME

Hello from transmission $TR_APP_VERSION at $(hostname). The following torrent
has completed:

Name: $TR_TORRENT_NAME
Finished at: $TR_TIME_LOCALTIME
Downloaded to: $TR_TORRENT_DIR
Hash: $TR_TORRENT_HASH

Enjoy!
EOF
EOF2

chmod a+x /home/ruzickap/bin/torrent_done.sh
chown ruzickap:ruzickap /home/ruzickap/bin/torrent_done.sh


#############################
# Apache + PHP + Wordpress ...
#############################
a2enmod ssl include macro mime_magic rewrite userdir
sed -i 's/^ServerTokens.*/ServerTokens Off/;s/^ServerTokens.*/ServerTokens Prod/' /etc/apache2/conf.d/security

sed -i.orig 's@^;\(date.timezone\).*@\1 = "Europe/Prague"@;s/^\(upload_max_filesize\).*/\1 = 32M\npost_max_size = 32M/' /etc/php5/apache2/php.ini
wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/httpd.conf -O /etc/apache2/conf.d/httpd.conf
wget --no-verbose -O /var/www/favicon.ico 'http://www.favicon.cc/?action=icon&file_id=6056#'
htpasswd -c -b /etc/apache2/htpasswd ruzickap $RUZICKAP_PASSWORD


mkdir /etc/ssl/apache2

SUBJ="
C=CZ
ST=Czech Republic
O=xvx.cz
OU=XVX.CZ
L=Brno
CN=www.xvx.cz
emailAddress=webmaster@xvx.cz
"

(
  umask 077;
## Create RSA private key
  openssl genrsa -passout pass:${APACHE2_PRIVATE_KEY_PASSWORD} -des3 -out /etc/ssl/apache2/my-apache2.key 2048
  openssl rsa -passin pass:${APACHE2_PRIVATE_KEY_PASSWORD} -in /etc/ssl/apache2/my-apache2.key -out /etc/ssl/apache2/my-apache2.key.decrypted
## Create Certificate Signing Request with the server RSA private key:
  SUBJECTALTNAME="DNS:xvx.cz, DNS:www.xvx.cz, DNS:*.xvx.cz" openssl req -config /etc/ssl/openssl-my.cnf -passin pass:${APACHE2_PRIVATE_KEY_PASSWORD} -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -days 3650 -key /etc/ssl/apache2/my-apache2.key -out /etc/ssl/apache2/my-apache2.csr
  openssl req -text -in /etc/ssl/apache2/my-apache2.csr -out /etc/ssl/apache2/my-apache2.csr.text
## Use CA to sign the server's certificate
  SUBJECTALTNAME="DNS:xvx.cz, DNS:www.xvx.cz, DNS:*.xvx.cz" openssl ca -config /etc/ssl/openssl-my.cnf -passin pass:${CA_PASSWORD} -batch -in /etc/ssl/apache2/my-apache2.csr -out /etc/ssl/apache2/my-apache2.crt
  openssl x509 -text -in /etc/ssl/apache2/my-apache2.crt -out /etc/ssl/apache2/my-apache2.crt.text
)

#http://backreference.org/2009/12/17/name-based-ssl-virtual-hosts-in-apache/

sed -i.orig '/mod_ssl.c/a\
\ \ \ \ NameVirtualHost *:443\
\ \ \ \ SSLStrictSNIVHostCheck off' /etc/apache2/ports.conf

sed -i.orig 's@^\(\tSSLCertificateFile\).*@\1 /etc/ssl/apache2/my-apache2.crt@;s@^\(\tSSLCertificateKeyFile\).*@\1 /etc/ssl/apache2/my-apache2.key.decrypted@;/ServerAdmin/ a\ \ \ \ \ \ \ \ ServerName www.xvx.cz' /etc/apache2/sites-available/default-ssl
cd /etc/apache2/sites-enabled
ln -s ../sites-available/default-ssl 000-default-ssl

mkdir /var/www/myadmin/
wget --no-proxy --no-verbose -P /var/www/myadmin/ $HOST_FILES/files/mysql_web_data/index.html

#WP_PLUGINS="
#https://wordpress.org/extend/plugins/all-in-one-seo-pack/
#https://wordpress.org/extend/plugins/google-analytics-for-wordpress/
#https://wordpress.org/extend/plugins/nextgen-gallery/
#https://wordpress.org/extend/plugins/broken-link-checker/
#https://wordpress.org/extend/plugins/w3-total-cache/
#https://wordpress.org/extend/plugins/wp-useronline/
#https://wordpress.org/extend/plugins/wptouch/
#https://wordpress.org/extend/plugins/wp-stats-dashboard/
#https://wordpress.org/extend/plugins/wp-polls/
#https://wordpress.org/extend/plugins/codecolorer/
#https://wordpress.org/extend/plugins/gd-star-rating/
#https://wordpress.org/extend/plugins/google-sitemap-generator/
#"

#WP_THEMES="
#https://wordpress.org/extend/themes/zbench/
#https://wordpress.org/extend/themes/my-sweet-diary/
#"

#wget --no-check-certificate --no-verbose -P /var/lib/wordpress/wp-content/plugins/ `wget --no-check-certificate --no-verbose $WP_PLUGINS -O - | sed -n "s@.*href='\(http.*.zip\)'>Download Version.*@\1@p"`
#wget --no-check-certificate --no-verbose -P /var/lib/wordpress/wp-content/themes/ `wget --no-check-certificate --no-verbose $WP_THEMES -O - | sed -n "s@.*href='\(http.*.zip\)'>Download Version.*@\1@p"`

#find /var/lib/wordpress/wp-content/plugins/ -name "*.zip" -exec unzip -q -d /var/lib/wordpress/wp-content/plugins/ {} \;
#find /var/lib/wordpress/wp-content/themes/ -name "*.zip" -exec unzip -q -d /var/lib/wordpress/wp-content/themes/ {} \;
#rm /var/lib/wordpress/wp-content/{plugins,themes}/*.zip

sed -i.orig -re '7,14 s/^#//' /etc/wordpress/htaccess 
gunzip /usr/share/doc/wordpress/examples/setup-mysql.gz --to-stdout | sed 's@^CONTENT.*@CONTENT="/home/sites/$DOMAIN/www/wordpress/wp-content/"@;' > /etc/wordpress/setup-mysql
chmod a+x /etc/wordpress/setup-mysql


sed -i "/url_prefix_static =/ a \ \ \ \ url_prefix_static = '/moin_static'" /etc/moin/farmconfig.py
sed -i 's/.*\"mywiki\", r\"\.\*\".*/#&/' /etc/moin/farmconfig.py
echo "    url_prefix_action = 'action'" >> /etc/moin/farmconfig.py

echo "\$cfg['ForceSSL'] = true;" >> /etc/phpmyadmin/config.inc.php


#############################
# awstats
#############################
aptitude install --quiet -y libgeo-ip-perl

wget --no-verbose -O - http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz | gunzip > /var/lib/awstats/GeoIP.dat

cat >> /etc/awstats/awstats.conf.local << \EOF
SaveDatabaseFilesWithPermissionsForEveryone=1
SkipHosts="localhost REGEX[^.*\.localdomain$]"
DebugMessages=1
LoadPlugin="tooltips"
LoadPlugin="graphgooglechartapi"
LoadPlugin="decodeutfkeys"
LoadPlugin="graphapplet /awstatsclasses"
LoadPlugin="geoip GEOIP_STANDARD /var/lib/awstats/GeoIP.dat"
EOF

sed 's@^LogFile.*@LogFile="/usr/share/doc/awstats/examples/maillogconvert.pl standard < /var/log/mail.log.1 |"@;s@^LogType=.*@LogType=M@;s@^LogFormat=.*@LogFormat="%time2 %email %email_r %host %host_r %method %url %code %bytesd"@;s/^ShowSummary=.*/ShowSummary=HB/;s/^ShowMonthStats.*/ShowMonthStats=HB/;s/^ShowDaysOfMonthStats.*/ShowDaysOfMonthStats=HB/;s/^ShowDaysOfWeekStats.*/ShowDaysOfWeekStats=HB/;s/^ShowHoursStats.*/ShowHoursStats=HB/;s/^ShowDomainsStats.*/ShowDomainsStats=0/;s/^ShowHostsStats.*/ShowHostsStats=HBL/;s/^ShowRobotsStats.*/ShowRobotsStats=0/;s/^ShowEMailSenders.*/ShowEMailSenders=HBML/;s/^ShowEMailReceivers.*/ShowEMailReceivers=HBML/;s/^ShowSessionsStats.*/ShowSessionsStats=0/;s/^ShowPagesStats.*/ShowPagesStats=0/;s/^ShowFileTypesStats.*/ShowFileTypesStats=0/;s/^ShowOSStats.*/ShowOSStats=0/;s/^ShowBrowsersStats.*/ShowBrowsersStats=0/;s/^ShowOriginStats.*/ShowOriginStats=0/;s/^ShowKeyphrasesStats.*/ShowKeyphrasesStats=0/;s/^ShowKeywordsStats.*/ShowKeywordsStats=0/;s/^ShowMiscStats.*/ShowMiscStats=0/;s/^ShowHTTPErrorsStats.*/ShowHTTPErrorsStats=0/;s/^#\(ShowSMTPErrorsStats\).*/\1=1/;' /etc/awstats/awstats.conf > /etc/awstats/awstats.smtp-xvx.cz.conf
sed -i '/2 reduces AWStats speed by 15%/a \
LevelForBrowsersDetection=0\
LevelForOSDetection=0\
LevelForRefererAnalyze=0\
LevelForRobotsDetection=0\
LevelForSearchEnginesDetection=0\
LevelForKeywordsDetection=0\
LevelForFileTypesDetection=0\
' /etc/awstats/awstats.smtp-xvx.cz.conf

sed 's@^LogFile.*@LogFile="/var/log/xferlog.1" @;s/^LogType.*/LogType=F/;s/^LogFormat.*/LogFormat="%time3 %other %host %bytesd %url %other %other %method %other %logname %other %code %other %other"/;s/^LogSeparator.*/LogSeparator="\\s"/;s/^NotPageList.*/NotPageList=""/;s/^ShowLinksOnUrl.*/ShowLinksOnUrl=0/;s/^ShowMenu.*/ShowMenu=1/;s/^ShowSummary.*/ShowSummary=UVHB/;s/^ShowMonthStats.*/ShowMonthStats=UVHB/;s/^ShowDaysOfMonthStats.*/ShowDaysOfMonthStats=HB/;s/^ShowDaysOfWeekStats.*/ShowDaysOfWeekStats=HB/;s/^ShowHoursStats.*/ShowHoursStats=HB/;s/^ShowDomainsStats.*/ShowDomainsStats=HB/;s/^ShowHostsStats.*/ShowHostsStats=HBL/;s/^ShowAuthenticatedUsers.*/ShowAuthenticatedUsers=HBL/;s/^ShowRobotsStats.*/ShowRobotsStats=0/;s/^ShowEMailSenders.*/ShowEMailSenders=0/;s/^ShowEMailReceivers.*/ShowEMailReceivers=0/;s/^ShowSessionsStats.*/ShowSessionsStats=1/;s/^ShowPagesStats.*/ShowPagesStats=PBEX/;s/^ShowFileTypesStats.*/ShowFileTypesStats=HB/;s/^ShowFileSizesStats.*/ShowFileSizesStats=0/;s/^ShowBrowsersStats.*/ShowBrowsersStats=0/;s/^ShowOSStats.*/ShowOSStats=0/;s/^ShowOriginStats.*/ShowOriginStats=0/;s/^ShowKeyphrasesStats.*/ShowKeyphrasesStats=0/;s/^ShowKeywordsStats.*/ShowKeywordsStats=0/;s/^ShowMiscStats.*/ShowMiscStats=0/;s/^ShowHTTPErrorsStats.*/ShowHTTPErrorsStats=0/;s/^ShowSMTPErrorsStats.*/ShowSMTPErrorsStats=0/' /etc/awstats/awstats.conf > /etc/awstats/awstats.ftp-xvx.cz.conf
sed -i '/2 reduces AWStats speed by 15%/a \
LevelForBrowsersDetection=0\
LevelForOSDetection=0\
LevelForRefererAnalyze=0\
LevelForRobotsDetection=0\
LevelForWormsDetection=0\
LevelForSearchEnginesDetection=0\
' /etc/awstats/awstats.ftp-xvx.cz.conf

sed 's@^LogFile.*@LogFile="/var/log/apache2/access.log.1"@;s/^LogFormat.*/LogFormat=1/;s/^SiteDomain.*/SiteDomain="www.xvx.cz"/;s/^HostAliases.*/HostAliases="localhost 127.0.0.1 REGEX\[xvx\\\.cz\$\]"/;' /etc/awstats/awstats.conf > /etc/awstats/awstats.http-xvx.cz.conf
sed 's@^LogFile.*@LogFile="/var/log/apache2/ssl_access.log.1"@' /etc/awstats/awstats.http-xvx.cz.conf > /etc/awstats/awstats.https-xvx.cz.conf

echo "#Don't use this file!!! See /etc/cron.weekly/awstats" > /etc/cron.d/awstats
sed -i.orig 's/^\(AWSTATS_ENABLE_BUILDSTATICPAGES\)=.*/\1="no"/' /etc/default/awstats

wget --no-proxy --no-verbose -P /etc/cron.weekly/ $HOST_FILES/files/awstats
chmod a+x /etc/cron.weekly/awstats

wget --no-proxy --no-verbose $HOST_FILES/files/sites-test $HOST_FILES/files/sites -P /root/bin/
chmod a+x /root/bin/sites*

mkdir /var/log/sites

/root/bin/sites --domain="xvx.cz"

IP=`ifconfig $INTERNET_INTERFACE | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}'`
REVERSE_IP=`echo $IP | sed -r 's/([0-9]+).([0-9]+).([0-9]+).([0-9]+)/\3.\2.\1/'`
LAST_OCTET=`echo $IP | sed -r 's/[0-9]+.[0-9]+.[0-9]+.([0-9]+)/\1/'`

# Reverse DNS record - needed one time for all domains
cat > /etc/bind/domains/db.$REVERSE_IP << EOF
; BIND reverse database file for zone $REVERSE_IP
\$TTL 3D
@               IN      SOA     ns.xvx.cz.        info.xvx.cz. (
                        `date +%Y%m%d01` ; serial
                        3H ; refresh
                        1H ; retry
                        1W ; expire
                        1H) ; default_ttl

                NS      ns.xvx.cz.
                NS      ns2.xvx.cz.

$LAST_OCTET             PTR     ns.xvx.cz.
$LAST_OCTET             PTR     xvx.cz.
EOF

  cat >> /etc/bind/named.conf.local << EOF
        
zone "$REVERSE_IP.in-addr.arpa" IN {
        type master;
        file "/etc/bind/domains/xvx.cz/db.${REVERSE_IP}";
        allow-query { any; };
};
EOF

echo "ftp             CNAME   xvx.cz." >> /etc/bind/domains/xvx.cz/db.xvx.cz
echo "petr            CNAME   xvx.cz." >> /etc/bind/domains/xvx.cz/db.xvx.cz

/root/bin/sites --wordpress-password=$WORDPRESS_LINUX_XVX_CZ_ADMIN_PASSWORD --wordpress-title="Petr's blog about Linux" --wordpress-admin-email=$WORDPRESS_LINUX_XVX_CZ_EMAIL --wordpress-admin-name="admin" --user-password=$WORDPRESS_LINUX_XVX_CZ_ADMIN_PASSWORD --ca-password=$CA_PASSWORD --domain="linux.xvx.cz" --cert-password=$WORDPRESS_LINUX_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$WORDPRESS_LINUX_XVX_CZ_EMAIL
/root/bin/sites --wordpress-password=$WORDPRESS_CESTOVANI_XVX_CZ_ADMIN_PASSWORD --wordpress-title="Cestování" --wordpress-admin-email=$WORDPRESS_CESTOVANI_XVX_CZ_EMAIL --wordpress-admin-name="admin" --user-password=$WORDPRESS_CESTOVANI_XVX_CZ_ADMIN_PASSWORD --ca-password=$CA_PASSWORD --domain="cestovani.xvx.cz" --cert-password=$WORDPRESS_CESTOVANI_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$WORDPRESS_CESTOVANI_XVX_CZ_EMAIL
/root/bin/sites --wordpress-password=$WORDPRESS_SVATBA_XVX_CZ_ADMIN_PASSWORD --wordpress-title="Svatba: Andrea a Petr" --wordpress-admin-email=$WORDPRESS_SVATBA_XVX_CZ_EMAIL --wordpress-admin-name="admin" --user-password=$WORDPRESS_SVATBA_XVX_CZ_ADMIN_PASSWORD --ca-password=$CA_PASSWORD --domain="svatba.xvx.cz" --cert-password=$WORDPRESS_SVATBA_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$WORDPRESS_SVATBA_XVX_CZ_EMAIL
/root/bin/sites --user-password=$FEDORA_XVX_CZ_PASSWORD --ca-password=$CA_PASSWORD --domain="fedora.xvx.cz" --cert-password=$FEDORA_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$FEDORA_XVX_CZ_EMAIL
/root/bin/sites --user-password=$DEBIAN_XVX_CZ_PASSWORD --ca-password=$CA_PASSWORD --domain="debian.xvx.cz" --cert-password=$DEBIAN_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$DEBIAN_XVX_CZ_EMAIL
/root/bin/sites --user-password=$RUZICKOVABOZENA_XVX_CZ_PASSWORD --ca-password=$CA_PASSWORD --domain="ruzickovabozena.xvx.cz" --cert-password=$RUZICKOVABOZENA_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$RUZICKOVABOZENA_XVX_CZ_EMAIL
/root/bin/sites --moin-sitename="a.xvx.cz" --moin-user="admin" --moin-user-alias="admin" --moin-user-password=$MOIN_A_XVX_CZ_ADMIN_PASSWORD --moin-user-email=$MOIN_A_XVX_CZ_EMAIL --user-password=$MOIN_A_XVX_CZ_USER_PASSWORD --ca-password=$CA_PASSWORD --domain="a.xvx.cz" --cert-password=$MOIN_A_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$MOIN_A_XVX_CZ_EMAIL
/root/bin/sites --moin-sitename="rh.xvx.cz" --moin-user="admin" --moin-user-alias="admin" --moin-user-password=$MOIN_RH_XVX_CZ_ADMIN_PASSWORD --moin-user-email=$MOIN_RH_XVX_CZ_EMAIL --user-password=$MOIN_RH_XVX_CZ_USER_PASSWORD --ca-password=$CA_PASSWORD --domain="rh.xvx.cz" --cert-password=$MOIN_RH_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$MOIN_RH_XVX_CZ_EMAIL
/root/bin/sites --moin-sitename="att.xvx.cz" --moin-user="admin" --moin-user-alias="admin" --moin-user-password=$MOIN_ATT_XVX_CZ_ADMIN_PASSWORD --moin-user-email=$MOIN_ATT_XVX_CZ_EMAIL --user-password=$MOIN_ATT_XVX_CZ_USER_PASSWORD --ca-password=$CA_PASSWORD --domain="att.xvx.cz" --cert-password=$MOIN_ATT_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$MOIN_ATT_XVX_CZ_EMAIL

/root/bin/sites --moin-sitename="moin.xvx.cz" --moin-user="admin" --moin-user-alias="admin" --moin-user-password=$MOIN_MOIN_XVX_CZ_ADMIN_PASSWORD --moin-user-email=$MOIN_MOIN_XVX_CZ_EMAIL --user-password=$MOIN_MOIN_XVX_CZ_USER_PASSWORD --ca-password=$CA_PASSWORD --domain="moin.xvx.cz" --cert-password=$MOIN_MOIN_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$MOIN_MOIN_XVX_CZ_EMAIL
/root/bin/sites --wordpress-password=$WORDPRESS_WORDPRESS_XVX_CZ_ADMIN_PASSWORD --wordpress-title="Wordpress Linux" --wordpress-admin-email=$WORDPRESS_WORDPRESS_XVX_CZ_EMAIL --wordpress-admin-name="admin" --user-password=$WORDPRESS_WORDPRESS_XVX_CZ_ADMIN_PASSWORD --ca-password=$CA_PASSWORD --domain="wordpress.xvx.cz" --cert-password=$WORDPRESS_LINUX_XVX_CZ_PRIVATE_KEY_PASSWORD --email=$WORDPRESS_LINUX_XVX_CZ_EMAIL

WP_SQL_DEFAULTS="
UPDATE wp_options SET option_value = '/%year%/%monthnum%/%postname%/' WHERE  wp_options.option_name = 'permalink_structure';
UPDATE wp_options SET option_value = '' WHERE  wp_options.option_name = 'comment_whitelist';
UPDATE wp_options SET option_value = '1' WHERE  wp_options.option_name = 'gzipcompression';
UPDATE wp_options SET option_value = '15' WHERE  wp_options.option_name = 'default_post_edit_rows';
"

cat > /root/mysql_dump-linux.xvx.cz.sql << EOF2
UPDATE wp_options SET option_value = 'My personal blog about Linux and other opensource ...' WHERE  wp_options.option_name = 'blogdescription';
UPDATE wp_options SET option_value = 'zbench' WHERE  wp_options.option_name = 'template';
UPDATE wp_options SET option_value = 'zbench' WHERE  wp_options.option_name = 'stylesheet';
$WP_SQL_DEFAULTS
EOF2

cat > /root/mysql_dump-svatba.xvx.cz.sql << EOF2
UPDATE wp_options SET option_value = 'Svatba: Andrea a Petr' WHERE  wp_options.option_name = 'blogdescription';
UPDATE wp_options SET option_value = 'my-sweet-diary' WHERE  wp_options.option_name = 'template';
UPDATE wp_options SET option_value = 'my-sweet-diary' WHERE  wp_options.option_name = 'stylesheet';
$WP_SQL_DEFAULTS
EOF2

cat > /root/mysql_dump-cestovani.xvx.cz.sql << EOF2
UPDATE wp_options SET option_value = '...aneb kam jsme se podívali nebo pocestujeme' WHERE  wp_options.option_name = 'blogdescription';
UPDATE wp_options SET option_value = 'zbench' WHERE  wp_options.option_name = 'template';
UPDATE wp_options SET option_value = 'zbench' WHERE  wp_options.option_name = 'stylesheet';
$WP_SQL_DEFAULTS
EOF2

for DOMAIN in linux.xvx.cz cestovani.xvx.cz svatba.xvx.cz ; do
  set -x
  TMP_DATABASE_NAME="wp_$(echo $DOMAIN | sed 's,\.,,g;s,-,,g')"
  DATABASE_NAME=${TMP_DATABASE_NAME:0:16}
  wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/mysql_dump-$DOMAIN.sql.xz -O - | xzcat | sed 's/wp_cestovxvxcz/wp_cestovanixvxc/g;s@/wp-uploads/@/wp-content/uploads/@g' >> /root/mysql_dump-$DOMAIN.sql
  mysql --password=$MYSQL_DBPASS --user=root $DATABASE_NAME < /root/mysql_dump-$DOMAIN.sql
done

  wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/svatba.xvx.cz.tar.xz -O - | tar xJf - -C /home/sites/svatba.xvx.cz/www/wordpress/wp-content/uploads/ 
  wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/linux.xvx.cz.tar.xz -O - | tar xJf - -C /home/sites/linux.xvx.cz/www/wordpress/wp-content/uploads/

for DOMAIN in a.xvx.cz rh.xvx.cz att.xvx.cz; do
  DOMAIN_UNDERSCORE=`echo ${DOMAIN} | tr . _`
  moin --config-dir=/etc/moin/ --wiki-url=http://$DOMAIN account create --name=ruzickap --password=$MOIN_RUZICKAP_PASSWORD_FOR_PRIVATE_WIKIS --alias=ruzickap --email=ruzickap@xvx.cz
  wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/$DOMAIN.tar.xz -O - | tar xJf - -C /home/sites/$DOMAIN/www/moin/data/
  moin -q --config-dir=/etc/moin/ --wiki-url=http://${DOMAIN} maint cleanpage &> /dev/null
  moin -q --config-dir=/etc/moin/ --wiki-url=http://${DOMAIN} maint cleancache &> /dev/null
  moin -q --config-dir=/etc/moin/ --wiki-url=http://${DOMAIN} maint cleansessions &> /dev/null
  moin -q --config-dir=/etc/moin/ --wiki-url=http://${DOMAIN} maint reducewiki --target-dir=/home/sites/$DOMAIN/www/moin/reduced-pages
  rm -rf /home/sites/$DOMAIN/www/moin/data/pages
  mv /home/sites/$DOMAIN/www/moin/reduced-pages/* /home/sites/$DOMAIN/www/moin/data/
  rm -rf /home/sites/$DOMAIN/www/moin/reduced-pages

  cat > /home/sites/${DOMAIN}/www/moin/robots.txt << EOF2
User-agent: *
Disallow: /
EOF2

  chown -R www-data:www-data /home/sites/${DOMAIN}/www/moin
  find /home/sites/${DOMAIN}/www/moin -type d -exec chmod 770 {} \;
  find /home/sites/${DOMAIN}/www/moin -type f -exec chmod 660 {} \;

  cat >> /etc/moin/$DOMAIN_UNDERSCORE.py << EOF2
    acl_rights_default = u'+ruzickap:read,write,delete,revert,admin -All:read'

    # stop new accounts being created
    actions_excluded = FarmConfig.actions_excluded + ['newaccount']

    mail_from = u'Wiki Notifier <noreply@${DOMAIN}>'
    mail_smarthost = 'localhost'
EOF2

  sed -i "s@Use Moin-http .*@ServerName $DOMAIN\\n\
\\n\
    Use HTTPS_REDIRECT\\n\
    Alias /robots.txt /usr/share/moin/htdocs/robots.txt\
@" /etc/apache2/sites-available/$DOMAIN
done

sed -i 's/FrontPage/redhat/' /etc/moin/rh_xvx_cz.py
sed -i 's/FrontPage/att/' /etc/moin/att_xvx_cz.py
sed -i 's/FrontPage/uOne/' /etc/moin/a_xvx_cz.py

for DOMAIN in debian.xvx.cz fedora.xvx.cz ruzickovabozena.xvx.cz; do
  wget --no-proxy --no-verbose $HOST_FILES/files/mysql_web_data/$DOMAIN.tar.xz -O - | tar xJf - -C /home/sites/$DOMAIN/www/htdocs/
done

service apache2 restart


#############################
# LIRC + XBMC
#############################
aptitude install -y --quiet alsa-utils lirc nvidia-kernel-dkms nvidia-smi nvidia-xconfig xbmc xinit xserver-xorg libgl1-mesa-dri

sed -i.orig 's@^#START_IREXEC=.*@START_IREXEC=true@;s@^DRIVER.*@DRIVER="irman"@;s@^DEVICE.*@DEVICE="/dev/ttyS0"@' /etc/lirc/hardware.conf
wget --no-verbose http://lirc.sourceforge.net/remotes/samsung/BN59-00937A.irman -O /etc/lirc/lircd.conf
cat > /etc/lirc/lircrc << EOF
begin
    remote = Samsung_BN59-00937A
    prog = irexec
    button = Power
    config = /etc/init.d/xbmc start
    repeat = 0
    delay = 0
end
EOF

useradd --user-group --create-home --comment "XBMC account" --groups cdrom,audio,video,plugdev --shell /sbin/noshell xbmc
wget --no-proxy --no-verbose -P /etc/init.d/ $HOST_FILES/files/xbmc/xbmc
mkdir -p /home/xbmc/.xbmc/userdata
wget --no-proxy --no-verbose -P /home/xbmc/.xbmc/userdata/ $HOST_FILES/files/xbmc/Lircmap.xml $HOST_FILES/files/xbmc/RssFeeds.xml $HOST_FILES/files/xbmc/advancedsettings.xml $HOST_FILES/files/xbmc/sources.xml $HOST_FILES/files/xbmc/guisettings.xml
chown -R xbmc:xbmc /home/xbmc

chmod a+x /etc/init.d/xbmc

cat > /etc/default/xbmc << EOF
START_XBMC=1
XBMC_HOME="/home/xbmc"
XBMC_USER="xbmc"
EOF

echo 'blacklist nouveau' > /etc/modprobe.d/blacklist_nouveau.conf

nvidia-xconfig
sed -i.orig '/NVIDIA Corporation/a \
    Option          "NoLogo" "True"\
    Option          "RenderAccel" "True"\
    Option          "AllowGLXWithComposite" "true"\
    Option          "AddARGBGLXVisuals" "true"\
    Option          "TripleBuffer" "True"\
    Option          "UseEvents" "True"' /etc/X11/xorg.conf


#############################
# NFSv4
#############################
mkdir /home/data2
mkdir -p /srv/nfs4/{share,ruzickap,photos}

RW_OPTIONS="rw,no_root_squash,no_subtree_check,crossmnt,async"
RO_OPTIONS="ro,no_root_squash,no_subtree_check,crossmnt,async"
cat >> /etc/exports << EOF
/srv/nfs4		${LOCALNET_INTERFACE_IP}($RO_OPTIONS,fsid=0) ${WIFI_INTERFACE_IP}($RO_OPTIONS,fsid=0) ${LOCALNET_INTERFACE_TV_IP}($RO_OPTIONS,fsid=0)
/srv/nfs4/share		${LOCALNET_INTERFACE_IP}($RO_OPTIONS) ${WIFI_INTERFACE_IP}($RO_OPTIONS) ${LOCALNET_INTERFACE_TV_IP}($RO_OPTIONS)
/srv/nfs4/ruzickap	192.168.0.3($RW_OPTIONS) 192.168.1.3($RW_OPTIONS) 192.168.2.3($RW_OPTIONS)
/srv/nfs4/photos	192.168.0.3($RW_OPTIONS) 192.168.1.3($RW_OPTIONS) 192.168.2.3($RW_OPTIONS) 192.168.0.4($RO_OPTIONS) 192.168.1.4($RO_OPTIONS) 192.168.2.4($RO_OPTIONS) 192.168.0.6($RO_OPTIONS) 192.168.2.6($RO_OPTIONS) 192.168.0.7($RO_OPTIONS) 192.168.2.7($RO_OPTIONS)
EOF

cat >> /etc/fstab << EOF
/home/data2/photos	/srv/nfs4/photos	none	bind
/home/data/share	/srv/nfs4/share		none	bind
/home/ruzickap		/srv/nfs4/ruzickap	none	bind
EOF

cat >> /etc/default/nfs-common << EOF

NEED_STATD=no
NEED_IDMAPD=yes
NEED_GSSD=no
EOF

sed -i 's/^RPCNFSDCOUNT=8/RPCNFSDCOUNT=2/' /etc/default/nfs-kernel-server

#############################
# fail2ban
#############################
sed -i.orig 's/^banaction =.*/banaction = shorewall/' /etc/fail2ban/jail.conf
sed -i.orig 's/port     = ssh/port     = 2222/;/\[pam-generic\]/{ N; N; s/enabled.*/enabled  = true/ };/\[vsftpd\]/{ N; N; s/enabled.*/enabled  = true/ };/\[ssh-ddos\]/{ N; N; s/enabled.*/enabled  = true/ };/\[apache\]/{ N; N; s/enabled.*/enabled  = true/ };/\[apache-noscript\]/{ N; N; s/enabled.*/enabled  = true/ };/\[apache-overflows\]/{ N; N; s/enabled.*/enabled  = true/ };' /etc/fail2ban/jail.conf


#############################
# shorewall
#############################
sed -i.orig 's/startup=0/startup=1/' /etc/default/shorewall
sed -i.orig 's/^\(LOG_MARTIANS\).*/\1=No/' /etc/shorewall/shorewall.conf
cat >> /etc/sysctl.d/local.conf << EOF
net.ipv4.ip_forward=1
net.ipv4.tcp_syncookies=1
net.ipv4.conf.all.log_martians = 0
EOF
cp /usr/share/shorewall/configfiles/{interfaces,masq,rules,policy,zones} /etc/shorewall/
cat >> /etc/shorewall/zones << EOF
#TV + Gbit NIC
lan	ipv4

#Wifi (external)
wifie	ipv4

#Wifi (private)
wifip	ipv4

#USB modem
wan		ipv4
EOF

cat >> /etc/shorewall/interfaces << EOF
wifip		$WIFI_INTERFACE	tcpflags,dhcp,nosmurfs,routefilter
wifie		${WIFI_INTERFACE}.2	tcpflags,dhcp,nosmurfs,routefilter,blacklist
lan		$LOCALNET_INTERFACE    tcpflags,dhcp,nosmurfs,routefilter
lan		$LOCALNET_INTERFACE_TV    tcpflags,dhcp,nosmurfs,routefilter
wan		$INTERNET_INTERFACE    tcpflags,dhcp,nosmurfs,routefilter,sourceroute=0,blacklist
EOF

cat >> /etc/shorewall/policy << EOF
fw              all             ACCEPT
wan             all             DROP	info

wifip           all             ACCEPT
wifie           wan             ACCEPT
wifie           all             DROP	info

lan		all		ACCEPT
all             all             REJECT
EOF

cat >> /etc/shorewall/masq << EOF
$INTERNET_INTERFACE                    $LOCALNET_INTERFACE_IP
$INTERNET_INTERFACE                    $WIFI_INTERFACE_IP
$INTERNET_INTERFACE                    $WIFI_INTERFACE_IP2
$INTERNET_INTERFACE                    $LOCALNET_INTERFACE_TV_IP
EOF

cat >> /etc/shorewall/rules << EOF
DNS(ACCEPT)             all                     fw
FTP(ACCEPT)             all                     fw
Web(ACCEPT)             all                     fw
NTP(ACCEPT)             all                     fw
Ping(ACCEPT)            all                     all
Rfc1918/(DROP)          wan                     fw
SMTP(ACCEPT)            lan,wifip               fw
TFTP(ACCEPT)            lan,wifip               fw
BitTorrent32(REJECT)    wifie                   all
Edonkey(REJECT)         wifie                   all
Gnutella(REJECT)        wifie                   all

COMMENT NFSv4
ACCEPT                  lan,wifip               fw      tcp,udp     111,2049

COMMENT SSH
ACCEPT                  wan,lan,wifip           fw      tcp         2222

COMMENT Transmission
ACCEPT                  wan,lan,wifip           fw      tcp,udp     6969,9090,51413

COMMENT XBMC
ACCEPT                  wifip,lan               fw      tcp         8080
ACCEPT                  wifip,lan               fw      udp         9777
EOF


#############################
# logrotate
#############################
sed -i.orig 's/^week/month/;/^create/ a\
compresscmd /usr/bin/xz\
compressoptions -9\
uncompresscmd /usr/bin/unxz\
compressext .xz' /etc/logrotate.conf

sed -i 's/rotate 52/rotate 12/;s/create 640/create 644/' /etc/logrotate.d/apache2
sed -i 's/weekly/monthly/' /etc/logrotate.d/fail2ban /etc/logrotate.d/munin /etc/logrotate.d/rsyslog /etc/logrotate.d/shorewall /etc/logrotate.d/vsftpd /etc/logrotate.d/munin
sed -i 's@^/var/log/vsftpd.log@& /var/log/xferlog@' /etc/logrotate.d/vsftpd

cat > /etc/logrotate.d/named << EOF
/var/log/named/dnssec.log.0 /var/log/named/lame-servers.log.0 /var/log/named/queries.log.0 /var/log/named/security.log.0 {
    missingok
    weekly
    notifempty
    compress
    rotate 5
}
EOF


# Tests
# echo "*/5 * * * * root sleep \`expr \$RANDOM \% 1800\` && /root/bin/sites-test &> /dev/null" > /etc/cron.d/tests


#############################
# backup
#############################
useradd --create-home --shell /bin/sh --skel /dev/null backups
chmod o-rx /home/backups
sudo -u backups ssh-keygen -N "" -C backups@id_rsa-rdiff -f /home/backups/.ssh/id_rsa-rdiff
sudo -u backups ssh-keygen -N "" -C backups@id_rsa-rsync-peru-android -f /home/backups/.ssh/id_rsa-rsync-peru-android
mkdir /home/backups/bin
wget --no-proxy --no-verbose -P /home/backups/bin $HOST_FILES/files/backups/backup $HOST_FILES/files/backups/backup.lst
chmod a+x /home/backups/bin/backup
cat > /home/backups/.ssh/authorized_keys << EOF
command="rdiff-backup --server --restrict /home/backups/",no-agent-forwarding,no-user-rc,no-port-forwarding,no-X11-forwarding,no-pty `cat /home/backups/.ssh/id_rsa-rdiff.pub`
command="rsync --server -vlHtre.iLsf --delete-after --inplace . /home/backups/peru-android",no-agent-forwarding,no-user-rc,no-port-forwarding,no-X11-forwarding,no-pty `cat /home/backups/.ssh/id_rsa-rsync-peru-android.pub`
EOF
chmod 600 /home/backups/.ssh/authorized_keys
chown backups:backups /home/backups/.ssh/authorized_keys

cat > /etc/cron.weekly/backups << EOF
#!/bin/bash

nice /home/backups/bin/backup
EOF
chmod a+x /etc/cron.weekly/backups

reboot
) 2>&1 | tee /root/post_install2.log
