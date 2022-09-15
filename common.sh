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

   NODEJS() {
     echo Setting NodeJs repos
     curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/${COMPONENT}.log
     StatusCheck

     echo Installing NodeJs
     yum install nodejs -y &>>/tmp/${COMPONENT}.log
     StatusCheck


     id roboshop &>>/tmp/${COMPONENT}.log
     if [ $? -ne 0 ]; then
     echo Adding a Application User
     useradd roboshop &>>/tmp/${COMPONENT}.log
     StatusCheck
     fi

    DOWNLOAD

    echo Cleaning old application content
    cd /home/roboshop &>>/tmp/${COMPONENT}.log && rm -rf ${COMPONENT} &>>/tmp/${COMPONENT}.log
    StatusCheck

     echo Extract Application Archive
     unzip -o /tmp/${COMPONENT}.zip &>>/tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>>/tmp/${COMPONENT}.log && cd ${COMPONENT} &>>/tmp/${COMPONENT}.log
     StatusCheck


     echo Installing NodeJs Dependcies
     npm install  &>>/tmp/${COMPONENT}.log
     StatusCheck

     echo Configuring the ${COMPONENT} SystemD Service
     mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>/tmp/${COMPONENT}.log && systemctl daemon-reload &>>/tmp/${COMPONENT}.log
     StatusCheck


     echo Starting and Enabling Application
     systemctl start ${COMPONENT} &>>/tmp/${COMPONENT}.log  &&  systemctl enable ${COMPONENT} &>>/tmp/${COMPONENT}.log
     StatusCheck
   }

   USER_ID=$(id -u)
   if [ $USER_ID -ne 0 ]; then
    echo -e "\e[31m You Should Run this script as a root user or sudo\e[0m"
    exit 1
    fi

 LOG=/tmp/${COMPONENT}.log
 rm -rf {LOG}