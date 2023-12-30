#!/bin/bash
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

VALID $? "enable module nodejs" 

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

VALID $? "app directory creation" 

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOG

VALID $? "Downloading the cart zip file" 

cd /app 

VALID $? "changed directory in app folder" 

unzip -o /tmp/cart.zip &>>$LOG

VALID $? "unzipping cart folder" 

npm install  &>>$LOG

VALID $? "installing the Dependencies" 

cp /home/centos/roboshop-shellscript/cart.service /etc/systemd/system/cart.service

VALID $? "copying the cart service file" 

systemctl daemon-reload

VALID $? "daemon-reloaded" 

systemctl enable cart &>>$LOG

VALID $? "enabled cart" 

systemctl start cart &>>$LOG

VALID $? "starting the cart service" 






