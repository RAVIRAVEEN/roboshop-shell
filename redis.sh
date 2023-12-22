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


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>> $LOGFILE

validate $? "install redis "

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

validate $? "enable redis "


sed -i 's/127.0.0.1/0.0.0.0/g'   /etc/redis/redis.conf  &>> $LOGFILE

validate $? "remote access "

systemctl enable redis

validate $? "enable redis "

systemctl start redis

validate $? "start redis "

