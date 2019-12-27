#!/bin/bash

## CONFIG STUFF
    database_backup=true
    database_backup_user=mastodon
    database_name=mastodon_production
    database_dump_path=/home/mastodon/live/backup.dump

    elasticsearch_options=true
    elasticsearch_options_path=/etc/elasticsearch/jvm.options

    mastodon_root_path=/home/mastodon/live
    
    live_folder=false
    live_folder_path=/home/mastodon/live/public/system

    nginx_sites=true
    nginx_sites_path=/etc/nginx/sites-available/

    production_file=true
    production_file_path=/home/mastodon/live/.env.production

    redis_dump=true
    redis_dump_path=/var/lib/redis/dump.rdb
## End of CONFIG STUFF

#Get the relative path of the backup script
    backup_script=$(dirname "$realpath $0")

#Loading the Config
    source $backup_script/config/config.sh

#Stopping mastodon processes
    systemctl stop mastodon-*
if [ $live_folder -eq true ]
then
    $AWS s3 cp $live_folder_path s3://$s3_bucket_name/$backup_folder_name/$Live_folder_path
fi

if [ $database_backup -eq true ]
then
    #Generating a database dump backup
        su - $database_backup_user -c "cd $mastodon_root_path && pg_dump -Fc $database_name > $database_dump_path"

    #Moving the database backup
        $AWS s3 mv $database_dump_path s3://$s3_bucket_name/$backup_folder_name/$database_dump_path
fi

if [ $production_file -eq true ]
then
    $AWS s3 cp $production_file_path s3://$s3_bucket_name/$backup_folder_name/$production_file_path
fi

if [ $redis_dump -eq true ]
then
    $AWS s3 cp $redis_dump_path s3://$s3_bucket_name/$backup_folder_name/$redis_dump_path
fi

if [ $nginx_sites -eq true ]
then
    $AWS s3 cp $nginx_sites s3://$s3_bucket_name/$backup_folder_name/$nginx_sites --recursive
fi

if [ $elasticsearch_options -eq true ]
then
    $AWS s3 cp $elasticsearch_options_path s3://$s3_bucket_name/$backup_folder_name/$elasticsearch_options_path
fi

#Starting the mastodon processes
    systemctl start mastodon-web mastodon-sidekiq mastodon-streaming
