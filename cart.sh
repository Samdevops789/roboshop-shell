echo Setting Node Js repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi

echo Installing Node Js
yum install nodejs -y &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi
echo Adding a Application User
useradd roboshop &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi

echo Downloading the Application Content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"&>>/tmp/cart.log
cd /home/roboshop &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi

echo Cleaning old application content
rm -rf cart &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi
echo Extract Application Archive
unzip -o /tmp/cart.zip &>>/tmp/cart.log
mv cart-main cart &>>/tmp/cart.log
cd cart &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi

echo Installing Node Js Dependicies
npm install &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi

echo Configuring the Cart SystemD Service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log
systemctl start cart &>>/tmp/cart.log
systemctl enable cart &>>/tmp/cart.log
if [$? -eq 0]; then
  echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    fi
