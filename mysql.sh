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

    dnf module disable mysql -y &>>$LOG

    VALID $? "disabling mysql module"

    cp /home/centos/roboshop-shellscript/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOG

    VALID $? "Copying the sql repo file"

    dnf install mysql-community-server -y &>>$LOG

    VALID $? "installing mysql server"

    systemctl enable mysqld &>>$LOG

    VALID $? "enabling mysql server"

    systemctl start mysqld &>>$LOG

    VALID $? "starting the mysql service"

    mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG

    VALID $? "setting the mysql password"

    













