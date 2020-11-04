#!/bin/sh

set -e

cd "$(dirname $0)"

ansible-playbook \
  -i 'localhost' \
  --extra-vars='@config.yml' \
  playbook.yml
