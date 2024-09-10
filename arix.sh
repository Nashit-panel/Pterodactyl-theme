#!/bin/bash

# Install NVM (Node Version Manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Run bash to load NVM changes
echo "Running bash to load NVM..."
bash

# Change to the Pterodactyl directory
cd /var/www/pterodactyl
# Install Node.js version 16 using NVM
echo "Installing Node.js version 16..."
nvm install 16

# Install Yarn globally
echo "Installing Yarn globally..."
npm install -g yarn

# Run Yarn command
echo "Running Yarn..."
yarn

# Go back to /var/www directory
cd /var/www
# Download the Arix theme zip file
echo "Downloading Arix theme..."
wget https://github.com/Nashit-panel/Pterodactyl-theme/raw/main/arix%20v1.2.zip

# Unzip the Arix theme
echo "Unzipping Arix theme..."
unzip 'arix v1.2.zip'

# Change back to the Pterodactyl directory
cd /var/www/pterodactyl
# Run the Arix installation via Artisan
echo "Running php artisan arix insta..."
php artisan arix install

echo "Script execution completed."
