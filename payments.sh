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


dnf install python36 gcc python3-devel -y  &>> $LOGFILE


id  roboshop  &>> $LOGFILE
if [ $? -ne 0 ]
then 
   useradd roboshop   
   validate $? "roboshop user creation"
else 
echo -e "roboshop user already exist $Y skipping $N"
fi


mkdir  -p /app    &>> $LOGFILE

validate $? " making directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip   &>> $LOGFILE

validate $? " downloading payment zip"

cd /app 

validate $? " cchanging directory"

unzip -o /tmp/payment.zip  &>> $LOGFILE

validate $? " unzipping"

pip3.6 install -r requirements.txt  &>> $LOGFILE

validate $? " installing dependencies"

cp /home/centos/roboshop-shell/payment.service  /etc/systemd/system/payment.service  &>> $LOGFILE

validate $? " copying from payment.service"

systemctl daemon-reload  &>> $LOGFILE

validate $? " reloading daemon"

systemctl enable payment &>> $LOGFILE

validate $? " enabling payment"

systemctl start payment  &>> $LOGFILE

validate $? " starting payment"
