#!/bin/bash

RANDOMIZER=$1
if [ -z $RANDOMIZER ]; then
  echo "Missing randomizer."
  exit
fi

AWS_PROFILE="personal"
OWNER="somber-waffle"
HOSTS_FILE="./hosts-$RANDOMIZER"
PROJECT_NAME="xyz"
SUBNETA_ID="subnet-03adda49"
SUBNETB_ID="subnet-aa0cae84"
VPC_ID="vpc-684da712"

export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible-vault-pass.txt

ansible-playbook \
  -vvv \
  playbook-absent.yml \
  --extra-vars "@vault.yml" \
  --extra-vars "ami_id=$AMI_ID" \
  --extra-vars "ansible_ssh_private_key_file=/home/medined/.ssh/odol-sango.pem" \
  --extra-vars "instance_profile_name=$INSTANCE_PROFILE_NAME" \
  --extra-vars "instance_type=t2.nano" \
  --extra-vars "key_name=odol-sango" \
  --extra-vars "owner=$OWNER" \
  --extra-vars "project_name=$PROJECT_NAME" \
  --extra-vars "randomizer=$RANDOMIZER" \
  --extra-vars "region_name=us-east-1" \
  --extra-vars "subnet_a_id=$SUBNETA_ID" \
  --extra-vars "subnet_b_id=$SUBNETB_ID" \
  --extra-vars "vpc_id=$VPC_ID"
