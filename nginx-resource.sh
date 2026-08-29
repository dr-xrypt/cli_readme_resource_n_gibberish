#NGINX ON LINUX

#IMPLEMENTING NGINX
sudo yum -y install nginx
sudo apt -y install nginx #DEBIAN/UBUNTU

sudo systemctl start nginx #start Nginx
sudo systemctl status nginx #check Nginx status
sudo systemctl restart nginx #check Nginx restart
sudo systemctl reload nginx #check Nginx restart (Always reload after changing or making configurations)
/etc/nginx/ #this is the directory to everything linux
/etc/nginx/conf.d/default.conf #the default configuration file
nginx -t #to test if nginx configuration syntax is ok

#IMPLEMENTING LET'S ENCRYPT CERTBOT
sudo apt install certbot python3-certbot-nginx|python3-certbot-apache
sudo certbot --apache -d example.com -d www.example.com
sudo certbot --nginx -d example.com -d www.example.com
sudo systemctl enable certbot.timer
sudo systemctl status certbot.timer
sudo certbot renew --dry-run

sudo nano /etc/nginx/sites-available/default
# nginx configuration
"server {
    listen 80 default_server;
    listen 443 ssl default_server;
    ssl_certificate /etc/ssl/default/default.crt;
    ssl_certificate_key /etc/ssl/default/default.key;
	access_log off;
	log_not_found off;

    server_name '';
    return 444;
}"
#COnfigure ssl for default
sudo mkdir -p /etc/ssl/default
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/default/default.key \
  -out /etc/ssl/default/default.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=default.local"
  

sudo nano /etc/nginx/sites-available/myproject
"server {
    listen 80;
    server_name xryptic.dev;
	client_max_body_size 100M;
	
	
    access_log /var/log/nginx/example.access.log;
    error_log  /var/log/nginx/example.error.log;

    location /resource/ {
		# 1. for relaying importat static files 
        alias /var/www/app/static/;

        # 2. **CRITICAL FOR CACHING**: Tells the client and Cloudflare to cache the file.
        expires 1y;

        # 3. Optional: Configure access and logging
        access_log off;
        log_not_found off;
	}
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/xryptic.dev/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/xryptic.dev/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}"

sudo ln -s /etc/nginx/sites-available/myproject /etc/nginx/sites-enabled/

sudo systemctl restart nginx #check Nginx restart


# 🔧 Option 1: Hide server info using server_tokens off;
# Edit your Nginx config (nginx.conf or included file):
sudo nano /etc/nginx/nginx.conf
#Find the http block (it looks like this):
"http {
    ...
}"
# add this
server_tokens off;