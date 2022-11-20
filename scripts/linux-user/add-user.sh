#!/usr/bin/env bash

<<DESC
@ FileName   : adduser.sh
@ Description: Addition of linux user
@ Usage      : bash adduser.sh
DESC

function add_user_ubuntu() {
  username="$1"
  password="$2"
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo useradd -p $(openssl passwd -crypt "$password") -m -s /bin/bash "$username"
  sudo usermod -aG sudo "$username"
  #sudo apt install ubuntu-desktop-minimal -y
}

function add_user_centos() {
  username="$1"
  password="$2"
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo useradd -p $(openssl passwd -crypt "$password") -m -s /bin/bash "$username"
  sudo usermod -aG wheel "$username"
  #sudo apt install ubuntu-desktop-minimal -y
}

function main() {
  username="$1"
  password="$2"
  source /etc/os-release
  if [[ "$ID_LIKE" == "debian" && "$ID" == "ubuntu" ]]; then
    add_user_ubuntu "$username" "$password"
  elif [[ "$ID_LIKE" == "rhel fedora" && "$ID" == "centos" ]]; then
    add_user_centos "$username" "$password"
  else
    echo "Unknown OS / Flavour"
  fi
}

main "$@"
