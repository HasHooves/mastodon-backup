#!/bin/bash

## This script requires that 'aws configure' has already been completed for the 'root' user.

#Stopping mastodon processes
systemctl stop mastodon-*

#Generating a database dump backup
su - mastodon -c "cd /home/mastodon/live && pg_dump -Fc mastodon_production > backup.dump"

#Moving the database backup
aws s3 mv /home/mastodon/live/backup.dump s3://<BUCKET NAME>/home/mastodon/live/backup.dump
#Copying important files
aws s3 cp /home/mastodon/live/.env.production s3://<BUCKET NAME>/home/mastodon/live/.env.production
aws s3 cp /var/lib/redis/dump.rdb s3://<BUCKET NAME>/var/lib/redis/dump.rdb
aws s3 cp /etc/nginx/sites-available/ s3://<BUCKET NAME>/etc/nginx/sites-available/ --recursive
aws s3 cp /opt/backup s3://<BUCKET NAME>/opt/backup --recursive

#Starting the mastodon processes
systemctl start mastodon-web mastodon-sidekiq mastodon-streaming
