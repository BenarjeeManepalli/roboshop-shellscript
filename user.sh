#!/bin/bash
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

VALID $? "installing nodejs" 

id roboshop  &>>$LOG # Checking the roboshop user id 
if [ $? -eq 0 ]
then
    echo -e "$R ERROR::The user is already created $Y SKIPPING $N"
else 
     useradd roboshop
     VALID $? "roboshop user is creation" 
fi # End the consition

mkdir -p /app

VALID $? "app directory created" 

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOG

VALID $? " downloading User zip files" 

cd /app 

unzip  /tmp/user.zip

cd /app 

npm install  

VALID $? "installing the user module"

cp /home/centos/roboshop-shellscript/user.service /etc/systemd/system/user.service &>>$LOG

VALID $? "copying the user service file" 

systemctl daemon-reload &>>$LOG

VALID $? "daemon-reloaded" 

systemctl enable user &>>$LOG

VALID $? "enabled user" 

systemctl start user &>>$LOG

VALID $? "starting catalogue" 

cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG

VALID $? "created mongo.repo" 

dnf install mongodb-org-shell -y &>>$LOG

VALID $? "installed mongodb-org-shell"

mongo --host mongodb.manepallidevops.online </app/schema/user.js &>>$LOG

VALID $? "Loading schema data into MongoDB"

netstat -lntp

VALID $? "Port Check is"
