COMPONENT=dispatch
source common.sh

echo Installing GOLang
yum install golang -y &>>${LOG}
StatusCheck

APP_USER_SETUP
DOWNLOAD
APP_CLEAN

echo init dispatch
go mod init dispatch &>>${LOG} && go get &>>${LOG} && go build &>>${LOG}
StatusCheck

SYSTEMD












