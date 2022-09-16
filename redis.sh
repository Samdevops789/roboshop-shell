source common.sh

COMPONENT=mongodb

echo Setup YUM repo
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
StatusCheck

echo Install Redis
yum install redis-6.2.7 -y &>>${LOG}
StatusCheck

echo Update REDIS Listen IP Address
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
StatusCheck

echo Start Redis Service
systemctl enable redis &>>${LOG} && systemctl restart redis &>>${LOG}
StatusCheck