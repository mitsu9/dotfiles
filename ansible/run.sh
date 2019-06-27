#!/bin/sh

set -e

cd "$(dirname $0)"

ansible-playbook -i 'localhost' playbook.yml
