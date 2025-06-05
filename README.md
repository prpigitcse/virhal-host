# Apache Virtual Host Creation Script

This Bash script helps you quickly set up a new Apache virtual host on a Debian-based system (e.g., Ubuntu). It interactively prompts you for the domain name, document root, and email address (optional), then creates the configuration file, updates `/etc/hosts`, and reloads Apache.

---

## 🛠 Features

- Interactive input (no arguments required)
- Automatically creates document root if it doesn't exist
- Adds entry to `/etc/hosts`
- Uses `a2ensite` to enable the vhost
- Reloads Apache server

---

## 📋 Requirements

- Apache installed (`apache2`)
- Root privileges (to write to system directories and restart Apache)

---

## 🚀 How to Use

1. **Make the script executable** (if it’s not already):

   ```bash
   chmod +x vhost-create.sh
   ```

2. **Run the script with sudo**:

   ```bash
   sudo ./vh.sh
   ```

3. **Follow the prompts**:

   - Domain name (e.g., `example.local`)
   - Web root directory (e.g., `/var/www/example`)
   - ServerAdmin email (optional, default is `webmaster@localhost`)

4. **Open your browser** and visit:

   ```
   http://your-domain-name
   ```

   For example: `http://example.local`

---

## 📁 Sample Web Root Directory Structure

```
/var/www/example
├── index.html
```

Create an `index.html` file in the directory to test your virtual host.

---

## ⚠️ Notes

- This script is designed for local development environments.
- For live/production servers, consider adding SSL support using Let's Encrypt or self-signed certificates.

---

## 🧹 Undo / Remove a Virtual Host

If you want to disable or remove a virtual host:

```bash
sudo a2dissite your-domain.conf
sudo rm /etc/apache2/sites-available/your-domain.conf
sudo systemctl reload apache2
```

Also remove the entry from `/etc/hosts` if needed.

---

## 📝 License

This script is free to use, modify, and distribute.
