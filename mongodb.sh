#!/bin/bash

source ./common.sh
app_name=mongodb

check_root

cp mongo.repo /etc/yum.repos.d/mongodb.repo &>>$log_file
VALIDATE $? " copying the mongo file " 

dnf install mongodb-org -y &>>$log_file
VALIDATE $? "intalling mongodb server" 

systemctl enable mongod &>>$log_file
VALIDATE $? "enabling mongodb server" 
  
systemctl start mongod &>>$log_file
VALIDATE $? "starting the mongodb server" 

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf 
VALIDATE $?  " replacing the port "

systemctl restart mongod &>>$log_file
VALIDATE $? "restarted the mongodb server" 