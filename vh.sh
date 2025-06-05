#!/bin/bash
set -e

# Prompt for domain name
read -p "Enter the domain name (e.g., example.com): " name
if [[ -z "$name" ]]; then
  echo "Domain name cannot be empty."
  exit 1
fi

# Prompt for web root directory
read -p "Enter the web root directory (e.g., /var/www/example): " WEB_ROOT_DIR
if [[ -z "$WEB_ROOT_DIR" ]]; then
  echo "Web root directory cannot be empty."
  exit 1
fi

# Prompt for email with default
read -p "Enter ServerAdmin email [webmaster@localhost]: " email
email=${email:-webmaster@localhost}

sitesAvailable='/etc/apache2/sites-available'
vhostFile="$sitesAvailable/$name.conf"

echo "Creating a virtual host for $name with web root $WEB_ROOT_DIR"

# Create the document root directory if it doesn't exist
if [ ! -d "$WEB_ROOT_DIR" ]; then
  echo "Creating web root directory at $WEB_ROOT_DIR"
  mkdir -p "$WEB_ROOT_DIR"
  chown -R www-data:www-data "$WEB_ROOT_DIR"
  chmod -R 755 "$WEB_ROOT_DIR"
fi

# Create the virtual host configuration
cat <<EOF > "$vhostFile"
<VirtualHost *:80>
    ServerAdmin $email
    ServerName $name
    ServerAlias www.$name
    DocumentRoot $WEB_ROOT_DIR

    <Directory $WEB_ROOT_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$name-error.log
    CustomLog \${APACHE_LOG_DIR}/$name-access.log combined
</VirtualHost>
EOF

echo "Virtual host file created at $vhostFile"

# Add domain to /etc/hosts if not already present
if ! grep -q "$name" /etc/hosts; then
  echo "127.0.0.1 $name" >> /etc/hosts
  echo "Added $name to /etc/hosts"
fi

# Enable the site and reload Apache
a2ensite "$name.conf"
systemctl reload apache2

echo "Done. Visit http://$name in your browser."
