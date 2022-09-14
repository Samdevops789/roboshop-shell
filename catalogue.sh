source common.sh

NODEJS

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
unzip -o /tmp/catalogue.zip
StatusCheck

mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install
StatusCheck


mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
StatusCheck

systemctl start catalogue
systemctl enable catalogue
StatusCheck


