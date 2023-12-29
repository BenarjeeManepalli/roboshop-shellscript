#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F::%X)
LOG="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
P="\e[35m"
N="\e[0m"
VALID(){
    if [ $1 -eq 0 ]
    then
        echo -e "$Y $2 ---- $G success $N"
    else
        echo -e "$R ERROR::  $2 ---- Failed $N"
        exit 1
    fi 
}
    if [ $ID -eq 0 ]
    then
        echo -e "$G you are the Root User proceeding the configuration"
    else
        echo -e "$R ERROR:: You are not root user please get the root access"
        exit 1
    fi # ending the condition

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG

VALID $? "Downloading Redis RPM"

dnf module enable redis:remi-6.2 -y &>>$LOG

VALID $? "Redis module is enable"

dnf install redis -y &>>$LOG

VALID $? "Redis Database installation is"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

VALID $? "Allowing remote access is"

systemctl enable redis &>>$LOG

VALID $? "Enabling redis is"

systemctl start redis &>>$LOG

netstat -lntp




