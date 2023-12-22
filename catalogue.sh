#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGO_DB_HOST="mongodb.devopsrank.online"

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started and exicuted at $TIMESTAMP" &>> $LOGFILE

validate(){
     if [ $1 -ne 0 ]
    then
     echo  -e  "Error :: $2......  $R FAILED $N"
     exit 1
    else
     echo  -e  "$2..... $G success $N"
    fi
}


if [ $ID -ne 0 ]
then
    echo -e " Error:: $R stop the script and run with root access $N"
    exit 1
else
    echo -e  " you are root user"
fi

dnf module disable nodejs -y  &>> $LOGFILE

validate $? "disable nodejs"  

dnf module enable nodejs:18 -y  &>> $LOGFILE

validate $? "enable nodejs:18"  

dnf install nodejs -y     &>> $LOGFILE

validate $? "install node-js" 

useradd roboshop     &>> $LOGFILE

validate $? "create user"  

mkdir /app        &>> $LOGFILE

validate $? "create directory" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

validate $? "download catalogue application" &>> $LOGFILE

cd /app 


unzip /tmp/catalogue.zip

validate $? "unzip catalogue application"  &>> $LOGFILE

cd /app

npm install 

validate $? "installing dependcies"  &>> $LOGFILE


cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service   &>> $LOGFILE

validate $? "copying the catalogue service file" &>> $LOGFILE


systemctl daemon-reload   &>> $LOGFILE

validate $? "daaemon-reload"  

systemctl enable  catalogue   &>> $LOGFILE

validate $? "enabling catalogue"

systemctl start catalogue     &>> $LOGFILE

validate $? "starting catalogue"


cp /home/centos/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo    &>> $LOGFILE

validate $? "copying mongodb file" &>> $LOGFILE




dnf install mongodb-org-shell -y      

validate $? "installing mongodb-org-shell "

mongo --host $MONGO_DB_HOST </app/schema/catalogue.js

validate $? "loading catalogue into mongodb "