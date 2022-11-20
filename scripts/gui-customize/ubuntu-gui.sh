#!/usr/bin/env bash

<<DESC
@ FileName   : guicustomise.sh
@ Description: Customise GUI of Ubuntu
@ Usage      : bash guicustomise.sh
@ Notes      :
  - gsettings get | set | reset
  - gsettings list-schemas
  - gsettings list-recursively
  - gsettings list-keys org.gnome.desktop.interface
DESC

function main() {
  # Getting Wallpaper
  #wallpaper_loc=$(pwd)/wallpaper.png
  #wget -O $wallpaper_loc "<image-link>"
  wallpaper_loc="/usr/share/backgrounds/brad-huchteman-stone-mountain.jpg"
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
}

main "$@"
