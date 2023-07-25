#!/bin/bash

setup_vault() {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vault

  vault server -dev &

  export VAULT_ADDR='http://127.0.0.1:8200'
  export VAULT_TOKEN=$(vault print token)

  vault secrets enable -path=concourse kv

  read -p "Enter your docker username: " docker_username
  read -p "Enter your docker password: " docker_password
  read -p "Enter your cf username: " cf_username
  read -p "Enter your cf password: " cf_password
  read -p "Enter your db host: " db_host
  read -p "Enter your db port: " db_port
  read -p "Enter your db name: " db_name
  read -p "Enter your db user: " db_user
  read -p "Enter your db password: " db_password

  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/docker-username value=$docker_username
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/docker-password value=$docker_password
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/cf-username value=$cf_username
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/cf-password value=$cf_password
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/db-host value=$db_host
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/db-port value=$db_port
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/db-name value=$db_name
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/db-user value=$db_user
  vault kv put concourse/TEAM_NAME/PIPELINE_NAME/db-password value=$db_password

}

setup_vault
