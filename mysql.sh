source common.sh

COMPONENT=mysql

if [ -z "$MYSQL_PASSWORD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWORD is missing\e[0m"
  exit 1
  fi

echo setup YUM repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo Install Mysql
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo Start MYSQL Service
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
StatusCheck

echo "show databases;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}
if [ $? -ne 0 ]; then
  echo Changing Default Password
  DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}
  StatusCheck
fi

echo "show plugins;" | mysql -uroot -p$MYSQL_PASSWORD 2>&1 | grep validate_password &>>${LOG}
if [ $? -eq 0 ]; then
  echo Remove Password Validate Plugin
  echo "uninstall plugin validate_password;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}
   StatusCheck
 f1

exit
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql