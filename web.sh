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
     echo -e "$G You are the Root User proceeding the web configuration $N"
else
     echo -e "$R ERROR :: you are not Root User provide the root access to web configuration $N"
     exit 1
fi #end the condition

dnf install nginx -y &>>$LOG

VALID $? "install nginx" 

systemctl enable nginx &>>$LOG

VALID $? "enabled nginx" 

systemctl start nginx &>>$LOG

VALID $? "service starting nginx" 

rm -rf /usr/share/nginx/html/* &>>$LOG

VALID $? "Removing the default content of the web"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOG

VALID $? "Downloading the frontend content"

cd /usr/share/nginx/html &>>$LOG

VALID $? "changing directory in to html folder"

unzip -o /tmp/web.zip &>>$LOG

VALID $? "unzipping frontend content"

cp /home/centos/roboshop-shellscript/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOG

VALID $? "copying roboshop reverse proxy config"

systemctl restart nginx &>>$LOG

VALID $? "restart nginx"













