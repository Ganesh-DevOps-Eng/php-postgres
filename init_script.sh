#!/bin/bash
curl -sS https://getcomposer.org/installer
sudo mv composer.phar /usr/local/bin/composer
set -e

# Update and install packages
sudo apt update -y || true
sudo apt install apache2 -y || true
sudo apt install postgresql-client -y || true
sudo apt install php libapache2-mod-php php-pgsql -y || true
sudo apt install curl php-cli php-mbstring unzip -y || true

# Clone the repository and setup application
mkdir -p /home/adminuser/project || true
cd /home/adminuser/project || true
git init || true
git pull https://github.com/Ganesh-DevOps-Eng/php-postgres.git || true

# Import database if it doesn't already exist
DB_EXISTS=$(PGPASSWORD=H@Sh1CoR3! psql -h tom-psqlserver.postgres.database.azure.com -U psqladmin@tom-psqlserver -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='mydb'")
if [ -z "$DB_EXISTS" ]; then
  PGPASSWORD=H@Sh1CoR3! psql -h tom-psqlserver.postgres.database.azure.com -U psqladmin@tom-psqlserver -d postgres -f db.sql || true
fi

# Create a symbolic link
sudo ln -s /home/adminuser/project /var/www/html/ || true

# Configure Apache
echo "RewriteEngine On" | sudo tee -a /var/www/html/.htaccess || true
echo "RewriteRule ^health$ health.php [L]" | sudo tee -a /var/www/html/.htaccess || true

# Set proper permissions
sudo chown -R www-data:www-data /home/adminuser/project/ || true
sudo chmod -R 755 /home/adminuser/project/ || true
sudo chmod 644 /home/adminuser/project/.env || true

# Update Apache configuration to allow overrides
sudo bash -c 'cat <<EOT >> /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>' || true

# Install Composer dependencies
yes | sudo composer require vlucas/phpdotenv || true
yes | sudo composer install || true

# Restart Apache
sudo a2enmod rewrite || true
sudo systemctl restart apache2 || true
