# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
@description: Vagrantfile to deploy with custom user and no vagrant user
@resources:
  - https://www.vagrantup.com/docs
  - https://www.virtualbox.org/manual/ch08.html#vboxmanage-cmd-overview
=end

require "yaml"

VAGRANTFILE_API_VERSION = "2"

def execScript(node, scriptPath, args = [])
  node.vm.provision :shell, path: "scripts/#{scriptPath}", args: args, run: "always"
end

def scpScript(node, scriptPath, dstPath)
  scriptName = scriptPath.split('/')[-1]
  node.vm.provision :file, source: "scripts/#{scriptPath}", destination: "/tmp/#{scriptPath}", run: "always"
  node.vm.provision :shell, :inline => "sudo chmod 777 /tmp/#{scriptPath}; sudo mv /tmp/#{scriptPath} #{dstPath}/#{scriptName};", run: "always"
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |vbcfg|
  vbox = YAML.load_file("#{Dir.pwd}\\vbox.yaml")
  defaultCfg = YAML.load_file("#{Dir.pwd}\\values.yaml")
  # Make this default in case no arg
  customCfg = YAML.load_file("#{Dir.pwd}\\configs\\default.yaml")
  cfg = defaultCfg.merge(customCfg)
  
  cfg["server"].each do |machine|
    vbcfg.vm.define machine["vbox"]["name"] do |node|
      
      ##########
      # UPDATE
      ##########
      unless Vagrant.has_plugin?("vagrant-vbguest")
        raise  Vagrant::Errors::VagrantError.new, "vagrant-vbguest plugin is missing. Please install it using 'vagrant plugin install vagrant-vbguest' and rerun 'vagrant up'"
      else
        vbcfg.vbguest.no_install  = true
        vbcfg.vbguest.auto_update = false
        vbcfg.vbguest.no_remote   = true
      end
      
      ##########
      # GENERAL
      ##########
      mcVbox = machine["image"]
      node.vm.box = vbox[mcVbox]["box"]
      unless Vagrant.has_plugin?("vagrant-disksize")
        raise  Vagrant::Errors::VagrantError.new, "vagrant-disksize plugin is missing. Please install it using 'vagrant plugin install vagrant-disksize' and rerun 'vagrant up'"
      else
        node.disksize.size = machine["disksize"]
      end
      node.vm.box_version = vbox[mcVbox]["box_version"]
      node.vm.hostname = machine["vbox"]["name"]
      node.vm.network "public_network", ip: machine["ip"]
      
      ##########
      # VIRTUALBOX
      ##########
      node.vm.provider "virtualbox" do |vb|
        vb.gui = vbox[mcVbox]["gui"]
        # Setting `default` : Oracle VM VirtualBox Manager -> File -> Preferences -> General -> Default Machine Folder
        vb.customize ["setproperty", "machinefolder", "#{Dir.pwd}\\vmlocation"] #'default'
        serverVbox = {}
        serverVbox.merge **cfg["vbox"], **machine["vbox"]
        serverVbox.each do |vbKey, vbVal|
          vb.customize ["modifyvm", :id, "--#{vbKey}", vbVal]
        end # script action
      end # Virtualbox

      ##########
      # SCRIPTS
      ##########
      node.vm.synced_folder "shared", "/shared" #"/home/#{cfg["cred"]["username"]}/shared" #, type: "nfs"
      machine["scripts"].each do |script|
        if script["action"] == "exec" then
          args = []
          if script.key?("args") && script["args"] != [] then
            args = script["args"]
          end
          if script["path"] == "linux-user/add-user.sh" && args == [] then
            args = [cfg["cred"]["username"], cfg["cred"]["password"]]
          end
          execScript(node, script["path"], args)
        elsif script["action"] == "scp" then
          dstPath = "/home/#{cfg["cred"]["username"]}"
          if script.key?("dst") then
            dstPath = script["dst"]
          end
          scpScript(node, script["path"], dstPath)
        end # script action
      end # machine scripts
      
    end # each node
  end # each server
end # vagrant
