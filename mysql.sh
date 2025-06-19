#!/bin/bash
source ./common.sh
app_name=mysql

check_root

echo "enter the root password "
read -s Mysql_Root_pasw -a 


dnf install mysql-server -y &>>$log_file
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$log_file
VALIDATE $? "enabling the mysql"
systemctl start mysqld &>>$log_file
VALIDATE $? "starting the mysql" 

mysql_secure_installation --set-root-pass $Mysql_Root_pasw &>>$log_file
VALIDATE $? "setting the root password"