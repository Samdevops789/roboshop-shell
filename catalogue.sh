source common.sh

COMPONENT = catalogue
NODEJS



mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
StatusCheck

systemctl start catalogue
systemctl enable catalogue
StatusCheck


