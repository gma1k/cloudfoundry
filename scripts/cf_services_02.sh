#!/bin/bash

echo "Do you want to login to Cloud Foundry? (y/n)"
read LOGIN

if [ "$LOGIN" == "y" ]; then
  echo "Enter your username:"
  read -s USERNAME
  echo "Enter your password:"
  read -s PASSWORD
  
  cf login -u $USERNAME -p $PASSWORD -a API_ENDPOINT -o ORG
else
  echo "Skipping the login"
fi

SPACES=$(cf spaces | tail -n +4)
for SPACE in $SPACES; do
  cf target -s $SPACE
  SERVICES=$(cf services | tail -n +4)
  echo "$SERVICES" | tee -a services.txt

done

echo "Do you want to logout from Cloud Foundry? (y/n)"
read LOGOUT

if [ "$LOGOUT" == "y" ]; then
  cf logout
else
  echo "Skipping the logout"
fi
