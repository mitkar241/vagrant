#!/usr/bin/env bash

<<DESC
@ FileName   : dnsresolv.sh
@ Description: config DNS resolver in linux
@ Usage      : bash dnsresolv.sh
DESC

function dns_resolv_ubuntu() {
  git clone https://github.com/raktimhalder241/networking.git
  cd networking/dns/scripts/
  sudo bash resolvconf.sh
  cd
  rm -rf networking/
}

function dns_resolv_centos() {
  git clone https://github.com/raktimhalder241/networking.git
  cd networking/dns/scripts/
  sudo bash resolvconf.sh
  cd
  rm -rf networking/
}

function main() {
  source /etc/os-release
  if [[ "$ID_LIKE" == "debian" && "$ID" == "ubuntu" ]]; then
    dns_resolv_ubuntu
  elif [[ "$ID_LIKE" == "rhel fedora" && "$ID" == "centos" ]]; then
    dns_resolv_centos
  else
    echo "Unknown OS / Flavour"
  fi
}

main "$@"
