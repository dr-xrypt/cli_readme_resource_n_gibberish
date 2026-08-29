#CELERY AND REDIS SETUP

sudo apt update
sudo apt install redis-server
sudo systemctl enable redis
sudo systemctl start redis
sudo systemctl status redis

redis-cli ping




# using CELERY in python django
pip install celery

# create celery.py in project main folder and put
"""
from __future__ import absolute_import
import os
from celery import Celery

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myproject.settings")

app = Celery("myproject")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()
"""

# In __init__.py in project main folder add
"""
from __future__ import absolute_import, unicode_literals
from .celery import app as celery_app

__all__ = ("celery_app",)
"""

# In settings.py add to bottom
"""
CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_TIMEZONE = "UTC"
"""

celery -A your_project_name worker --loglevel=info


sudo nano /etc/systemd/system/celery-your_project_name-worker.service
"""
[Unit]
Description=Celery Worker Service
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/path/to/your/project
ExecStart=/path/to/venv/bin/celery -A your_project_name worker --loglevel=info
Restart=always

[Install]
WantedBy=multi-user.target
"""

# if using celery beat for scheduled tasks
celery -A your_project_name beat --loglevel=info

sudo nano /etc/systemd/system/celery-your_project_name-beat.service
"""
[Unit]
Description=Celery Beat Service
After=network.target

[Service]
Type=simple
User=youruser
WorkingDirectory=/path/to/your/project
ExecStart=/path/to/venv/bin/celery -A your_project_name beat --loglevel=info --scheduler django_celery_beat.schedulers:DatabaseScheduler
Restart=always

[Install]
WantedBy=multi-user.target
"""