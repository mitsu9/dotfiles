#!/bin/sh

set -e

cd "$(dirname $0)"

ansible-playbook \
  -i 'localhost' \
  --extra-vars='@config.yml' \
  --ask-become-pass \
  playbook.yml
