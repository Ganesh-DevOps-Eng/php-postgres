#!/bin/bash
# Update and install packages
sudo apt update -y || true
sudo apt install apache2 -y || true
sudo apt install postgresql-client -y || true
sudo apt install php libapache2-mod-php php-pgsql -y || true
sudo apt install curl php-cli php-mbstring unzip -y || true
sudo apt install composer -y || true
mkdir -p /home/adminuser/project
cd /home/adminuser/project
# Clone the repository and setup application
git clone https://github.com/Ganesh-DevOps-Eng/php-postgres.git || true
sudo cp -R php-postgres /var/www/html
# Configure Apache
echo "RewriteEngine On" | sudo tee -a /var/www/html/php-postgres/.htaccess || true
echo "RewriteRule ^health$ health.php [L]" | sudo tee -a /var/www/html/php-postgres/.htaccess || true
# Set proper permissions
sudo chown -R www-data:www-data /var/www/html || true
sudo chmod -R 755 /var/www/html || true
sudo chmod 644 /var/www/html/php-postgres/.env || true
sudo chmod 644 /var/www/html/php-postgres/.htaccess || true
sudo rm -rf /var/www/html/index.html || true
# Update Apache configuration to allow overrides
sudo grep -q 'DocumentRoot /var/www/html$' /etc/apache2/sites-available/000-default.conf && sudo sed -i.bak 's|DocumentRoot /var/www/html$|DocumentRoot /var/www/html/php-postgres|' /etc/apache2/sites-available/000-default.conf
sudo bash -c 'cat <<EOT >> /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>' || true
cd /var/www/html/php-postgres || true
# Install Composer dependencies
  yes | sudo composer require vlucas/phpdotenv || true
  yes | sudo composer install || true
# Restart Apache
sudo chown -R www-data:www-data /var/www/html/php-postgres || true
sudo chmod -R 755 /var/www/html/php-postgres || true
sudo a2enmod rewrite || true
sudo systemctl restart apache2 || true
