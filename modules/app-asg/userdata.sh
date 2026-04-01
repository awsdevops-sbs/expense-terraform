#!/bin/bash

echo "Starting setup at $(date)" &>> /opt/ansible.log

#rm -f ~/*.json &>> /opt/ansible.log

#yum install -y python3-pip &>> /opt/ansible.log

#pip3 install ansible hvac &>> /opt/ansible.log

ansible-pull -i localhost, -U https://github.com/awsdevops-sbs/ansible.git get-secrets.yml \
-e role_name=${component} \
-e env=${env} \
-e vault_token=${vault_token} \
&>> /opt/ansible.log

ansible-pull -i localhost, -U https://github.com/awsdevops-sbs/ansible.git expense.yml \
-e role_name=${component} \
-e env=${env} \
-e vault_token=${vault_token} \
-e @~/secrets.json \
&>> /opt/ansible.log

echo "Completed setup at $(date)" &>> /opt/ansible.log