# Use an official PHP runtime as a parent image
FROM php:8.2-cli as builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    npm

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql gd mbstring exif pcntl bcmath xml

COPY composer.json composer.json
COPY composer.lock composer.lock

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-plugins --no-scripts
RUN composer -v



# Install PHP dependencies

RUN php artisan package:discover --ansi 
RUN cp .env.example .env
RUN php artisan key:generate
RUN sed -i -e 's/DB_PASSWORD=homestead/DB_PASSWORD=password/g' .env
RUN sed -i -e 's/DB_DATABASE=homestead/DB_DATABASE=velflix/g' .env
RUN sed -i -e 's/DB_HOST=homestead/DB_HOST=34.94.240.81/g' .env
RUN sed -i -e 's/DB_USERNAME=homestead/DB_USERNAME=velflix/g' .env
RUN sed -i -e 's/TMDB_TOKEN=homestead/TMDB_TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDQ0ZmJmMjBlZTQ1Y2JmMDJkYTQ5Zjk4NDk3NTZiOSIsInN1YiI6IjY2M2JiOWQzM2ZiZmVjZDVkNzA1ZDQwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.A0xaHvjWf1ykSVJ7ZL170mJcXfvs4bu17oCHuDcZ9Q4/g' .env

# Copy the rest of the application code
COPY . .

RUN npm install && npm run build
RUN php artisan migrate
RUN php artisan db:seed

RUN chown -R www-data storage
RUN chown -R www-data bootstrap/cache



FROM  nginx:alpine-slim
# RUN apt-get update && apt-get install -y curl net-tools iputils-ping
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder . /usr/share/nginx/html

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
