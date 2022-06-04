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

def scpScript(node, username, scriptname)
  node.vm.provision :file, source: "script/#{scriptname}", destination: "/tmp/#{scriptname}", run: "always"
  node.vm.provision :shell, :inline => "sudo chmod 777 /tmp/#{scriptname}; sudo mv /tmp/#{scriptname} /home/#{username}/#{scriptname};", run: "always"
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
      node.vm.provision :shell, path: "script/adduser.sh", args: [username, password], run: "always"
      node.vm.provision :shell, path: "script/installbasicpkg.sh", run: "always"
      node.vm.provision :shell, path: "script/dnsresolv.sh", run: "always"
      if machine["hostname"]["applicn-01"] then
        node.vm.provision :shell, path: "script/dnsserver.sh", run: "always"
      end
      if machine["hostname"]["control"] then
        node.vm.synced_folder "shared", "/shared" #"/home/#{username}/shared" #, type: "nfs"
        scpScript(node, username, "refreshpkg.sh")
        scpScript(node, username, "controllersetup.sh")
        scpScript(node, username, "guicustomise.sh")
      end
      node.vm.provision :shell, path: "script/deluser.sh", args: "vagrant", run: "always"
    end
  end
end
