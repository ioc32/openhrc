#!/bin/sh

ansible-playbook bootstrap.yml
ansible-playbook ohrc.yml

echo "System configured! It's time to reboot now. Have fun!"
