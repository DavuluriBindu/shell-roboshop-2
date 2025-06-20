#!/bin/bash

source ./common.sh
app_name=shipping

check_root

echo "enter the mysql password"
read -s Mysql_root_pasw

app_setup
maven_setup
systemd_setup



dnf install mysql -y 
VALIDATE $? "instal mysql into shipping"

mysql -h mysql.devops84.site -u root -p$Mysql_root_pasw -e 'use cities'
if [ $? -ne 0 ]
then 
  mysql -h mysql.devops84.site -uroot -p$Mysql_root_pasw < /app/db/schema.sql
  mysql -h mysql.devops84.site -uroot -p$Mysql_root_pasw < /app/db/app-user.sql 
  mysql -h mysql.devops84.site -uroot -p$Mysql_root_pasw  < /app/db/master-data.sql
 VALIDATE $? "loading data to mysql"
else
   echo -e "data already present "
fi

systemctl restart shipping
VALIDATE $? "restarting shipping"
