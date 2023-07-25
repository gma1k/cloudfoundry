#!/bin/bash

install_concourse_cli() {
  sudo apt update && sudo apt install curl gpg -y
  curl -s https://concourse-ci.org/KEY.gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://concourse-ci.org $(lsb_release -cs) main"
  sudo apt update && sudo apt install concourse -y
}

export_vault_url() {
  read -p "Enter your Vault server URL: " vault_url
  export CONCOURSE_VAULT_URL=$vault_url
  echo "CONCOURSE_VAULT_URL is set to $vault_url"
}

export_vault_ca_cert() {
  read -p "Enter the path to your CA cert for Vault: " ca_cert
  export CONCOURSE_VAULT_CA_CERT=$ca_cert
  echo "CONCOURSE_VAULT_CA_CERT is set to $ca_cert"
}

export_vault_token() {
  read -p "Enter your Vault token: " vault_token
  export CONCOURSE_VAULT_AUTH_CLIENT_TOKEN=$vault_token
  echo "CONCOURSE_VAULT_AUTH_CLIENT_TOKEN is set to $vault_token"
}

run_concourse_web() {
  read -p "Enter your postgres user: " postgres_user
  read -p "Enter your postgres password: " postgres_password
  read -p "Enter your postgres database: " postgres_database
  read -p "Enter your external url for Concourse web node: " external_url

  concourse web --postgres-user=$postgres_user --postgres-password=$postgres_password --postgres-database=$postgres_database --external-url=$external_url
}

install_concourse_cli
export_vault_url
export_vault_ca_cert
export_vault_token
run_concourse_web
