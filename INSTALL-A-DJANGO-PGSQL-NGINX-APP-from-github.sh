#!/bin/bash

# Function to check if a package is already installed
is_package_installed() {
    dpkg -l | grep -i "$1" > /dev/null 2>&1
    return $?
}

# Exit script on any command failure
set -e

echo "Starting server setup..."

# Collect input from the user for some variables
read -p "Enter the PostgreSQL database name: " db_name
read -p "Enter the PostgreSQL user name: " db_user
read -sp "Enter the PostgreSQL user password: " db_password
echo ""
read -p "Enter the Git repository URL for your Django project: " git_repo_url
read -p "Enter your domain name (e.g., example.com): " domain_name

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Step 2: Install required packages
echo "Installing necessary packages..."

# Check if Python 3, pip, and virtualenv are installed
if ! is_package_installed python3; then
    sudo apt install -y python3 python3-pip python3-venv git
else
    echo "Python 3 is already installed."
fi

# Check if PostgreSQL is installed
if ! is_package_installed postgresql; then
    sudo apt install -y postgresql postgresql-contrib
else
    echo "PostgreSQL is already installed."
fi

# Check if Nginx is installed
if ! is_package_installed nginx; then
    sudo apt install -y nginx
else
    echo "Nginx is already installed."
fi

# Step 3: Set up PostgreSQL
echo "Setting up PostgreSQL..."

# Create PostgreSQL database and user using the collected values
sudo -u postgres psql <<EOF
CREATE DATABASE $db_name;
CREATE USER $db_user WITH PASSWORD '$db_password';
GRANT ALL PRIVILEGES ON DATABASE $db_name TO $db_user;
EOF

# Step 4: Clone your project from Git
echo "Cloning project repository..."

# Set up a directory for your project in /var/www/
sudo mkdir -p /var/www/
sudo chown $USER:$USER /var/www/
cd /var/www/
git clone $git_repo_url myproject

# Step 5: Set up Python environment
echo "Setting up Python virtual environment..."

cd /var/www/myproject
python3 -m venv venv
source venv/bin/activate

# Install required Python packages (including Gunicorn)
pip install -r requirements.txt

# Install Gunicorn via pip within the virtual environment
pip install gunicorn

# Step 6: Configure Gunicorn
echo "Configuring Gunicorn service..."

# Create a Gunicorn service file for systemd
sudo bash -c 'cat > /etc/systemd/system/gunicorn.service << EOF
[Unit]
Description=gunicorn daemon for Django project
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/var/www/myproject
ExecStart=/var/www/myproject/venv/bin/gunicorn --workers 3 --bind unix:/var/www/myproject/myproject.sock myproject.wsgi:application

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd to apply changes
sudo systemctl daemon-reload

# Enable and start Gunicorn service
sudo systemctl enable gunicorn
sudo systemctl start gunicorn

# Step 7: Configure Nginx
echo "Configuring Nginx..."

# Create a Nginx configuration file
sudo bash -c 'cat > /etc/nginx/sites-available/myproject << EOF
server {
    listen 80;
    server_name $domain_name;

    location / {
        proxy_pass http://unix:/var/www/myproject/myproject.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF'

# Create a symlink to enable the site
sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled/

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx to apply the changes
sudo systemctl restart nginx

# Step 8: Set up firewall rules (Optional)
echo "Setting up firewall..."

# Allow traffic on HTTP (80), HTTPS (443), and SSH (22)
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable

# Step 9: Create a new user for the project
echo "Creating new user for the project..."

# Create a new user with the username as the project directory name + admin (e.g., myprojectadmin)
new_user="myprojectadmin"
sudo useradd -m -s /bin/bash $new_user

# Set a password for the new user
echo "Setting password for user $new_user..."
sudo passwd $new_user

# Step 10: Change ownership of the project directory to the new user
echo "Changing ownership of the project directory to $new_user..."

# Change ownership of the project directory to the new user
sudo chown -R $new_user:$new_user /var/www/myproject

echo "Server setup complete!"
