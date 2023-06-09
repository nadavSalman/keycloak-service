#!/bin/bash
set -x



# extract key for authenticate 
cd ../dev-infra
export VM_IP=$(terraform output public_ip_address)
cd ../provision-infra
ls -la


source .env
printf "\n Dev VM IP : %s\n user : %s\n private key full path : %s \n\n" $VM_IP $DEVOPS_USER $PRIVATE_KEY_PATH
chmod 600 $PRIVATE_KEY_PATH

# test connection
ansible -m ping dev -vvv -i inventory.yaml 

# Provition 
ansible-playbook -vvv -i inventory.yaml provision-infrastructure-playbook.yaml