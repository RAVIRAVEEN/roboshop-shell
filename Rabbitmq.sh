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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash   &>> $LOGFILE

validate $? "downloading rabbitmq"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> $LOGFILE

validate $? "installing rabbitmq-server"

dnf install rabbitmq-server -y  &>> $LOGFILE

validate $? "installing rabbitmq"

systemctl enable rabbitmq-server  &>> $LOGFILE

validate $? "enabling rabbitmq"

systemctl start rabbitmq-server  &>> $LOGFILE

validate $? "starting rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE

validate $? "user password"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>> $LOGFILE

validate $? "setting permissions "