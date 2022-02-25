# Ansible
---
Website : [Ansible](https://www.ansible.com/)

![Ansible Logo](https://upload.wikimedia.org/wikipedia/commons/0/05/Ansible_Logo.png)

### What is Ansible?
Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs.

Designed for multi-tier deployments since day one, Ansible models your IT infrastructure by describing how all of your systems inter-relate, rather than just managing one system at a time.

It uses no agents and no additional custom security infrastructure, so it's easy to deploy - and most importantly, it uses a very simple language (YAML, in the form of Ansible Playbooks) that allow you to describe your automation jobs in a way that approaches plain English.
### TODO
---
- [ ] architecture of ansible
- [ ] roles
  - [ ] mysql
  - [ ] mongo
  - [ ] apache
- [ ] jinja2 templates
- [ ] variable scope, facts, include
- [ ] task, handler, tags
- [ ] encryption with vault
- [ ] running scripts in targets
- [x] vagrantfile
### Playbook Run Example
---
```bash
ansible-playbook playbooks/hybrid/pinger.yml -i inventories/hybrid/hosts -vv
```
### Playbook Run Options
---
- dry run: `--check`
- tags:
  - `--tags "centos"`
  - `--tags "update,upgrade"`
### Troubleshooting Playbooks
---
- `start-at-task` : To start executing your playbook at a particular task (usually the task that failed on the previous run), use the --start-at-task option.
```
--start-at-task="Autoremove apt packages for ubuntu systems"
```
- `step` : With this option, Ansible stops on each task, and asks if it should execute that task. Answer "y" to execute the task, answer "n" to skip the task, and answer "c" to exit step mode, executing all remaining tasks without asking.
```
--step
```
```
Perform task: TASK: Autoremove apt packages for ubuntu systems (N)o/(y)es/(c)ontinue: y

Perform task: TASK: Autoremove apt packages for ubuntu systems (N)o/(y)es/(c)ontinue: ***

TASK [Autoremove apt packages for ubuntu systems] ******************************
skipping: [host_ubuntu_1]
skipping: [host_ubuntu_2]
```
### Privilege Escalation
---
```
--ask-become-pass
```
### Set Up SSH Keys
---
- Create the RSA Key Pair

```bash
ssh-keygen
```
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/raktim/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/raktim/.ssh/id_rsa
Your public key has been saved in /home/raktim/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:0AmEUfv61FwCuduyCYCFyxZuXkBWL29GkN/RMW733YQ raktim@controller
The key's randomart image is:
+---[RSA 3072]----+
|  o.+*+  .o.     |
| o .oo +.+..   . |
|  + o.=.=.o . E .|
| o * +.o.+ . . o.|
|  B o + S . . . o|
| + . + . = o     |
|  .   o + +      |
|       + +       |
|        +        |
+----[SHA256]-----+
```

- Copy the Public Key to Ubuntu Server
```bash
ssh-copy-id raktim@backend-01.mitkar.io
ssh-copy-id raktim@backend-02.mitkar.io
ssh-copy-id raktim@backend-03.mitkar.io
ssh-copy-id raktim@backend-04.mitkar.io
```
```
The authenticity of host 'backend-01.mitkar.io (192.168.0.7)' can't be established.
ECDSA key fingerprint is SHA256:59tJXzYAKtdPYfvMc8Fl2P/kdXz2kQMxnQ6J8C+se/A.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
raktim@backend-01.mitkar.io's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'raktim@backend-01.mitkar.io'"
and check to make sure that only the key(s) you wanted were added.

```
### Ansible Installation
---
```bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
```
### List All Hosts
---
```bash
ansible-inventory --list -y -i inventories/hybrid/hosts
```
```
all:
  children:
    grp_hybrid:
      children:
        grp_centos:
          hosts:
            host_centos_1:
              ansible_host: backend-03.mitkar.io
              ansible_python_interpreter: /usr/bin/python3
              ansible_user: raktim
              groupTag: primary
              priority: '1'
              purpose: primary kworker
            host_centos_2:
              ansible_host: backend-04.mitkar.io
              ansible_python_interpreter: /usr/bin/python3
              ansible_user: raktim
              groupTag: primary
              purpose: primary kworker
        grp_ubuntu:
          hosts:
            host_ubuntu_1:
              ansible_host: backend-01.mitkar.io
              ansible_python_interpreter: /usr/bin/python3
              ansible_user: raktim
              groupTag: secondary
              priority: '2'
              purpose: secondary kworker
            host_ubuntu_2:
              ansible_host: backend-02.mitkar.io
              ansible_python_interpreter: /usr/bin/python3
              ansible_user: raktim
              groupTag: secondary
              purpose: secondary kworker
    ungrouped: {}
```
### Ping All Hosts
---
```bash
ansible all -m ping -i inventories/hybrid/hosts
```
```
host_ubuntu_1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
host_ubuntu_2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
host_centos_1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
host_centos_2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
### Execute command on Hosts
---
```bash
ansible -a '/usr/bin/uptime' all -i inventories/hybrid/hosts
```
```
host_ubuntu_1 | CHANGED | rc=0 >>
 15:56:30 up 10:00,  1 user,  load average: 0.00, 0.00, 0.00
host_ubuntu_2 | CHANGED | rc=0 >>
 15:56:30 up  9:57,  1 user,  load average: 0.14, 0.04, 0.01
host_centos_1 | CHANGED | rc=0 >>
 15:56:30 up  8:50,  2 users,  load average: 0.00, 0.00, 0.00
host_centos_2 | CHANGED | rc=0 >>
 15:56:30 up  8:50,  2 users,  load average: 0.08, 0.02, 0.01
```
