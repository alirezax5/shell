#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

updateServer() {
  echo -e "${yellow} update server ${plain}"
  apt update && apt upgrade -y
  echo -e "${green} server is updated ${plain}"
}

installApache() {
  echo -e "${yellow} install apache2 ... ${plain}"
  apt install apache2 -y
  echo -e "${green} apache2 installed"
  chown -R www-data: /var/www/
  echo -e "${green} chown /var/www/ ${plain}"

}
installZip() {
  echo -e "${yellow} install zip unzip ... ${plain}"
  sudo apt install zip unzip -y
  echo -e "${green} zip unzip installed ${plain}"

}

installCronJob() {
  echo -e "${yellow} install cron ... ${plain}"
  sudo apt install cron
  sudo systemctl enable cron
  sleep 2

  (
    crontab -l
    echo "0 * * * * /usr/bin/php /var/www/html/api/sendBackupOnTel.php"
  ) | sort -u | crontab -
  echo -e "${green} cron installed ${plain}"

}
installPhp() {
  echo -e "${yellow} install php ... ${plain}"
  apt install software-properties-common
  add-apt-repository ppa:ondrej/php
  apt update -y
  sleep 2
  apt install php8.1 -y
  sleep 2
  apt install php8.1-curl -y
  sleep 2
  apt install sqlite -y
  sleep 2
  apt install sqlite3 -y
  echo -e "${green} php sqlite3 curl installed ${plain}"

}
chmodXuiDb() {
  echo -e "${yellow} chmod /etc/x-ui/x-ui.db ... ${plain}"
  chmod 777 /etc/x-ui/x-ui.db
  chmod 777 /etc/x-ui/
  chmod 777 /etc/x-ui
  chmod 777 /etc/
  echo -e "${green} chmode db ended ${plain}"

}
rewriteMode() {
  echo -e "${yellow} rewrite ... ${plain}"
  sudo a2enmod rewrite
  sudo systemctl restart apache2
  echo -e "${green} rewrite ended ${plain}"

}
updateServer
installApache
installZip
installCronJob
installPhp
chmodXuiDb
rewriteMode
