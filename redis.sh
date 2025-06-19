#!/bin/bash

source ./common.sh
app_name=redis

check_root

dnf module disable redis -y
VALIDATE $? "disabling the redis"

dnf module enable redis:7 -y
dnf install redis -y 
VALIDATE $? "installing the redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $?  " replacing the port "

systemctl enable redis
VALIDATE $? "enable the redis"

systemctl start redis 
VALIDATE $? "starting the redis"
