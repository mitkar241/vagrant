# Vagrant
---
Vagrant is a tool for building and distributing development environments.

<img src="static/vagrant-logo.png" alt="vagrant-logo" width="600" height="200" />

## Setup Project
---
```PS
vagrant --file=".\projects\kubernetes\kubeadm-c1a2\main.yaml" up
```

## Configure
---
- install [vagrant](https://www.vagrantup.com/downloads)
- open `command prompt` and run following commands to install `vagrant plugins`
```bash
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize
```
- clone this repo in any location.
- configure `username` and `password` in [cred.yaml](config/cred.yaml)
- configure setup intended in [server.json](config/server.json)
- open `command prompt` inside the folder and run
```
vagrant up
```

## Codebase Structure
---
```
.
├── docs
│   ├── design-doc.md
│   ├── README.md
│   └── vagrant-cli.md
├── projects
│   ├── default
│   │   ├── default-c1
│   │   │   ├── main.yaml
│   │   │   ├── README.md
│   │   │   └── vagrant.log
│   │   └── README.md
│   ├── kubernetes
│   │   ├── config
│   │   │   ├── config
│   │   │   ├── join.sh
│   │   │   └── token
│   │   ├── kubeadm-c1a2
│   │   │   ├── main.yaml
│   │   │   ├── README.md
│   │   │   └── vagrant.log
│   │   └── README.md
│   └── README.md
├── README.md
├── scripts
│   ├── code-editor
│   │   ├── README.md
│   │   └── vscode.sh
│   ├── config-mgmt
│   │   ├── ansible.sh
│   │   └── README.md
│   ├── dns-server
│   │   ├── README.md
│   │   ├── resolve-dns.sh
│   │   └── server-dns.sh
│   ├── gui-customize
│   │   ├── README.md
│   │   └── ubuntu-gui.sh
│   ├── kubeadm
│   │   ├── common-kubeadm.sh
│   │   ├── master-kubeadm.sh
│   │   ├── README.md
│   │   └── worker-kubeadm.sh
│   ├── linux-pkg
│   │   ├── install-basic-pkg.sh
│   │   ├── README.md
│   │   └── refresh-pkg.sh
│   ├── linux-user
│   │   ├── add-user.sh
│   │   ├── del-user.sh
│   │   └── README.md
│   └── README.md
├── shared
│   └── README.md
├── static
│   └── vagrant-logo.png
├── Vagrantfile
├── values.yaml
├── vbox-image.yaml
└── vmlocation
    └── README.md
```

## Resource
---
- [ ] [Vagrant create local box](https://gist.github.com/kekru/a76ba9d0592ce198f09f6ba0cefa5afb)

## TODO
---
- [ ] Need to make Hostname's DNS resolution dynamic
- [ ] Check if `Windows` / `macOS` vagrant box is possible
  - `windows`: *failed*. one hint would be to use `usb1`
  - `usb3` fails always
