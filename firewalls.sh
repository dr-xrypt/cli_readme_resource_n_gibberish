#FIREWALLS INPLEMENTATION ON LINUX ( UFW / FIREWALL )

#USING UFW
#UFW IS DEFAULT COMMAND FOR FIREWALL SETUP (DEBIAN TESTED)
sudo ufw status #check firewall status and all rules
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable/disable
sudo ufw allow {port_number}
sudo ufw deny {port_number}
sudo ufw delete allow/deny {port_number}
sudo ufw app list

#IMPLEMENTING FIREWALL
sudo apt -y install firewalld
sudo firewall-cmd --get-default-zone
sudo firewall-cmd --get-zones
sudo firewall-cmd --list-all
sudo firewall-cmd --zone=public --permanent --list-services
sudo firewall-cmd --zone=public --permanent --list-ports
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --zone=public --permanent --add-port=5000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=25/tcp
sudo firewall-cmd --zone=public --permanent --add-port=465/tcp
sudo firewall-cmd --zone=public --permanent --add-port=587/tcp
sudo firewall-cmd --zone=public --permanent --add-port=4990-4999/udp
sudo firewall-cmd --zone=public --permanent --remove-port=4990-4999/udp
#25, 465, 587,
sudo firewall-cmd --reload
sudo systemctl restart network
sudo systemctl reload firewalld


#CHECK OPEN PORTS AND PROGRAMS RUNNING THEM
sudo lsof -n -P -i +c 13

sudo apt -y install netstat
sudo netstat -nlp

#RECOMMENDE SETTINGS FOR UFW
sudo ufw default deny incoming

# Allow incoming SSH connections (so you don't get locked out)
sudo ufw allow ssh
sudo ufw allow OpenSSH
sudo ufw allow 22

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp