#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

groupadd docker-data 
usermod -a -G docker-data,adm www-data

# user config
cat <<'EOT' > /etc/my_init.d/01_user_config.sh
#!/bin/bash
GROUPID=${GROUP_ID:-999}
groupmod -g $GROUPID docker-data 
EOT

# auto update
cat <<'EOT' > /etc/my_init.d/02_auto_update.sh
#!/bin/bash
apt-get update -qq
apt-get upgrade -qy
EOT

#set Port for Apache to listen to
cat <<'EOT' > /etc/my_init.d/03_set_a2port.sh
#!/bin/bash
A2PORT=${PORT:-443}
echo "Listen *:$A2PORT" > /etc/apache2/ports.conf
EOT

# Apache Startup Script
mkdir -p /etc/service/apache2
cat <<'EOT' > /etc/service/apache2/run
#!/bin/bash
exec /sbin/setuser root /usr/sbin/apache2ctl -DFOREGROUND 2>&1
EOT

chmod -R +x /etc/service/ /etc/my_init.d/

mkdir /crt
chmod 750 /crt
openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -keyout /crt/privacyidea.key -out /crt/privacyidea.crt -subj "/C=/ST=/L=/O=PrivacyIDEA/OU=PrivacyIDEA/CN=PrivacyIDEA" 
chmod 640 /crt/*

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /tmp/*
