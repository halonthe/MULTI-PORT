#!/bin/bash
IP=$(wget -qO- icanhazip.com);
date=$(date +"%Y-%m-%d")
email=$(cat /home/email)
mkdir /root/backup
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /var/lib/alexxa/ backup/alexxa
cp -r /var/lib/alexxa-pro/ backup/alexxa-pro
cp -r /usr/local/etc/xray backup/xray
cp -r /etc/wireguard backup/wireguard
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip