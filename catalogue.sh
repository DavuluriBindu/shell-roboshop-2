#!/bin/bash

source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
systemd_setup






cp $script_dir/mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "coping mongo repo file"

dnf install mongodb-mongosh -y &>>$log_file
VALIDATE $? "installing mongodb"

STATUS=$(mongosh --host mongodb.devops84.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt  0 ]
then
   mongosh --host mongodb.devops84.site </app/db/master-data.js &>>$log_file
   VALIDATE $? "loading  data in mongodb"
else 
   echo -e "already data loaded"
fi

