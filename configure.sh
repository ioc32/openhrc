#!/bin/sh

echo "Running playbook..."
ansible-playbook -i inventory -e @local-vars.yml main.yml

echo "System configured! It's time to reboot now. Have fun!"
