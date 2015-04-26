#!/bin/sh

echo "Running stage1..."
ansible-playbook -e @local-vars.yml stage1.yml

echo "Running stage2..."
ansible-playbook -e @local-vars.yml stage2.yml

echo "System configured! It's time to reboot now. Have fun!"
