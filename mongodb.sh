#!/bin/bash
# Installing the MongoDB using shell script

ID=$(id -u)
TIMESTAMP=$(date +%F-%X)
LOG="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
P="\e[35m"
N="\e[0m"

echo "My Script started at $TIMESTAMP" $>>$LOG

VALID(){

    if [ $1 -eq 0 ]
then 
   echo -e "$P :: $2  $G Success $N"
else
   echo -e "$R ERROR :: $2 failure $N"
fi                   # ending the condition
}                    # FUNCTION IS END

if [ $ID -eq 0 ]
then

     echo -e "$G You are the root user please procced installation $N"
else
     echo -e "$R ERROR:: you are not root user $N"
exit 1
fi  # end of the condition
cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG
for PACKAGE in "mongodb-org"
do
   yum list installed $PACKAGE &>>$LOG
     if [ $? -ne 0 ]
     then
        echo "$G The $Package is instlling now $N "
        dnf install $Package -y &>>$LOG
        VALID $? "Installation of MongoDB"
    else
        echo -e "$P The MongoDB already installed $Y skipping now"
        exit 1
    fi     
done
systemctl enable mongod &>>$LOG
VALID $? "MongoDB enabled"
systemctl start mongod &>>$LOG
VALID $? "Mongodb service started"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG
VALID $? "mogodb.conf edited for remote access"
systemctl restart mongod
VALID $? "MongoDb service restart"



