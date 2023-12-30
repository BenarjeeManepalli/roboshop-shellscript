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
    fi # Ending the script
}
    if [ $ID -eq 0 ]
    then
        echo -e "$G you are the Root User proceeding the configuration"
    else
        echo -e "$R ERROR:: You are not root user please get the root access"
        exit 1
    fi # ending the condition

    dnf install maven -y &>>$LOG

    VALID $? "installing maven"

    id roboshop &>>$LOG # checking the user is exists or nor

    if [ $? -eq 0 ]
    then
        echo -e "$R ERROR:: User already exists $Y skipping $N"
    else
        echo -e "$G user is creating now $N"
        useradd roboshop
        VALID $? "roboshop user creation"
    fi # end of the condition

    mkdir -p /app &>>$LOG

    VALID $? "app folder creation"

    curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOG

    VALID $? "downloading the shipping"

    cd /app

    VALID $? "changing directory to app folder"

    unzip -o /tmp/shipping.zip &>>$LOG

    VALID $? "unzipping shipping"

    mvn clean package &>>$LOG

    VALID $? "Installing dependencies"

    mv target/shipping-1.0.jar shipping.jar &>>$LOG

    VALID $? "renaming the jar file"

    cp /home/centos/roboshop-shellscript/shipping.service /etc/systemd/system/shipping.service &>>$LOG

    VALID $? "copying the shipping service file"

    systemctl daemon-reload &>>$LOG

    VALID $? "daemon reload"

    systemctl enable shipping  &>>$LOG

    VALID $? "enable shipping"

    systemctl start shipping &>>$LOG

    VALID $? "starting the shipping service"

    dnf install mysql -y &>>$LOG

    VALID $? "installing mysql client"

    mysql -h mongodb.manepallidevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOG

    VALID $? "loading schema"

    systemctl restart shipping

    VALID $? "restarting the shipping service"
















