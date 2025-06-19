#!/bin/bash

source ./common.sh

check_root


dnf module disable nginx -y &>>$log_file
VALIDATE $? "disabling the nginx"

dnf module enable nginx:1.24 -y &>>$log_file
VALIDATE $? "enabling the nginx"

dnf install nginx -y &>>$log_file
VALIDATE $? "installing the nginx"

systemctl enable nginx  &>>$log_file
systemctl start nginx  
VALIDATE $? "starting the nginx"

rm -rf /usr/share/nginx/html/* &>>$log_file
VALIDATE $? "removing the default content in nginx"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log_file
VALIDATE $? "downloading the frontent content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$log_file
VALIDATE $? "unzipping the content "

rm -rf /etc/nginx/nginx.conf &>>$log_file
VALIDATE $? "removing the default conf in nginx"

cp $script_dir/nginx.conf /etc/nginx/nginx.conf 
VALIDATE $? "copying to this path nginx conf"

systemctl restart nginx 
VALIDATE $? "restarting the nginx "