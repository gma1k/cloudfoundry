#!/bin/bash

create_mysql_service () {
  cf create-service p-mysql 100mb $1
  echo "Creating the MySQL service $1..."
  while cf service $1 | grep -q 'create in progress'
  do
    sleep 5
  done
  if cf service $1 | grep -q 'create succeeded'
  then
    echo "The MySQL service $1 is created successfully."
  else
    echo "The MySQL service $1 creation failed. Please check the logs for more details."
    exit 1
  fi
}

deploy_sugar_crm () {
  cf push $1 -m 512M -b php_buildpack --no-start
  cf bind-service $1 $2
  cf start $1
  echo "The application $1 is deployed and bound to the MySQL service $2."
}

create_domain () {
  read -p "Do you want to use your own domain or a custom new one? (Enter O for own or C for custom): " choice
  if [ "$choice" = "O" ]
  then
    cf create-domain my-org $1
    echo "The domain $1 is created."
  elif [ "$choice" = "C" ]
  then
    subdomain=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)
    cf create-domain my-org $subdomain.$1
    echo "The domain $subdomain.$1 is created."
    echo "Your subdomain is $subdomain."
  else
    echo "Invalid choice. Please enter O or C."
    exit 1
  fi  
}

map_route () {
   read -p "Do you want to use your own hostname or path? (Enter Y for yes or N for no): " choice
      if [ "$choice" = "Y" ] 
   then 
      read -p "Enter your hostname or path: " hostpath 
      cf map-route $1 $2 --hostname $hostpath 
      route=$hostpath.$2 
    
   elif [ "$choice" = "N" ] 
   then 
      cf map-route $1 $2 
      route=$2 
    
   else 
      echo "Invalid choice. Please enter Y or N." 
      exit 1 
   fi 

  echo "The route https://$route is mapped to the application $1."
}

update_certificates () {
  cf update-certificates --cert $1.crt --key $1.key --intermediate $2.crt
  echo "The certificates are updated."
}

read -p "Enter the name of the Sugar CRM folder: " folder
read -p "Enter the name of the MySQL service instance: " service
create_mysql_service $service
deploy_sugar_crm $folder $service

read -p "Enter the name of your custom domain or shared domain: " domain
create_domain $domain
map_route $folder $domain

read -p "Enter the name of your certificate file (without extension): " cert
read -p "Enter the name of your intermediate file (without extension): " intermediate

update_certificates $cert $intermediate
