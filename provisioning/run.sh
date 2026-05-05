#!/bin/sh

set -e

cd "$(dirname $0)"

ansible-playbook \
  -i 'localhost' \
  --ask-become-pass \
  playbook.yml
