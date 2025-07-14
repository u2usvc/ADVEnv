#!/bin/bash
RED='\e[0;31m'
YELLOW='\e[0;33m'
GREEN='\e[0;32m'
NC='\e[0m' # No Color
set -e

read -p "Do you want to run the Terraform steps? [y/N]: " run_tf
run_tf=${run_tf,,}  # Convert to lowercase

if [[ "$run_tf" == "y" || "$run_tf" == "yes" ]]; then
  cd ./terraform/

  echo -e "${YELLOW}###########################################${NC}"
  echo -e "${YELLOW}[X] Destroying existing plan if any${NC}"
  echo -e "${YELLOW}###########################################${NC}"
  sleep 5
  terraform destroy -auto-approve
  echo -e "${YELLOW}###########################################${NC}"
  echo -e "${YELLOW}[X] Providing the cluster${NC}"
  echo -e "${YELLOW}###########################################${NC}"
  sleep 5
  terraform apply -auto-approve && echo -e "${GREEN}[+] Cluster is deployed${NC}"
  cd ..
else
  echo -e "${YELLOW}[!] Skipping Terraform steps${NC}"
fi

echo -e "${YELLOW}###########################################${NC}"
echo -e "${YELLOW}[X] About to provision the cluster${NC}"
echo -e "${YELLOW}[X] Passing execution flow to Ansible${NC}"
echo -e "${YELLOW}###########################################${NC}"
sleep 4
cd ./ansible/
. ./bin/activate

sed -i '/192.168.125.11\|192.168.125.12\|192.168.125.101\|192.168.125.102/d' ~/.ssh/known_hosts
python -m ansible playbook -i inventory.ini ./main_imports.yml

cd ../

