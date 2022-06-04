#!/usr/bin/env bash

<<DESC
@ FileName   : controllersetup.sh
@ Description: Setup Controller server
@ Usage      : bash controllersetup.sh
DESC

function main() {
  # Install Ansible
  sudo apt-add-repository ppa:ansible/ansible -y
  sudo apt update
  sudo apt install ansible -y
  git clone https://github.com/mitkar241/config-management.git
  # Install vscode
  sudo snap install code --classic
}

main "$@"
