FROM php:8.2-apache

RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev unzip git \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd mysqli pdo pdo_mysql

RUN a2enmod rewrite ssl

WORKDIR /htdocs

COPY . /htdocs

RUN sed -i 's|/var/www/html|/htdocs/public|g' /etc/apache2/sites-available/000-default.conf \
 && echo "<Directory /htdocs/public>\n    AllowOverride All\n    Require all granted\n</Directory>" >> /etc/apache2/apache2.conf

RUN chown -R www-data:www-data /htdocs/public && chmod -R 755 /htdocs/public

EXPOSE 80

CMD ["apache2-foreground"]
