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

dnf module disable nodejs -y  &>> $LOGFILE

validate $? "disable nodejs"  

dnf module enable nodejs:18 -y  &>> $LOGFILE

validate $? "enable nodejs:18"  

dnf install nodejs -y     &>> $LOGFILE

validate $? "install node-js"  

id  roboshop 
if [ $? -ne 0 ]
then 
   useradd roboshop   
   validate $? "roboshop user creation"
else 
echo -e "roboshop user already exist $Y skipping $N"
fi


validate $? "create roboshop"   

mkdir -p /app       &>> $LOGFILE

validate $? "create directory"   

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip   &>> $LOGFILE

validate $? "download cart application" 

cd /app   &>> $LOGFILE


unzip -o /tmp/cart.zip  &>> $LOGFILE

validate $? "unzip cart application"  

cd /app

npm install  &>> $LOGFILE

validate $? "installing dependcies"  


cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service   &>> $LOGFILE

validate $? "copying the catalogue service file" 


systemctl daemon-reload   &>> $LOGFILE

validate $? "daaemon-reload"  

systemctl enable cart   &>> $LOGFILE

validate $? "enabling cart"

systemctl start cart     &>> $LOGFILE

validate $? "starting cart"
