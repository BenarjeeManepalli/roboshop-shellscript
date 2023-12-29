#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%X)
LOG="/tmp/$0-$TIMESTAMP"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
P="\e[35m"
N="\e[0m"

VALID(){
  if [ $1 -eq 0 ]
  then
        echo -e "$Y $2 ... $G SUCCESS $N"
  else
        echo -e "$R ERROR :: $2 .... FAILED $N" 
  exit 1
  fi # Ending the condition
}

if [ $ID -eq 0 ]
then 
     echo -e "$G You are the Root User proceeding the catalogue configuration $N"
else
     echo -e "$R ERROR :: you are not Root User provide the root access to catalogue configuration $N"
     exit 1
fi #end the condition

dnf module disable nodejs -y &>>$LOG
VALID $? "module Disabled"
dnf module enable nodejs:18 -y &>>$LOG
VALID $? "enabled nodejs" 
dnf install nodejs -y &>>$LOG
VALID $? "installed nodejs" 

id roboshop  &>>$LOG # Checking the roboshop user id 

if [ $? -eq 0 ]
then
    echo -e "$R ERROR:: $Y The user is already created"
else 
     useradd roboshop
     VALID $? "roboshop user is creation" 
fi # End the consition

mkdir -p /app

VALID $? "app directory created" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOG

VALID $? " downloading catalogue zip file" 

cd /app 

unzip -o /tmp/catalogue.zip &>>$LOG

VALID $? "extract the catalogue zip file" 

cd /app

npm install &>>$LOG

cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>>$LOG

VALID $? "copying the catalogue service file" 

systemctl daemon-reload &>>$LOG

VALID $? "daemon-reloaded" 

systemctl enable catalogue &>>$LOG

VALID $? "enabled catalogue" 

systemctl start catalogue &>>$LOG

VALID $? "starting catalogue" 

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG

VALID $? "created mongo.repo" 

dnf install mongodb-org-shell -y &>>$LOG

VALID $? "installed mongodb-org-shell"

mongo --host mongodb.manepallidevops.online </app/schema/catalogue.js &>>$

VALID $? "Loading catalouge data into MongoDB"
netstat -lntp













