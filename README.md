# mastodon-backup

Backup your essential Mastodon files!

> NOTE: This script requires that 'aws configure' has already been completed for the 'root' user

## Setting up automated backups and logs

`Add this line to your crontab to ensure that the backups are being ran daily and a log is being generated`
0 3 * * * /opt/mastodon-backup/backup.sh > /opt/mastodon-backup/logs/backup.log 2>&1
