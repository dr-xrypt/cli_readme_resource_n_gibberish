sudo reboot now
sudo shutdown -r
sudo netstat -tulnp # open ports
systemctl start|stop|restart|reload|enable|disable lscpd

141.98.168.75|djDJSK($#{NJDS39024jdsjk>jsds33

/ is root directory
~ is home directory
#FRESH VPS SHELL
passwd #change vps user password to
(Centos:yum;Debian:apt)
sudo yum install epel-release && sudo yum update
sudo apt/yum update
sudo apt/yum upgrade
sudo apt/yum install curl wget -y
sudo apt/yum remove python2/python3 -y
sudo apt/yum install nano -y


# IMPORTANT SUDO APT COMMANDS
#To uninstall other components, use the following command, replacing package-name with the name of the package of the component you want to remove:
sudo apt remove package-name
#By default, apt remove retains any local configuration files that were created since installation. If you don’t want to save the configuration files for later use
sudo apt purge package-name
sudo apt remove --purge package-name
#Then, remove any other software that was installed automatically with the package:
sudo apt autoremove
#To see a list of packages you have installed from A package APT repository, use the following command:
dpkg -l | grep package-name | grep ii


#Check processes 
ps -aux
ps -e

sudo adduser username

#WORKING W FILES AND DIRS
cat #read file content
pwd #print the current working directory (pwd)
cd
mkdir
ls -a -l #list files
rm -r #delete files (rm ) and directories (rm -r)
cp -r #copy files (cp) and directories (cp -r) to another directory
ln -s {source-file|folder} {destination-folder} #symbolic link (shortcut): source must be relative to destination so that the created link at destination folder can find it when called (ln for hard linking ln -s for symbolic linking)
unlink #deletes files too
mv (Move files or rename files)
touch #Create new file
alias rm='/usr/bin/rm -i'
#< for redirecting input to a source other than the keyboard
#> for redirecting output to destination other than the screen
#>> for doing the same, but appending rather than overwriting
#| for piping output from one command to the input of another