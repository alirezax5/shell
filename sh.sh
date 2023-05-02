#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

updateServer() {
  echo -e "${yellow} update server"
  apt update && apt upgrade -y
  echo -e "${green} server is updated"
}

installApache() {
  echo -e "${yellow} install apache2 ..."
  apt install apache2 -y
  echo -e "${green} apache2 installed"
  chown -R www-data: /var/www/
  echo -e "${green} chown /var/www/"

}
installZip() {
  echo -e "${yellow} install zip unzip ..."
  sudo apt install zip unzip -y
  echo -e "${green} zip unzip installed"

}

installCronJob() {
  echo -e "${yellow} install cron ..."
  sudo apt install cron
  sudo systemctl enable cron
  (crontab -l; echo "0 * * * * /usr/bin/php /var/www/html/api/sendBackupOnTel.php") | sort -u | crontab -
  echo -e "${green} cron installed"

}
installPhp(){
    echo -e "${yellow} install php ..."
  apt install software-properties-common
  add-apt-repository ppa:ondrej/php
  apt update -y
  apt install php8.1
  apt install php8.1-curl
  apt install sqlite3
  echo -e "${green} php sqlite3 curl installed"

}
updateServer
installApache
installZip
installCronJob
installPhp
