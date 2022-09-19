COMPONENT=mongodb
source common.sh

echo Setup YUM repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
StatusCheck

echo Install Mongodb
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo Update MONGODB Listen  Address
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
StatusCheck

echo Start Mongodb Service
systemctl enable mongod &>>${LOG} && systemctl restart mongod &>>${LOG}
StatusCheck

DOWNLOAD

echo "Extracting Schema Files"
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load Schema
cd mongodb-main
for schema in catalogue.js users.js ; do
  mongo <  $schema
done
StatusCheck
