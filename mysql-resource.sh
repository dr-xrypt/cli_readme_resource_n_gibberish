#MYSQL ON LINUX

#IMPLEMENTING MYSQL ON DEBIAN

sudo apt -y install mysql-server
mysql --version
sudo systemctl start mysql
sudo systemctl enable mysql
sudo systemctl status mysql
mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'dev-test-service-787gfydyfudyf';
sudo mysql_secure_installation
#all y
mysql -u root -p

# SQL IN OPERATION
# SEE above to set or change password

CREATE DATABASE myprojectDB;

# ALWAYS CREATE USER FOR EACH APP. DON\T GIVE A SINGLE APP ADMIN PRIVILEDGES
CREATE USER 'myprojectusername'@'host' IDENTIFIED BY 'password'; #METHID 3

GRANT ALL PRIVILEGES ON myprojectDB.* TO 'myprojectusername'@'host';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'myprojectusername'@'host';

USE myprojectDB;

# FILL UP TABLE STRUCTURE
# if for testing and table structure not available
CREATE TABLE test_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
# if table structure is available make sure you are in sql CLI to run the next command
# source sqlfilepath;
source \home\user\pro\test.sql;


https://www.mysqltutorial.org/