#!/bin/bash

source ./common.sh
app_name=payment

check_root
app_setup
systemd_setup

dnf install python3 gcc python3-devel -y &>>$log_file
VALIDATE $? "installing the python "


pip3 install -r requirements.txt &>>$log_file
VALIDATE $? "installing dependencies"


