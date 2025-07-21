#!/bin/bash

userid=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
logs_folder="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
log_file="$logs_folder/$SCRIPT_NAME.log"
script_dir=$PWD

mkdir -p $logs_folder
echo "script started executing at:$(date)" | tee -a $log_file

app_setup(){
    id roboshop
    if [ $? -ne 0 ]
    then
       useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
       VALIDATE $? "creating a user"
    else 
       echo -e "system user roboshop is present"
    fi

    mkdir -p /app 
    VALIDATE $? "creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$log_file
    VALIDATE $? "downloading $app_name"

    rm -rf /app/*
    cd /app 
    unzip /tmp/$app_name.zip &>>$log_file
    VALIDATE $? "unzip the $app_name file"
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$log_file
    VALIDATE $? "disabling the nodejs"

    dnf module enable nodejs:20 -y &>>$log_file
    VALIDATE $? "enable the nodejs:20"

    dnf install nodejs -y &>>$log_file
    VALIDATE $? "installing the nodejs"

    npm install  &>>$log_file
    VALIDATE $? "download the dependency"

}

maven_setup(){
    dnf install maven -y
    VALIDATE $? "installing maven "

    mvn clean package 
    VALIDATE $? "packaging the shipping application"

    mv target/shipping-1.0.jar shipping.jar 
    VALIDATE $? "moving and renaming the jar file"
}

python_setup(){
    dnf install python3 gcc python3-devel -y &>>$log_file
    VALIDATE $? "Install Python3 packages"

    pip3 install -r requirements.txt &>>$log_file
    VALIDATE $? "Installing dependencies"

    cp $script_dir/payment.service /etc/systemd/system/payment.service &>>$log_file
    VALIDATE $? "Copying payment service"

}

systemd_setup(){
    cp $script_dir/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "copied the $app_name service file"

    systemctl daemon-reload &>>$log_file
    systemctl enable $app_name  &>>$log_file
    systemctl start $app_name
    VALIDATE $? "start the $app_name service"

}

check_root(){
    if [ $userid -ne 0 ]
    then 
       echo -e "$R error:: please run the script with root user $N" | tee -a $log_file
       exit 1
    else
       echo "you are running with root user" | tee -a $log_file
    fi
}

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e " $2 is ... $G success $N" | tee -a $log_file
    else 
        echo -e " $2 is ... $R failure $N" | tee -a $log_file
    fi
}