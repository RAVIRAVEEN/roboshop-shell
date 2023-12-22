#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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


cp mongo.repo /etc/yum.repos.d/mongo.repo   &>> $LOGFILE

validate $? "copied mongodb repo "

dnf install mongodb-org -y   &>> $LOGFILE

validate $? "installing mongodb-org "

systemctl enable mongod   &>> $LOGFILE

validate $? "enable mongod "

sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/mongod.conf   &>> $LOGFILE

validate $? "remote access to mongodb "

systemctl restart mongod    &>> $LOGFILE

validate $? "restartng mongod" 