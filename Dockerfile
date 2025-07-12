FROM php:8.2-fpm

# Arguments for user and group ID
ARG UID=1000
ARG GID=1000

# Install system packages
RUN apt-get update && apt-get install -y \
    git curl unzip zip libzip-dev libonig-dev libxml2-dev libpng-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# Create group and user with given UID and GID
RUN groupadd -g ${GID} appgroup \
    && useradd -u ${UID} -g appgroup -m appuser

# Use this user in the container
USER appuser

# Set default working folder in the container
WORKDIR /var/www

# Copy all project files to the container
COPY --chown=appuser:appgroup . .

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
