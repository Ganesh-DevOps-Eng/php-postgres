#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
# Update and install packages
sudo apt update -y || true
sudo apt install apache2 -y || true
sudo apt install postgresql-client -y || true
sudo apt install php libapache2-mod-php php-pgsql -y || true
sudo apt install curl php-cli php-mbstring unzip -y || true
sudo apt install composer -y || true
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

# Create a symbolic link, overwriting any existing link or directory
if [ -L /var/www/html ]; then
  sudo rm /var/www/html
elif [ -d /var/www/html ]; then
  sudo rm -rf /var/www/html
fi

sudo ln -s /home/adminuser/project/* /var/www/html || true
sudo ln -s /home/adminuser/project/.* /var/www/html || true


# Configure Apache
echo "RewriteEngine On" | sudo tee -a /var/www/html/.htaccess || true
echo "RewriteRule ^health$ health.php [L]" | sudo tee -a /var/www/html/.htaccess || true

# Set proper permissions
sudo chown -R www-data:www-data /home/adminuser/project/ || true
sudo chmod -R 755 /home/adminuser/project/ || true
sudo mv /home/adminuser/project/.env /var/www/html/ || true
sudo rm -rf /var/www/html/index.html || true
# Update Apache configuration to allow overrides
sudo bash -c 'cat <<EOT >> /etc/apache2/sites-available/000-default.conf
<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>' || true

# Install Composer dependencies
if command -v composer &> /dev/null; then
  yes | sudo composer require vlucas/phpdotenv || true
  yes | sudo composer install || true
else
  echo "Composer is not installed correctly. Cannot install dependencies."
  exit 1
fi


# Change ownership of composer files to www-data
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

sudo a2enmod rewrite || true
sudo systemctl restart apache2 || true
