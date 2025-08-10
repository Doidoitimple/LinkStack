FROM php:8.2-apache

# Install PHP dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite ssl

# Set working directory
WORKDIR /htdocs

# Copy app files into container
COPY . /htdocs

# Configure Apache to serve from /htdocs
RUN sed -i 's|/var/www/html|/htdocs|g' /etc/apache2/sites-available/000-default.conf \
 && echo "<Directory /htdocs>\n    AllowOverride All\n    Require all granted\n</Directory>" \
     >> /etc/apache2/apache2.conf

# Ensure Apache can read your files
RUN chown -R www-data:www-data /htdocs && chmod -R 755 /htdocs

EXPOSE 80
CMD ["apache2-foreground"]
