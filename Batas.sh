#!/bin/bash

# Proxy Installer Script for VPS (Squid)
# Tested on Ubuntu/Debian

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root${NC}"
  exit 1
fi

# Update and install required packages
echo -e "${GREEN}Updating package list...${NC}"
apt-get update -y
echo -e "${GREEN}Installing Squid proxy...${NC}"
apt-get install squid -y

# Backup the default Squid configuration
echo -e "${GREEN}Backing up Squid configuration...${NC}"
cp /etc/squid/squid.conf /etc/squid/squid.conf.backup

# Create new Squid configuration
echo -e "${GREEN}Configuring Squid proxy...${NC}"
cat <<EOL > /etc/squid/squid.conf
http_port 3128
acl allowed_ports port 80 443
acl localnet src 0.0.0.0/0  # Allow all IPs to use the proxy (be cautious)
http_access allow localnet
http_access deny all
cache deny all
forwarded_for off
via off
request_header_access Allow allow all
request_header_access Authorization allow all
request_header_access WWW-Authenticate allow all
request_header_access Proxy-Authorization allow all
request_header_access Proxy-Authenticate allow all
request_header_access Cache-Control allow all
request_header_access Content-Encoding allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Expires allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all
request_header_access Location allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Connection allow all
request_header_access All deny all
EOL

# Enable Squid service to start on boot and restart the service
echo -e "${GREEN}Enabling and restarting Squid service...${NC}"
systemctl enable squid
systemctl restart squid

# Open firewall ports if UFW is installed
if command -v ufw &> /dev/null; then
  echo -e "${GREEN}Opening firewall port 3128...${NC}"
  ufw allow 3128/tcp
fi

# Display installation success message and proxy details
echo -e "${GREEN}Squid proxy has been installed and configured.${NC}"
echo -e "${GREEN}Your proxy is available on port 3128.${NC}"
echo -e "${GREEN}Use your server's IP address and port 3128 for the proxy.${NC}"

