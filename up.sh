#!/bin/sh

set -e

: ${DOTFILES_PATH:="$HOME/dotfiles"}

install_homebrew() {
  command -v 'brew' > /dev/null 2>&1 && return

  echo 'Install homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
  echo 'done'
}

install_ansible() {
  command -v 'ansible' > /dev/null 2>&1 && return

  echo 'Install ansible'
  brew install ansible
  echo 'Done'
}

run_ansible() {
  echo 'Run ansible'
  $DOTFILES_PATH/ansible/run.sh
  echo 'Done'
}

main() {
  install_homebrew
  install_ansible
  run_ansible
}

main
