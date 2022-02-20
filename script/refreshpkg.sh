#!/usr/bin/env bash

<<DESC
@ FileName   : dnsresolv.sh
@ Description: config DNS resolver in linux
@ Usage      : bash dnsresolv.sh
DESC

function refresh_pkg_ubuntu() {
  sudo apt update
  sudo apt -y upgrade
  sudo apt -y autoremove
}

function refresh_pkg_centos() {
  sudo yum check-update
  sudo yum clean all
  sudo yum update
  #sudo yum --security update
  sudo yum -y upgrade
  sudo yum -y autoremove
}

function main() {
  source /etc/os-release
  if [[ "$ID_LIKE" == "debian" && "$ID" == "ubuntu" ]]; then
    refresh_pkg_ubuntu
  elif [[ "$ID_LIKE" == "rhel fedora" && "$ID" == "centos" ]]; then
    refresh_pkg_centos
  else
    echo "Unknown OS / Flavour"
  fi
}

main "$@"
