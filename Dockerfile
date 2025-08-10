# Use official PHP 8.2 with Apache
FROM php:8.2-apache

# Install required PHP extensions for LinkStack
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite ssl

# Set working directory inside container
WORKDIR /htdocs

# Copy your LinkStack source code into the container
COPY . /htdocs

# Change Apache DocumentRoot to LinkStack's public folder
RUN sed -i 's|/var/www/html|/htdocs/public|g' /etc/apache2/sites-available/000-default.conf \
    && echo "<Directory /htdocs/public>\n    AllowOverride All\n    Require all granted\n</Directory>" >> /etc/apache2/apache2.conf

# Set permissions for Apache user
RUN chown -R www-data:www-data /htdocs && chmod -R 755 /htdocs

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
