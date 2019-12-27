# mastodon-backup

Backup your essential Mastodon files!

> NOTE: This script requires that 'aws configure' has already been completed for the 'root' user

## Setting up automated backups

`Add this line to your crontab to ensure that the backups are being ran daily and a log is being generated`
0 3 * * * /opt/mastodon-backup/backup.sh > /opt/mastodon-backup/logs/backup.log 2>&1
`add this line to the root crontab to ensure that a weekly restart is occuring`
0 0 * * 0 /sbin/shutdown -r now

`add this line to the mastodon user's crontab to ensure that the media is being cleaned out daily and capped at 7 days`
@daily cd /home/mastodon/live && RAILS_ENV=production bin/tootctl media remove --days=7
