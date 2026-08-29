mkdir /etc/wal-g
sudo nano /etc/wal-g/wal-g.yaml
'
WALG_S3_PREFIX: s3://bucket-name/backups/db
AWS_ACCESS_KEY_ID: your_access_key
AWS_SECRET_ACCESS_KEY: your_secret_key
AWS_REGION: aws_region
AWS_ENDPOINT: https://s3.eu-north-1.amazonaws.com # Not Neccessary to set except when using other services like r2

# Required for WAL uploads + purging
PGDATA: /var/lib/postgresql/16/main

# Optional tuning
WALG_UPLOAD_CONCURRENCY: 4    # Parallel upload parts
WALG_COMPRESSION_METHOD: lz4  # Faster than gzip, efficient
'
#==============================================COPY AND PASTE THIS WHOLE TAB TO INSTALL WAL-g FOR UBUNTU 22 or 24==============
# INSTALL & CONFIGURE WAL-G FOR POSTGRES
cd /usr/local/bin

# clear wal-g (Remove the wrong binary if downloaded wrong wal-g version/binary)
rm -f /usr/local/bin/wal-g

# Download correct PostgreSQL build
wget https://github.com/wal-g/wal-g/releases/download/v3.0.7/wal-g-pg-ubuntu-22.04-amd64.tar.gz

# Extract & install
tar -xvzf wal-g-pg-ubuntu-22.04-amd64.tar.gz
mv wal-g-pg-ubuntu-22.04-amd64 wal-g
chmod +x wal-g

# Test to see if exists
wal-g --version
echo "DONE"
#===============================================END======================================================

sudo nano /etc/postgresql/16/main/postgresql.conf
# locate this line below
# Enable WAL archiving

# add this

"
max_wal_size = 1GB
min_wal_size = 80MB
wal_keep_size = 0

"
# and

"
archive_mode = on
archive_command = 'wal-g --config=/etc/wal-g/wal-g.yaml wal-push %p'
archive_timeout = 60

# Configure restore (for disaster recovery)
restore_command = 'wal-g --config=/etc/wal-g/wal-g.yaml wal-fetch %f %p'
"
sudo systemctl restart postgresql

sudo chown postgres:postgres /etc/wal-g/wal-g.yaml # Give db trusted postgres user right to file
sudo chmod 600 /etc/wal-g/wal-g.yaml # secure file
sudo touch /var/log/wal-g-backup.log # Create log file
sudo chown postgres:postgres /var/log/wal-g-backup.log # Give postgres user permision to it

# manually backup
sudo -u postgres wal-g --config /etc/wal-g/wal-g.yaml backup-push /var/lib/postgresql/16/main

# set automatic scheduled backup with cron for trusted postgres user
sudo crontab -u postgres -e
"
# Daily base backup at 2 AM
0 2 * * *  /usr/local/bin/wal-g --config /etc/wal-g/wal-g.yaml backup-push /var/lib/postgresql/16/main >> /var/log/wal-g-backup.log 2>&1

# Cleanup (keep last 7 full backups)
30 2 * * * /usr/local/bin/wal-g --config /etc/wal-g/wal-g.yaml delete retain FIND_FULL 3 --confirm >> /var/log/wal-g-backup.log 2>&1
50 2 * * * /usr/local/bin/wal-g --config /etc/wal-g/wal-g.yaml delete garbage --confirm >> /var/log/wal-g-backup.log 2>&1
"

# check all backup list
sudo -u postgres wal-g --config /etc/wal-g/wal-g.yaml backup-list


sudo nano /etc/logrotate.d/wal-g
"
/var/log/wal-g-backup.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    create 640 postgres adm
}
"

# RESTORE ; THIS RESTORES THE LATEST BACKUP FROM DB BACKUP STORAGE #TEST IN STAGING ENVIRONMENT
# Stop postgres
sudo systemctl stop postgresql

# Clear data dir (CAREFUL!)
sudo rm -rf /var/lib/postgresql/16/main/*

# Restore latest backup
sudo -u postgres wal-g --config /etc/wal-g/wal-g.yaml backup-fetch /var/lib/postgresql/16/main LATEST

# Start postgres
sudo systemctl start postgresql
