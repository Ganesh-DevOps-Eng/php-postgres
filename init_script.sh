#!/bin/bash

# Update and install packages
sudo apt update -y
sudo apt install apache2 -y
sudo apt install postgresql-client -y
sudo apt install php libapache2-mod-php php-pgsql -y
sudo apt install curl php-cli php-mbstring unzip -y

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Clone the repository and setup application
mkdir -p /home/adminuser/project
cd /home/adminuser/project
git init
git pull https://github.com/Ganesh-DevOps-Eng/php-postgres.git
cd php-postgres/

# Import database
PGPASSWORD=H@Sh1CoR3! psql -h tom-psqlserver.postgres.database.azure.com -U psqladmin@tom-psqlserver -d postgres -f db.sql

# Move files to web root
mv * /var/www/html

# Configure Apache
echo "RewriteEngine On" | sudo tee -a /var/www/html/.htaccess
echo "RewriteRule ^health$ health.php [L]" | sudo tee -a /var/www/html/.htaccess
sudo chown www-data:www-data /var/www/html/*
sudo chmod 644 /var/www/html/*

# Update Apache configuration to allow overrides
sudo bash -c 'cat <<EOT >> /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>'

# Install Composer dependencies
yes | sudo composer require vlucas/phpdotenv
yes | sudo composer install

# Restart Apache
sudo a2enmod rewrite
sudo systemctl restart apache2
