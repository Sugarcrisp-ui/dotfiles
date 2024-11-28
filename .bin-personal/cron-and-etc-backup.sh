#!/bin/bash

# Backup cron jobs
rsync -avz --delete /var/spool/cron/ /run/media/brett/backup/cron/

# Backup rc.local
rsync -avz --delete /etc/rc.local /run/media/brett/backup/etc/

echo "Backup completed at $(date)"
