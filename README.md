---
Description: Backup your essential Mastodon files to an S3 bucket!
Notes: This uses some simple scripts and cronjobs to create backups to a specified S3 bucket.
Author: HasHooves
ProjectPage: [Mastodon-Backup](https://github.com/HasHooves/mastodon-backup)
---

# mastodon-backup

Backup your essential Mastodon files to an S3 bucket!

This set of scripts was created to automate some of the basic maintenance that I would normally use to cleanup and make backups of my mastodon instance.

Feel free to use this backup script to help keep your instance clean too!

## Configure the AWS credentials

- Install the `AWS CLI`
  - > NOTE: This script requires that `aws configure` has already been completed for the `root` user before being ran for the first time
- Fill out the `example_config.sh` file with your information for AWS, and then move it to `config/config.sh`

## Prepare the script files

- Set the two files as executable:
```bash
chmod +x backup.sh
chmod +x config/config.sh
```

## Cronjobs

### Setting up automated backups

- Add this line to your `root` crontab to ensure that the backups are being ran `daily` and a log is being generated:

```bash
0 3 * * * /opt/mastodon-backup/backup.sh > /opt/mastodon-backup/logs/backup.log 2>&1
```

### Weekly restart of server

- Add this line to the `root` crontab to ensure that a `weekly` restart is occuring:

```bash
0 0 * * 0 /sbin/shutdown -r now
```

### Automatic media cleanup

- > NOTE: This should be set for the `mastodon` account and not set as the `root` user
- Add this line to the `mastodon` user's crontab to ensure that the media is being cleaned out daily and capped at `7` days:

```bash
@daily cd /home/mastodon/live && RAILS_ENV=production bin/tootctl media remove --days=7
```
