#DJANGO ON LINUX
#IMPLEMENTING DJANGO PY
sudo apt install python3-dev build-essential libpq-dev

sudo adduser projectuser_name

sudo usermod -aG sudo <projectuser_name> #give user sudo priviledges

sudo -i -u projectuser_name

python -m venv {venvfoldername} - windows
{venvfoldername}\scripts\activate - windows

sudo apt install python3-venv
python3 -m venv {venvfoldername}
source {venvfoldername}/bin/activate - linux

deactivate

#DEVELOPMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# All apps are to be located in var/www/ director
cd /var/www/
mkdir projectname

sudo chown -R projectuser_name:www-data /var/www/projectname
sudo -i -u projectuser_name # ALWAYS MANAGE APPS AS PROJECT USER AND NOT AS ROOT

cd projectname
mkdir django_project_name
mkdir django_project_name/logs/ #created because its the necessary directory that logs will be saved in
cd django_project_name
# final link tree should look like /var/www/projectname/djangoprojectname
#install venv and create
pip install virtualenv
python -m virtualenv <venv_name>
python3 -m venv <name_of_venv_environment>
source <name_of_venv_environment>/bin/activate

#Upload website files to this pwd (present working directory) or git clone

#requirements.txt file must be available to the folder 
pip install -r "requirements.txt"

python manage.py makemigrations
python manage.py collectstatic --noinput
python manage.py migrate
python manage.py createsuperuser

# USING GUNICORN (NO DOCKER)
pip install gunicorn

# TEST FIRST
gunicorn --workers 3 myproject.wsgi:application

# after TEST make gunicorn a service so it can restart after system reboot
sudo nano /etc/systemd/system/projectname-prod-gunicorn.service
#add and edit the following content accordingly without the 
"
[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=lenicleadmin
Group=www-data
WorkingDirectory=/var/www/lenicle/app
ExecStart=/var/www/lenicle/venv/bin/gunicorn --workers 9 --bind unix:/var/www/lenicle/app/app.sock app.wsgi:application

[Install]
WantedBy=multi-user.target
"
# to get workers count do 2 * (vps core count) + 1
# Gunicorn has settings like --max-requests or --max-requests-jitter to automatically restart workers after a certain number of requests. this will help clear vps memory and reduce lagging

sudo systemctl start projectname-prod-gunicorn
sudo systemctl enable projectname-prod-gunicorn

# USING GUNICORN (WITH DOCKER)
# go back to sudo USER


# go back to app user


# CONFIGURE NGINX

sudo nano /etc/nginx/sites-available/myproject

"
server {
    listen 80;
    server_name staging.api.lenicle.com;
	client_max_body_size 100M;
	
    access_log /var/www/lenicle-staging/logs/access.log;
    error_log  /var/www/lenicle-staging/logs/error.log;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /resource/ {
        alias /var/www/lenicle-staging/app/static/;
    }

    location /media/ {
        alias /var/www/lenicle-staging/app/media/;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/var/www/lenicle-staging/app/app.sock;
    }
}
"
sudo ln -s /etc/nginx/sites-available/lenicle-staging /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx


#GIVE NON SUDO USER ACCESS TO ADMIN COMMANDS
sudo visudo
# add the next lines
#GIVE NON SUDO USER ACCESS TO ADMIN COMMANDS
lenicledev ALL=(ALL) NOPASSWD: /bin/systemctl restart gunicorn_lenicle_staging
lenicledev ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx