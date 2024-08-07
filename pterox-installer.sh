#!/bin/bash

# Step 1: Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Load NVM into the current shell session
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Step 2: Install Node.js version 16
nvm install 16

# Step 3: Install Yarn globally
npm install -g yarn

# Step 4: Initialize Yarn in the project
yarn

# Step 5: Add the specified packages
yarn add sanitize-html@2.7.3 @types/sanitize-html@2.6.2

# Step 6: Build the production environment
yarn build:production

# Step 7: Change to the Pterodactyl directory
cd /var/www/pterodactyl

# Step 8: Initialize Yarn in the Pterodactyl directory
yarn

# Step 9: Download the theme file
wget https://github.com/Nashit-panel/Pterodactyl-theme/raw/main/Update.zip

# Step 10: Add additional packages
yarn add @types/js-cookie js-cookie
yarn add @mui/material @emotion/react @emotion/styled
yarn add @mui/icons-material
yarn add @types/md5 md5
yarn add react-icons

# Step 11: Clear the view cache
php artisan view:clear

# Step 12: Change ownership of the Pterodactyl directory
chown -R www-data:www-data /var/www/pterodactyl/*

# Step 13: Bring the application up and run migrations
php artisan up
php artisan migrate --force
php artisan migrate --seed --force

# Step 14: Build the production environment again
yarn build:production

# Step 15: Clear the view and config cache
php artisan view:clear
php artisan config:clear
