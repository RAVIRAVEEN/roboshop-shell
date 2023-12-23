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


dnf module disable mysql -y   &>> $LOGFILE

validate $? " disabling mysql"

cp mysql.repo   /etc/yum.repos.d/mysql.repo     

validate $? "copying mysql repo"

dnf install mysql-community-server -y  &>> $LOGFILE

validate $? "installing mysql"

systemctl enable mysqld  &>> $LOGFILE

validate $? "enabling mysqld"

systemctl start mysqld   &>> $LOGFILE

validate $? "starting mysql"


mysql_secure_installation --set-root-pass RoboShop@1  &>> $LOGFILE

validate $? "mysql root password"

mysql -uroot -pRoboShop@1  &>> $LOGFILE

validate $? "setting mysql password"
