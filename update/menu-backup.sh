#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
todayy=`date +"%Y-%m-%d" -d "$dateFromServer"`
MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl -sS https://raw.githubusercontent.com/halonthe/permission/main/ip | awk '{print $4}' | grep $MYIP)
###########- COLOR CODE -##############
colornow=$(cat /etc/alexxa/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="$(cat /etc/alexxa/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/alexxa/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########

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
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"

function startauto() {
email=$(cat /home/email)
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1  $NC$COLBG1                • AUTO BACKUP •                $COLOR1  $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
if [[ "$email" = "" ]]; then
echo "Please enter your email"
read -rp "Email: " -e email
cat <<EOF>>/home/email
$email
EOF
fi
rm -f /etc/cron.d/auto_backup
echo "0 1 * * * root /usr/bin/autobackup" > /etc/cron.d/auto_backup && chmod +x /etc/cron.d/auto_backup
service cron restart
echo -e " $COLOR1 $NC [INFO] Active & Running Automaticly"
echo -e " $COLOR1 $NC [INFO] Auto Backup : 01:00 GMT +7"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}      [Ctrl + C] For exit from main menu     $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-backup
}

function stopauto() {
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1  $NC$COLBG1                • AUTO BACKUP •                $COLOR1  $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
rm -f /etc/cron.d/auto_backup
echo "0 1 * * * root /usr/bin/autobackup" > /etc/cron.d/auto_backup && chmod +x /etc/cron.d/auto_backup
service cron restart
echo -e " $COLOR1 $NC [INFO] Autobackup Has Been Stopped"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}      [Ctrl + C] For exit from main menu     $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-backup
}

function restore() {
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1  $NC$COLBG1                • RESTORE DATA •                $COLOR1  $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
read -rp "$COLOR1 Link File: " -e url
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo -e "$COLOR1 ${NC}   • Start Restore"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
rm -rf /root/backup
rm -f backup.zip
echo -e "$COLOR1 ${NC}   • Data Restored Successfully"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}      [Ctrl + C] For exit from main menu     $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-backup
}

function backup() {
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • BACKUP PANEL MENU •             ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
email=$(cat /home/email)
if [[ "$email" = "" ]]; then
read -rp "Email: " -e email
cat <<EOF>>/home/email
$email
EOF
fi
mkdir /root/backup
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /var/lib/alexxa/ backup/alexxa
cp -r /var/lib/alexxa-pro/ backup/alexxa-pro
cp -r /usr/local/etc/xray backup/xray
cd /root
echo -e "    Processing ..."
zip -r $MYIP-$todayy.zip backup > /dev/null 2>&1
rclone copy /root/$MYIP-$todayy.zip dr:backup/
url=$(rclone link dr:backup/$MYIP-$todayy.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo -e "$COLOR1 ${NC}   • The following is a link to your vps data backup file."
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}    Google Drive: $link"
echo -e "$COLOR1 ${NC}    If you want to restore data, please enter the link above."
mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
echo "$COLOR1 ${NC}       Please Check Your Email"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}      [Ctrl + C] For exit from main menu     $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu-backup
}

cek=/etc/cron.d/auto_backup
if [ -f "$cek" ]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             • BACKUP PANEL MENU •             ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC            [ AUTO BACKUP : ${sts} ]$COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
echo -e " $COLOR1 $NC   ${COLOR1}[01]${NC} • BACKUP VPS      ${COLOR1}[03]${NC} • START AUTOBACKUP    $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${COLOR1}[02]${NC} • RESTORE VPS     ${COLOR1}[04]${NC} • STOP AUTOBACKUP     $COLOR1 $NC"
echo -e " $COLOR1 $NC                                               $COLOR1 $NC"
echo -e " $COLOR1 $NC   ${COLOR1}[00]${NC} • GO BACK${NC}                              $COLOR1 $NC"
echo -e " $COLOR1└───────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}      [Ctrl + C] For exit from main menu     $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
01 | 1) clear ; backup ;;
02 | 2) clear ; restore ;;
03 | 3) clear ; startauto ;;
04 | 4) clear ; stopauto ;;
00 | 0) clear ; menu ;;
*) clear ; menu-backup ;;
esac

       