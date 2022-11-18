#!/usr/bin/env bash

<<DESC
@ FileName   : controllersetup.sh
@ Description: Setup Controller server
@ Usage      : bash controllersetup.sh
DESC

function main() {
  # Install vscode
  sudo snap install code --classic
}

main "$@"
