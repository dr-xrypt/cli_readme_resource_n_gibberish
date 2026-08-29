#APACHE ON LINUX

#IMPLEMENTING APACHE
#ALWAYS INSTALL AND CONFIGURE NGINX FIRST
sudo yum -y install httpd
sudo systemctl enable httpd && sudo systemctl start httpd
sudo systemctl status httpd.service
cd /var/www/
mkdir -p yourdomain.com/public_html
chown -R apache:apache /var/www/yourdomain.com/public_html
chmod -R 755 /var/www


sudo apt -y install apache2
sudo systemctl enable apache2 && sudo systemctl start apache2
sudo systemctl status apache2
mkdir /var/www/html/yourdomain.io
chown -R www-data:www-data /var/www/html/yourdomain.io
chmod -R 755 /var/www

nano /etc/httpd/conf/httpd.conf  [On RHEL/CentOS]
nano /etc/apache2/ports.conf     [On Debian/Ubuntu]APACHE ON LINUX

# [On Debian/Ubuntu] 
# When using apache as a server behind a proxy do these
# 1. Enable mod_remoteip
sudo a2enmod mod_remoteip
# 2. Locate the vhost conf for the domain , then beneath the Document Root Initiative add the following line
RemoteIPHeader X-Forwarded-For
# 3. search for LogFormat and replace all %h with %a
nano /etc/apache2/apache2.conf