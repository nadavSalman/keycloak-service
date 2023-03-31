#!/bin/bash
set -x




cd ../dev-infra
export VM_IP=$(terraform output public_ip_address)
cd ../provision-infra
ls -la
source .env
printf "\n Dev VM IP : %s\n user : %s\n private key full path : %s \n\n" $VM_IP $DEVOPS_USER $PRIVATE_KEY_PATH
chmod 600 $PRIVATE_KEY_PATH
ansible -m ping dev -vvv -i inventory.yaml 
ansible-playbook -vvv -i inventory.yaml provision-infrastructure-playbook.yaml
# ansible-playbook  -i inventory.yaml --user=$DEVOPS_USER provision-infrastructure-playbook.yaml