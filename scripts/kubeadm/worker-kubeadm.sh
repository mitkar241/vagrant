#!/bin/bash
# Setup for Node servers
set -euxo pipefail

user="$1"

/bin/bash /vagrant/config/join.sh -v

sudo -i -u ${user} bash << EOF
whoami
mkdir -p /home/${user}/.kube
sudo cp -i /vagrant/config/config /home/${user}/.kube/
sudo chown 1000:1000 /home/${user}/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF
