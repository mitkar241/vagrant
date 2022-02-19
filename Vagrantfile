# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
@description: Vagrantfile to deploy with custom user and no vagrant user
@resources:
  - https://www.virtualbox.org/manual/ch08.html#vboxmanage-cmd-overview
gsettings get | set | reset
gsettings list-schemas
gsettings list-recursively
gsettings list-keys org.gnome.desktop.interface
=end

require "json"

file = File.open "#{Dir.pwd}\\config\\osflavour.json"
osflavour = JSON.load file
file.close

file = File.open "#{Dir.pwd}\\config\\server.json"
server = JSON.load file
file.close

$DELUSERSCRIPT = <<-SCRIPT
# removing user from '/etc/passwd' removes user from login screen
sudo usermod --expiredate 1 vagrant
sudo sed -i '/vagrant/d' /etc/passwd
#sudo service gdm3 restart
# for proper cleanup run this command on first login
#sudo userdel -r vagrant
SCRIPT

$CTRLSCRIPT = <<-SCRIPT
# This is an executable.
# Usage: sudo ./controllerscript.sh
controllerscript=controllerscript.sh

# Usage: ./guiscript.sh
guiscript=guiscript.sh

# Getting Wallpaper
#wallpaper_loc=$(pwd)/wallpaper.png
#wget -O $wallpaper_loc "<image-link>"
wallpaper_loc="/usr/share/backgrounds/brad-huchteman-stone-mountain.jpg"

cat > $controllerscript <<EOF
# Install Ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update
sudo apt install ansible -y
git clone https://github.com/raktimhalder241/ansible.git
# Install vscode
sudo snap install code --classic
EOF

cat > $guiscript <<EOF
# Setting Favourite apps
dconf write /org/gnome/shell/favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'code_code.desktop', 'org.gnome.Terminal.desktop']"
# Setting Background
gsettings set org.gnome.desktop.background picture-uri file://$wallpaper_loc
# Setting Scale
gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
# Moving Taskbar to bottom
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
# Setting theme
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
# Setting Font
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'FreeMono Bold 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'FreeMono Bold 12'
gsettings set org.gnome.desktop.interface document-font-name 'FreeMono Bold 12'
gsettings set org.gnome.desktop.interface font-name 'FreeMono Bold 12'
EOF

sudo chmod 777 $controllerscript
mv ./$controllerscript /home/raktim/$controllerscript

sudo chmod 777 $guiscript
mv ./$guiscript /home/raktim/$guiscript

SCRIPT

$REFRESHSCRIPT = <<-SCRIPT
# Refresh packages
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  server.each do |machine|
    config.vm.define machine["hostname"] do |node|
      if Vagrant.has_plugin? "vagrant-vbguest"
        config.vbguest.no_install  = true
        config.vbguest.auto_update = false
        config.vbguest.no_remote   = true
      end
      currflavour = machine["osflavour"]
      node.vm.box = osflavour[currflavour]["box"]
      #node.vm.box_version = osflavour[currflavour]["box_version"]
      node.vm.hostname = machine["hostname"]
      node.vm.network "public_network", ip: machine["ip"]
      node.vm.provider "virtualbox" do |vb|
        vb.gui = osflavour[currflavour]["gui"]
        # Oracle VM VirtualBox Manager -> File -> Preferences -> General -> Default Machine Folder
        vb.customize ["setproperty", "machinefolder", "#{Dir.pwd}\\vmlocation"] #'default'
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
      username="raktim"
      password="12345678"
      node.vm.provision :shell, path: "script/adduser.sh", args: [username, password], run: "always"
      node.vm.provision :shell, path: "script/installbasicpkg.sh", run: "always"
      if machine["hostname"]["controller"] then
        node.vm.provision :shell, :inline => $CTRLSCRIPT, run: "always"
        node.vm.provision :shell, path: "script/dnsserver.sh", run: "always"
      end
      node.vm.provision :shell, path: "script/dnsresolv.sh", run: "always"
      node.vm.provision :shell, path: "script/deluser.sh", args: "vagrant", run: "always"
    end
  end
end
