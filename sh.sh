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

setUpCronJob() {
  echo -e "${yellow} setup ... ${plain}"
  sudo systemctl enable cron
  sleep 2
  (
    crontab -l
    echo "0 * * * * /usr/bin/php /var/www/html/api/sendBackupOnTel.php"
  ) | sort -u | crontab -
  echo -e "${green} cron has  enable${plain}"

}
addrepositoryPhp() {
  echo -e "${yellow} add repository ... ${plain}"
  apt install software-properties-common
  add-apt-repository ppa:ondrej/php
  apt update -y
  sleep 2
  echo -e "${green} repository adedd ${plain}"

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
addrepositoryPhp

PKG=(
  apache2
  php-mbstring
  php8.1
  php8.1-curl
  php8.1-zip
  php8.1-sqlite
  sqlite
  sqlite3
  zip
  unzip
  cron
)
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install_en.sh)

for i in "${PKG[@]}"; do
  dpkg -s $i &>/dev/null
  if [ $? -eq 0 ]; then
    echo "$i is already installed"
  else
    apt install $i -y
    if [ $? -ne 0 ]; then
      echo "Error installing $i"
    fi
  fi
done

setUpCronJob
chmodXuiDb
rewriteMode
