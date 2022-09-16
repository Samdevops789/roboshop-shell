StatusCheck() {
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
     exit 1
    fi
    }

    DOWNLOAD()
     {
       echo Downloading ${COMPONENT} Application Content
       curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>/tmp/${COMPONENT}.log
      StatusCheck
    }

    APP_USER_SETUP() {
      id roboshop &>>${LOG}
      if [ $? -ne 0 ]; then
        echo Adding Application User
        useradd roboshop &>>${LOG}
        StatusCheck
      fi
    }

    APP_CLEAN() {
      echo Cleaning old application content
      cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
      StatusCheck

      echo Extract Application Archive
      unzip -o /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG} && cd ${COMPONENT} &>>${LOG}
      StatusCheck
    }

    SYSTEMD() {
      echo Configuring ${COMPONENT} SystemD Service
      mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload &>>${LOG}
      StatusCheck

      echo Starting ${COMPONENT} Service
      systemctl start ${COMPONENT} &>>${LOG} && systemctl enable ${COMPONENT} &>>${LOG}
      StatusCheck
    }

   NODEJS() {
    echo Setting NodeJS repos
      curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
      StatusCheck

      echo Installing NodeJS
      yum install nodejs -y &>>${LOG}
      StatusCheck

      APP_USER_SETUP
      DOWNLOAD
      APP_CLEAN

      echo Installing NodeJS Dependencies
      npm install &>>${LOG}
      StatusCheck

      SYSTEMD
    }

   JAVA() {
     echo Install Maven
     yum install maven -y &>>${LOG}
     StatusCheck

     APP_USER_SETUP
     DOWNLOAD
     APP_CLEAN

     echo Make application package
     mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}
     StatusCheck

     SYSTEMD
   }

   USER_ID=$(id -u)
   if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m You Should Run this script as a root user or sudo\e[0m"
    exit 1
    fi

 LOG=/tmp/${COMPONENT}.log
 rm -rf ${LOG}