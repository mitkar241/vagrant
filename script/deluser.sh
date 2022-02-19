#!/usr/bin/env bash

<<DESC
@ FileName   : deluser.sh
@ Description: Deletion of linux user
@ Usage      : bash deluser.sh
DESC

function del_user_ubuntu() {
  username="$1"
  # removing user from '/etc/passwd' removes user from login screen
  sudo usermod --expiredate 1 $username
  sudo sed -i "/$username/d" /etc/passwd
  #sudo service gdm3 restart
  # for proper cleanup run this command on first login
  #sudo userdel -r $username
}

function del_user_centos() {
  username="$1"
  # removing user from '/etc/passwd' removes user from login screen
  sudo usermod --expiredate 1 $username
  sudo sed -i "/$username/d" /etc/passwd
  #sudo service gdm3 restart
  # for proper cleanup run this command on first login
  #sudo userdel -r $username
}

function main() {
  username="$1"
  source /etc/os-release
  if [[ "$ID_LIKE" == "debian" && "$ID" == "ubuntu" ]]; then
    del_user_ubuntu $username
  elif [[ "$ID_LIKE" == "rhel fedora" && "$ID" == "centos" ]]; then
    del_user_centos $username
  else
    echo "Unknown OS / Flavour"
  fi
}

main "$@"
