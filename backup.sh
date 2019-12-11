#!/bin/bash

#Get the relative path of the backup script
    backup_script=$(dirname "$realpath $0")

#Loading the Config
    source $backup_script/config.sh

#Stopping mastodon processes
    systemctl stop mastodon-*

#Generating a database dump backup
    su - mastodon -c "cd /home/mastodon/live && pg_dump -Fc mastodon_production > backup.dump"

#Moving the database backup
    aws s3 mv /home/mastodon/live/backup.dump s3://$s3_bucket_name/$backup_folder_name/home/mastodon/live/backup.dump
#Copying important files
    aws s3 cp /home/mastodon/live/.env.production s3://$s3_bucket_name/$backup_folder_name/home/mastodon/live/.env.production
    aws s3 cp /var/lib/redis/dump.rdb s3://$s3_bucket_name/$backup_folder_name/var/lib/redis/dump.rdb
    aws s3 cp /etc/nginx/sites-available/ s3://$s3_bucket_name/$backup_folder_name/etc/nginx/sites-available/ --recursive
    aws s3 cp /etc/elasticsearch/jvm.options s3://$s3_bucket_name/$backup_folder_name/etc/elasticsearch/jvm.options

#Starting the mastodon processes
    systemctl start mastodon-web mastodon-sidekiq mastodon-streaming
