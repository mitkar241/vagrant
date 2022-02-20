#!/usr/bin/env bash

<<DESC
@ FileName   : installbasicpkg.sh
@ Description: Bootstrapping VMs
@ Usage      : bash installbasicpkg.sh
DESC

<<DESC
Bootstrapping a software project requires special considerations,
especially when the product concept isn't completely defined.
As one undertakes a project, many of the pieces that need to be built may not be fully designed or completely developed.
All of this wreaks havoc on a development schedule.
Bootstrapping is the process of getting a software development project moving from a standing start. 
DESC

# exit when a command fails
set -o errexit

##########
# GIT
##########
#git config --global user.name "$gitusername"
#git config --global user.email "$gitemail"
#git config --list
install_git(){
    #if hash /usr/bin/git 2>/dev/null; then
    #if [ -x "$(hash /usr/bin/git)" ] ; then
    if command -v /usr/bin/git &> /dev/null; then
        /usr/bin/git --version
    else
        echo "Installing Git ..."
        if [ -f /etc/redhat-release ]; then
            /usr/bin/yum -q -y install git
            install_git
        elif [ -f /etc/lsb-release ]; then
            /usr/bin/apt -q -y install git
            install_git
        fi
    fi
}

##########
# PYTHON3
##########
install_python3(){
    if command -v /usr/bin/python3 &> /dev/null; then
        /usr/bin/python3 --version
    else
        echo "Installing Python3 ..."
        if [ -f /etc/redhat-release ]; then
            /usr/bin/yum -q -y install python3
            install_python3
        elif [ -f /etc/lsb-release ]; then
            /usr/bin/apt -q -y install python3
            install_python3
        fi
    fi
}


##########
# CURL
##########
install_curl(){
    if command -v /usr/bin/curl &> /dev/null; then
        /usr/bin/curl --version
    else
        echo "Installing Curl ..."
        if [ -f /etc/redhat-release ]; then
            /usr/bin/yum -q -y install curl
            install_curl
        elif [ -f /etc/lsb-release ]; then
            /usr/bin/apt -q -y install curl
            install_curl
        fi
    fi
}

##########
# OPENSSH-SERVER
##########
install_openssh_server(){
    if command -v /usr/bin/openssh-server &> /dev/null; then
        /usr/bin/openssh-server --version
    else
        echo "Installing Openssh-Server ..."
        if [ -f /etc/redhat-release ]; then
            /usr/bin/yum -q -y install openssh-server
            install_openssh_server
        elif [ -f /etc/lsb-release ]; then
            #dpkg -l openssh-server
            /usr/bin/apt -q -y install openssh-server
            install_openssh_server
        fi
    fi
}

##########
# OPENSSH-CLIENT
##########
install_openssh_client(){
    if command -v /usr/bin/openssh-client &> /dev/null; then
        /usr/bin/openssh-client --version
    else
        echo "Installing Openssh-Client ..."
        if [ -f /etc/redhat-release ]; then
            /usr/bin/yum -q -y install openssh-clients
            install_openssh_client
        elif [ -f /etc/lsb-release ]; then
            #dpkg -l openssh-client
            /usr/bin/apt -q -y install openssh-client
            install_openssh_client
        fi
    fi
}

function main() {
  install_git
  install_python3
  install_curl
  #install_openssh_server
  #install_openssh_client
}

main "$@"
