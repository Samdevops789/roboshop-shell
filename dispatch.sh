COMPONENT=dispatch

source common.sh

echo Install GoLang
yum install golang -y &>>${LOG}
StatusCheck

echo adding User
useradd roboshop &>>${LOG}

echo Dispatching
curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip &>>${LOG}

echo Extractibg dispatch
unzip -o /tmp/dispatch.zip &>>${LOG}
mv dispatch-main dispatch &>>${LOG}
cd dispatch &>>${LOG}
go mod init dispatch &>>${LOG}
go get &>>${LOG}
go build &>>${LOG}
StatusCheck

