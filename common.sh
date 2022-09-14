StatusCheck() {
if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
     exit 1
    fi
    }

   NODEJS() {
     echo Setting NodeJs repos
     curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
     StatusCheck

     echo Installing NodeJs
     yum install nodejs -y &>>/tmp/cart.log
     StatusCheck


     id roboshop &>>/tmp/cart.log
     if [ $? -nq 0 ]; then
     echo Adding a Application User
     useradd roboshop &>>/tmp/cart.log
     StatusCheck
     fi

   }