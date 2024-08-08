sudo apt install apache2
sudo apt install postgresql-client
sudo apt install php libapache2-mod-php php-pgsql
sudo apt install curl php-cli php-mbstring unzip
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

#Navigate to your project directory and run:
cd /var/www/html/
composer require vlucas/phpdotenv

sudo chown www-data:www-data /var/www/html/index.php
sudo chown www-data:www-data /var/www/html/.env
sudo chmod 644 /var/www/html/index.php
sudo chmod 644 /var/www/html/.env

sudo composer install




Create the .env File

DB_HOST=tom-psqlserver.postgres.database.azure.com
DB_PORT=5432
DB_NAME=mydb
DB_USER=psqladmin@tom-psqlserver
DB_PASS=H@Sh1CoR3!


PGPASSWORD=H@Sh1CoR3! psql -h tom-psqlserver.postgres.database.azure.com -U psqladmin@tom-psqlserver -d postgres -f db.sql

# loadblance unhealthy soluation 
sudo vim /var/www/html/.htaccess

RewriteEngine On
RewriteRule ^health$ health.php [L]

# update file 
sudo nano /etc/apache2/sites-available/000-default.conf

<Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

sudo systemctl restart apache2




