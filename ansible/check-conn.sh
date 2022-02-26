# sudo chmod 755 variable-printer.sh
# ./variable-printer.sh
ansible all -i inventories/ubuntu/hosts -m ping
ansible all -i inventories/ubuntu/hosts -a '/usr/bin/uptime'
