#!/usr/bin/env bash

<<DESC
@ FileName   : dnsserver.sh
@ Description: start DNS server in linux
@ Usage      : bash dnsserver.sh
DESC

function dns_server_ubuntu() {
  # Install bind9 for DNS
  sudo apt install bind9 -y
  cd
  git clone https://github.com/raktimhalder241/networking.git
  cd networking/dns/scripts/
  sudo bash bind9.sh
  cd
  rm -rf networking/
}

function dns_server_centos() {
  # Install bind9 for DNS
  sudo apt install bind9 -y
  cd
  git clone https://github.com/raktimhalder241/networking.git
  cd networking/dns/scripts/
  sudo bash bind9.sh
  cd
  rm -rf networking/
}

function main() {
  source /etc/os-release
  if [[ "$ID_LIKE" == "debian" && "$ID" == "ubuntu" ]]; then
    dns_server_ubuntu
  elif [[ "$ID_LIKE" == "rhel fedora" && "$ID" == "centos" ]]; then
    dns_server_centos
  else
    echo "Unknown OS / Flavour"
  fi
}

main "$@"
