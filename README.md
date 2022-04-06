# vegaform
---
`description` : Vagrant based Repo to setup development environment.

<img src="static/vegaform-logo.png" alt="vegaform-logo" width="200" height="200" />

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
├── config
│   ├── cred.yaml
│   ├── osflavour.json
│   └── server.json
├── README.md
├── script
│   ├── adduser.sh
│   ├── controllersetup.sh
│   ├── deluser.sh
│   ├── dnsresolv.sh
│   ├── dnsserver.sh
│   ├── guicustomise.sh
│   ├── installbasicpkg.sh
│   └── refreshpkg.sh
├── shared
│   └── README.md
├── Vagrantfile
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
