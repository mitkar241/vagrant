# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
@description: Vagrantfile to deploy with custom user and no vagrant user
@resources:
  - https://www.vagrantup.com/docs
  - https://www.virtualbox.org/manual/ch08.html#vboxmanage-cmd-overview
=end

require "yaml"
require "json"

file = File.open "#{Dir.pwd}\\config\\osflavour.json"
osflavour = JSON.load file
file.close

file = File.open "#{Dir.pwd}\\config\\server.json"
server = JSON.load file
file.close

cred = YAML.load_file("#{Dir.pwd}\\config\\cred.yaml")
groupname = cred["groupname"]
username = cred["username"]
password = cred["password"]

VAGRANTFILE_API_VERSION = "2"

def execScript(node, scriptPath, args = [])
  node.vm.provision :shell, path: "scripts/#{scriptPath}", args: args, run: "always"
end

def scpScript(node, username, scriptPath, args = [])
  node.vm.provision :file, source: "scripts/#{scriptPath}", destination: "/tmp/#{scriptPath}", run: "always"
  node.vm.provision :shell, :inline => "sudo chmod 777 /tmp/#{scriptPath}; sudo mv /tmp/#{scriptPath} /home/#{username}/#{scriptPath};", args: args, run: "always"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  server.each do |machine|
    config.vm.define machine["hostname"] do |node|
      # do following steps for gui only if possible
      # also attach logs
      unless Vagrant.has_plugin?("vagrant-vbguest")
        raise  Vagrant::Errors::VagrantError.new, "vagrant-vbguest plugin is missing. Please install it using 'vagrant plugin install vagrant-vbguest' and rerun 'vagrant up'"
      else
        config.vbguest.no_install  = true
        config.vbguest.auto_update = false
        config.vbguest.no_remote   = true
      end
      currflavour = machine["osflavour"]
      node.vm.box = osflavour[currflavour]["box"]
      unless Vagrant.has_plugin?("vagrant-disksize")
        raise  Vagrant::Errors::VagrantError.new, "vagrant-disksize plugin is missing. Please install it using 'vagrant plugin install vagrant-disksize' and rerun 'vagrant up'"
      else
        node.disksize.size = machine["disksize"]
      end
      node.vm.box_version = osflavour[currflavour]["box_version"]
      node.vm.hostname = machine["hostname"]
      node.vm.network "public_network", ip: machine["ip"]
      node.vm.provider "virtualbox" do |vb|
        vb.gui = osflavour[currflavour]["gui"]
        # Setting `default` : Oracle VM VirtualBox Manager -> File -> Preferences -> General -> Default Machine Folder
        vb.customize ["setproperty", "machinefolder", "#{Dir.pwd}\\vmlocation"] #'default'
        vb.customize ["modifyvm", :id, "--groups", "/#{groupname}"]
        # General.basic
        vb.customize ["modifyvm", :id, "--name", machine["hostname"]]
        # General.Advanced
        vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
        vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
        # System.Motherboard
        vb.customize ["modifyvm", :id, "--memory", machine["ram"]]
        # Display.Screen
        vb.customize ["modifyvm", :id, "--vram", machine["vram"]]
        vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
        # VRDE = VirtualBox Remote Desktop Extension
        vb.customize ["modifyvm", :id, "--vrde", "off"]
      end
      execScript(node, "linux-user/add-user.sh", [username, password])
      execScript(node, "linux-pkg/install-basic-pkg.sh")
      execScript(node, "dns-server/resolve-dns.sh")
      if machine["hostname"]["applicn-01"] then
        execScript(node, "dns-server/server-dns.sh")
      end
      if machine["hostname"]["control"] then
        node.vm.synced_folder "shared", "/shared" #"/home/#{username}/shared" #, type: "nfs"
        scpScript(node, username, "linux-pkg/refresh-pkg.sh")
        scpScript(node, username, "code-editor/vscode.sh")
        scpScript(node, username, "gui-customize/ubuntu-gui.sh")
      end
      execScript(node, "linux-user/del-user.sh", ["vagrant"])
    end
  end
end
