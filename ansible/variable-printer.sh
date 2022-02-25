# sudo chmod 755 variable-printer.sh
# ./variable-printer.sh
ansible -i inventories/ubuntu/hosts all -m ping
ansible -i inventories/ubuntu/hosts all -a '/usr/bin/uptime'
ansible-playbook -i inventories/ubuntu/hosts playbooks/ubuntu/system-updates-playbook.yml --ask-become-pass -vv
