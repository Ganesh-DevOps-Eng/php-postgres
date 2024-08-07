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

DB_HOST=your_postgresql_host
DB_PORT=5432
DB_NAME=mydb
DB_USER=your_pgsql_username
DB_PASS=your_pgsql_password
