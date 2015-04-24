#!/bin/sh

ansible-playbook stage1.yml
ansible-playbook stage2.yml

echo "System configured! It's time to reboot now. Have fun!"
