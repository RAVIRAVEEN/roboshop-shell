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


dnf install maven -y       &>> $LOGFILE

validate $? "install maven"

id roboshop 

if [ $? -ne 0 ]
then 
useradd roboshop 

validate $?  "creating user" &>> $LOGFILE

else
echo -e "user already exist  $Y skipping $N"
fi

validate $? "user creation"

mkdir -p /app       &>> $LOGFILE

validate $? "creating directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip    &>> $LOGFILE


validate $? "downloading shipping"

cd /app   &>> $LOGFILE

unzip -o  /tmp/shipping.zip    &>> $LOGFILE

validate $? "unzipping shipping"

cd /app

mvn clean package    &>> $LOGFILE

validate $? "installing dependencies"

mv target/shipping-1.0.jar shipping.jar   &>> $LOGFILE

validate $? "moving shipping-1.0"

cp /home/centos/roboshop-shell/shipping.service  /etc/systemd/system/shipping.service   &>> $LOGFILE


validate $? "copying shipping service"

systemctl daemon-reload    &>> $LOGFILE

validate $? "reloading daemon"

systemctl enable shipping    &>> $LOGFILE

validate $? "enabling shipping"

systemctl start shipping    &>> $LOGFILE

validate $? "start shipping"

dnf install mysql -y   &>> $LOGFILE

validate $? "installing mysql"


mysql -h <mysql.devopsrank.online> -uroot -pRoboShop@1 < /app/schema/shipping.sql    &>> $LOGFILE

validate $? "schema loading"


systemctl restart shipping    &>> $LOGFILE

validate $? "restrtinng shipping"