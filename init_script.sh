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
cd /home/adminuser || exit
rm -rf *
git pull https://github.com/Ganesh-DevOps-Eng/php-postgres.git
cd php-postgres/ || exit

# Import database
PGPASSWORD=H@Sh1CoR3! psql -h tom-psqlserver.postgres.database.azure.com -U psqladmin@tom-psqlserver -d postgres -f db.sql

# Move files to web root
mv * /var/www/html
sudo chown www-data:www-data /var/www/html/*
sudo chmod 644 /var/www/html/*

# Configure Apache
echo "RewriteEngine On" | sudo tee -a /var/www/html/.htaccess
echo "RewriteRule ^health$ health.php [L]" | sudo tee -a /var/www/html/.htaccess

# Update Apache configuration to allow overrides
sudo bash -c 'cat <<EOT >> /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOT'

# Install Composer dependencies
sudo composer require vlucas/phpdotenv -y
sudo composer install -y

# Restart Apache
sudo systemctl restart apache2
