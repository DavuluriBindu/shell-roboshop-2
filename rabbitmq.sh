#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root

cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$log_file
VALIDATE $? "copying the repo of rabbitmq"

dnf install rabbitmq-server -y &>>$log_file
VALIDATE $? "installing the rabbitmq"

systemctl enable rabbitmq-server &>>$log_file
VALIDATE $? "enabling the rabbitmq"
systemctl start rabbitmq-server &>>$log_file
VALIDATE $? "starting the rabbitmq"

rabbitmqctl add_user roboshop $Rabbitmq_pasw &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file