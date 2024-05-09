# Base image
FROM php:8.0-fpm

# Set working directory
WORKDIR /var/www/html

# Copy composer.json and vendor directory (if exists)
COPY composer.json composer.lock ./

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    libc6-dbg \
    jq \
    libssl-dev \
    zlib1g-dev \
    unzip \
    gdebi-core \
    && docker-php-ext-install -i pdo_mysql mysqli bcmath opcache xml soap xsl
RUN composer install 

# Copy application code
COPY . .

# Expose Laravel application port
EXPOSE 80

# Run php-fpm process
CMD ["php-fpm"]
