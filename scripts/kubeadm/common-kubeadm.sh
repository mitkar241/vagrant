#!/bin/bash
# Common setup for all servers (Control Plane and Nodes)
set -euxo pipefail

# Variable Declaration
KUBERNETES_VERSION="1.23.6-00"
OS="xUbuntu_20.04"
RUNTIME="docker"
VERSION="1.23"

function disable_swap {
# disable swap
sudo swapoff -a
# keeps the swaf off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
}

function install_basics {
sudo apt update
sudo apt install -y apt-transport-https ca-certificates wget curl jq
}

function persis_reboot {
# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
}

function runtime_docker {
sudo apt update 
sudo apt install -y docker.io
sudo systemctl start docker

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker

echo "Docker runtime installed susccessfully"
}

function runtime_crio {
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

sudo apt update
sudo apt install cri-o cri-o-runc -y

sudo systemctl daemon-reload
sudo systemctl enable crio --now

echo "CRI runtime installed susccessfully"
}

function install_k8s {
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
}

function kubecfg {
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF
}

disable_swap
install_basics
persis_reboot

if [[ $RUNTIME = "docker" ]]
then
  echo "Current Runtime = $RUNTIME"
  runtime_docker
elif [[ $RUNTIME = "cri-o" ]]
then
  echo "Current Runtime = $RUNTIME"
  runtime_crio
else
  echo "Error : Unknown Runtime"
fi

install_k8s
kubecfg
