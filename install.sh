#!/bin/bash


path=$(pwd)

echo
echo
echo
echo "Initiating WordPress Installation."

#Installing wordpress:
# STEP 1 - Configure Authentication Variables which are used below. You just run the below thing in SSH terminal to save it in .bashrc

export DBName='demodb'
export DBUser='demouser'
export DBPassword='4n1m41$4L1f3'
export DBRootPassword='4n1m41$4L1f3'


# STEP 2 - Install system software - including Web and DB
sudo apt update > /dev/null 2&>1
# Install Apache, MariaDB, PHP and required extensions
sudo apt install -y apache2 mariadb-server wget \
php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip > /dev/null 2&>1


# STEP 3 - Web and DB Servers Online - and set to startup
sudo systemctl enable apache2 > /dev/null 2&>1
sudo systemctl enable mariadb > /dev/null 2&>1
sudo systemctl start apache2 > /dev/null 2&>1
sudo systemctl start mariadb > /dev/null 2&>1

# STEP 4 - Set Mariadb Root Password
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DBRootPassword}';
CREATE DATABASE ${DBName};
CREATE USER '${DBUser}'@'localhost' IDENTIFIED BY '${DBPassword}';
GRANT ALL PRIVILEGES ON ${DBName}.* TO '${DBUser}'@'localhost';
FLUSH PRIVILEGES;
EOF



# STEP 5 - Install Wordpress
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html > /dev/null 2&>1
cd /var/www/html
sudo tar -zxvf latest.tar.gz > /dev/null 2&>1
sudo cp -rvf wordpress/* .
sudo rm -R wordpress
sudo rm latest.tar.gz

rm index.html
cp $path/wp-config.php /var/www/html/wp-config.php

echo
echo "WordPress got installed sucessfully. You can access at: http://$(curl -s ifconfig.me)/"
echo
