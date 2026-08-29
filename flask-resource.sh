#FLASK ON LINUX

#IMPLEMENTING FLASK PY


pip install virtualenv

python -m venv {venvfoldername} - windows
{venvfoldername}\scripts\activate - windows

virtualenv virtualenv_name - linux
source {venvfoldername}/bin/activate - linux

deactivate

sudo apt install python3-dev default-libmysqlclient-dev build-essential

Cm%yaBM8Ga

#DEVELOPMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# All apps are to be located in var/www/ director
cd /var/www/
mkdir flasks_app
cd flasks_app
mkdir <flask_project_name>
mkdir <flask_project_name>/logs/ #created because its the necessary directory that logs will be saved in
cd <flask_project_name>
#install venv and create
pip install virtualenv
python -m virtualenv <venv_name>
python3 -m venv <name_of_venv_environment>
source <name_of_venv_environment>/bin/activate

#Upload website files to this pwd (present working directory)
#requirements.txt file must be available to the folder 
pip install -r "requirements.txt"
	
#Set the FLASK_APP environment variable
export FLASK_APP=app.py

#PRODUCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#USING APACHE
sudo apt install libapache2-mod-wsgi-py3

sudo nano <flask_project_name>.wsgi
"
import sys
sys.path.insert(0,'/var/www/flasks_app/<flask_project_name>')

from app import app as application"

touch /etc/apache2/sites-available/<flask_project_name>.conf
"
<VirtualHost *:80>
	ServerName yourdomain.com
	DocumentRoot /var/www/flasks_app/<flask_project_name>/

	WSGIDaemonProcess app user=www-data group=www-data threads=5 python-home=/var/www/flasks_app/<flask_project_name>/<name_of_venv_environment>
	WSGIScriptAlias / /var/www/flasks_app/<flask_project_name>/<flask_project_name>.wsgi
	
	ErrorLog /var/www/flasks_app/<flask_project_name>/logs/error.log
	CustomLog /var/www/flasks_app/<flask_project_name>/logs/access.log combined
	#{APACHE_LOG_DIR} is the default log dir for apache

	<Directory /var/www/flasks_app/<flask_project_name>>
		WSGIProcessGroup app
		WSGIApplicationGroup %{GLOBAL}
		Order deny,allow
		Require all granted
	</Directory>
</VirtualHost>"

sudo a2ensite <flask_project_name>.conf
apachectl -t
sudo systemctl reload apache

# USING GUNICORN
sudo apt install gunicorn
gunicorn --workers=3 app:app --daemon
sudo pkill -f gunicorn3