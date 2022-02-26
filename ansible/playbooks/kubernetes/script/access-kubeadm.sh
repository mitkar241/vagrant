#!/usr/bin/env bash
# desc: To be able to run kubectl commands as non-root user
# usage:
#   - chmod +x access-kubeadm.sh
#   - ./access-kubeadm.sh "$USER" "$HOME"

function dockerAccess() {
  local USER="$1"
  groupadd docker 2>/dev/null
  sudo usermod -aG docker $USER
}

function kubeadmAccess() {
  local USER="$1"
  local HOME="$2"
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

USER="$1"
HOME="$2"
dockerAccess "$USER"
kubeadmAccess "$USER" "$HOME"
