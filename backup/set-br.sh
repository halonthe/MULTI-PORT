#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
todayy=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl -sS https://raw.githubusercontent.com/halonthe/permission/main/ip | awk '{print $4}' | grep $MYIP)
#########################

MONGGO () {
    curl -sS https://raw.githubusercontent.com/halonthe/permission/main/ip > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$todayy" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}

VALIDITY () {
    Name=$(curl -sS https://raw.githubusercontent.com/halonthe/permission/main/ip | grep $MYIP | awk '{print $2}')
    echo $Name > /usr/local/etc/.$Name.ini
    CekOne=$(cat /usr/local/etc/.$Name.ini)
    if [ -f "/etc/.$Name.ini" ]; then
    CekTwo=$(cat /etc/.$Name.ini)
        if [ "$CekOne" = "$CekTwo" ]; then
            res="Expired"
        fi
    else
    res="Permission Accepted..."
    fi
}

PERMISSION () {
    if [ "$MYIP" = "$IZIN" ]; then
    VALIDITY
    else
    res="Permission Denied!"
    fi
    MONGGO
}
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'

apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/halonthe/MULTI-PORT/main/backup/rclone.conf"
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user aritemlek@gmail.com
from aritemlek@gmail.com
password vwffijpjodbiywpx 
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
cd /usr/bin
wget -O bckp "https://raw.githubusercontent.com/halonthe/MULTI-PORT/main/backup/bckp.sh"
wget -O restore "https://raw.githubusercontent.com/halonthe/MULTI-PORT/main/backup/restore.sh"
wget -O limitspeed "https://raw.githubusercontent.com/halonthe/MULTI-PORT/main/backup/limitspeed.sh"
chmod +x bkcp
chmod +x restore
chmod +x limitspeed
cd
rm -f /root/set-br.sh