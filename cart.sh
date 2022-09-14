source common.sh

NODEJS
echo Downloading the Application Content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"&>>/tmp/cart.log
cd /home/roboshop &>>/tmp/cart.log
Starting

echo Cleaning old application content
rm -rf cart &>>/tmp/cart.log
StatusCheck

echo Extract Application Archive
unzip -o /tmp/cart.zip &>>/tmp/cart.log && mv cart-main cart &>>/tmp/cart.log
cd cart &>>/tmp/cart.log
StatusCheck


echo Installing Node Js Dependicies
npm install &>>/tmp/cart.log
StatusCheck


echo Configuring the Cart SystemD Service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log && systemctl daemon-reload &>>/tmp/cart.log
StatusCheck


echo Starting and Enabling Application
systemctl start cart &>>/tmp/cart.log && systemctl enable cart &>>/tmp/cart.log
StatusCheck