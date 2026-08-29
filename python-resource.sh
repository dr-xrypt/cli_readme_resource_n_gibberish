#PY ON LINUX

#INSTALLING PY
wget https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tgz
# For apt-based systems (like Debian, Ubuntu, and Mint)
sudo apt install make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
       libncurses5-dev libncursesw5-dev xz-utils tk-dev -y

# For yum-based systems (like CentOS)
sudo yum -y groupinstall "Development Tools"
sudo yum -y install gcc openssl-devel bzip2-devel libffi-devel

tar -cf
tar -tvf
tar -xf
tar -xvf
tar xvf Python-3.8.16.tgz
cd Python-3.8.16
./configure --enable-optimizations --with-ensurepip=install
make -j 8
sudo make altinstall


sudo yum install python2/python3 -y
sudo yum install python-pip

sudo apt install python2/python3 -y
sudo apt install python3-pip -y

https://www.w3schools.com/python/python_ref_functions.asp